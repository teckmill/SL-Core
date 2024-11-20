local SLCore = nil
local CoreReady = false

-- Initialize Database
local function InitializeDatabase()
    MySQL.ready(function()
        MySQL.Sync.execute([[
            CREATE TABLE IF NOT EXISTS `businesses` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `name` varchar(50) NOT NULL,
                `owner` varchar(60) DEFAULT NULL,
                `type` varchar(50) NOT NULL,
                `money` int(11) NOT NULL DEFAULT 0,
                `employees` text DEFAULT NULL,
                `inventory` text DEFAULT NULL,
                `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                PRIMARY KEY (`id`),
                UNIQUE KEY `name` (`name`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])

        MySQL.Sync.execute([[
            CREATE TABLE IF NOT EXISTS `business_grades` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `business_id` int(11) NOT NULL,
                `grade` int(11) NOT NULL,
                `name` varchar(50) NOT NULL,
                `salary` int(11) NOT NULL DEFAULT 0,
                PRIMARY KEY (`id`),
                KEY `business_id` (`business_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])

        print('^2[SL-Business] ^7Database tables initialized successfully')
    end)
end

-- Register Server Callbacks
local function RegisterCallbacks()
    if not CoreReady then return end

    SLCore.Functions.CreateCallback('sl-business:server:GetBusinesses', function(source, cb)
        local Player = SLCore.Functions.GetPlayer(source)
        if not Player then return cb({}) end
        
        local result = MySQL.Sync.fetchAll('SELECT * FROM businesses WHERE owner = ?', {
            Player.PlayerData.citizenid
        })
        cb(result)
    end)

    SLCore.Functions.CreateCallback('sl-business:server:GetEmployees', function(source, cb, businessId)
        local result = MySQL.Sync.fetchAll('SELECT * FROM business_employees WHERE business_id = ?', {
            businessId
        })
        cb(result)
    end)

    SLCore.Functions.CreateCallback('sl-business:server:getBusinessData', function(source, cb, businessId)
        if not CoreReady then return cb(nil) end
        cb(Businesses[businessId] or nil)
    end)
    
    print('^2[SL-Business] ^7Callbacks registered successfully')
end

-- Wait for core to be ready
CreateThread(function()
    while SLCore == nil do
        if GetResourceState('sl-core') == 'started' then
            SLCore = exports['sl-core']:GetCoreObject()
            if SLCore then
                CoreReady = true
                print('^2[SL-Business] ^7Successfully connected to SL-Core')
                InitializeDatabase()
                RegisterCallbacks()
                LoadBusinesses()
                break
            end
        end
        Wait(100)
    end
end)

local Businesses = {}
local CachedPlayers = {}

-- Load all businesses into memory
function LoadBusinesses()
    if not CoreReady then return end
    
    local results = MySQL.Sync.fetchAll('SELECT * FROM businesses')
    if not results then return end
    
    for _, business in ipairs(results) do
        Businesses[business.id] = business
    end
end

-- Core Functions
function CreateBusiness(owner, data)
    if not CoreReady then return false end
    
    if not owner or not data.name or not data.type then return false end
    
    local businessId = SLCore.Shared.RandomStr(10)
    local business = {
        id = businessId,
        name = data.name,
        owner = owner,
        type = data.type,
        funds = data.funds or 0,
        inventory = data.inventory or {},
        employees = data.employees or {},
        settings = data.settings or {}
    }
    
    local success = pcall(function()
        MySQL.insert.await('INSERT INTO businesses (id, name, owner, type, funds, inventory, employees, settings) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            {businessId, business.name, business.owner, business.type, business.funds, 
             json.encode(business.inventory), json.encode(business.employees), json.encode(business.settings)})
    end)
    
    if success then
        Businesses[businessId] = business
        return businessId
    end
    return false
end

function GetBusiness(businessId)
    if not CoreReady then return nil end
    
    return Businesses[businessId]
end

function UpdateBusiness(businessId, data)
    if not CoreReady then return false end
    
    if not Businesses[businessId] then return false end
    
    local success = pcall(function()
        MySQL.update.await('UPDATE businesses SET ? WHERE id = ?', {data, businessId})
    end)
    
    if success then
        for k, v in pairs(data) do
            Businesses[businessId][k] = v
        end
        return true
    end
    return false
end

function DeleteBusiness(businessId)
    if not CoreReady then return false end
    
    if not Businesses[businessId] then return false end
    
    local success = pcall(function()
        MySQL.query.await('DELETE FROM businesses WHERE id = ?', {businessId})
    end)
    
    if success then
        Businesses[businessId] = nil
        return true
    end
    return false
end

function ProcessTransaction(businessId, data)
    if not CoreReady then return false end
    
    local business = Businesses[businessId]
    if not business then return false end
    
    -- Validate transaction
    if not data.amount or data.amount <= 0 then return false end
    if data.type == 'withdraw' and business.funds < data.amount then return false end
    
    -- Process transaction
    local newFunds = data.type == 'deposit' 
        and business.funds + data.amount 
        or business.funds - data.amount
    
    local success = UpdateBusiness(businessId, {funds = newFunds})
    if success then
        -- Log transaction
        MySQL.insert.await('INSERT INTO business_transactions (business_id, type, amount, description) VALUES (?, ?, ?, ?)',
            {businessId, data.type, data.amount, data.description or ''})
    end
    
    return success
end

-- Events
RegisterNetEvent('sl-business:server:createBusiness', function(data)
    if not CoreReady then return end
    
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Check if player can afford to create a business
    local price = Config.BusinessTypes[data.type] and Config.BusinessTypes[data.type].price or 0
    if Player.PlayerData.money.bank < price then
        TriggerClientEvent('SLCore:Notify', src, 'Not enough money', 'error')
        return
    end
    
    -- Create business
    local businessId = CreateBusiness(Player.PlayerData.citizenid, data)
    if businessId then
        -- Remove money
        Player.Functions.RemoveMoney('bank', price, 'business-creation')
        TriggerClientEvent('SLCore:Notify', src, 'Business created successfully', 'success')
        TriggerClientEvent('sl-business:client:businessCreated', src, businessId)
    else
        TriggerClientEvent('SLCore:Notify', src, 'Failed to create business', 'error')
    end
end)

RegisterNetEvent('sl-business:server:updateBusiness', function(businessId, data)
    if not CoreReady then return end
    
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local business = Businesses[businessId]
    if not business or business.owner ~= Player.PlayerData.citizenid then
        TriggerClientEvent('SLCore:Notify', src, 'No permission', 'error')
        return
    end
    
    if UpdateBusiness(businessId, data) then
        TriggerClientEvent('SLCore:Notify', src, 'Business updated', 'success')
        TriggerClientEvent('sl-business:client:businessUpdated', src, businessId, data)
    else
        TriggerClientEvent('SLCore:Notify', src, 'Failed to update business', 'error')
    end
end)

RegisterNetEvent('sl-business:server:processTransaction', function(businessId, data)
    if not CoreReady or not SLCore then return end
    
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local success = ProcessTransaction(businessId, data)
    if success then
        TriggerClientEvent('sl-core:client:notify', src, 'Transaction processed', 'success')
        TriggerClientEvent('sl-business:client:transactionProcessed', src, businessId, data)
    else
        TriggerClientEvent('sl-core:client:notify', src, 'Failed to process transaction', 'error')
    end
end)

-- Exports
exports('GetBusiness', GetBusiness)
exports('UpdateBusiness', UpdateBusiness)
exports('ProcessTransaction', ProcessTransaction)
