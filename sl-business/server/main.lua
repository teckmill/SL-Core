local SLCore = exports['sl-core']:GetCoreObject()
local Businesses = {}
local CachedPlayers = {}

-- Initialize
CreateThread(function()
    local success = pcall(function()
        MySQL.query([[
            CREATE TABLE IF NOT EXISTS businesses (
                id VARCHAR(50) PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                owner VARCHAR(50) NOT NULL,
                type VARCHAR(50) NOT NULL,
                funds DECIMAL(10,2) DEFAULT 0.00,
                inventory JSON,
                employees JSON,
                settings JSON,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        ]])
    end)
    
    if success then
        LoadBusinesses()
    else
        print("^1[ERROR] Failed to initialize business database^0")
    end
end)

-- Core Functions
function LoadBusinesses()
    local results = MySQL.query.await('SELECT * FROM businesses')
    for _, business in ipairs(results) do
        business.inventory = json.decode(business.inventory or '{}')
        business.employees = json.decode(business.employees or '{}')
        business.settings = json.decode(business.settings or '{}')
        Businesses[business.id] = business
    end
end

function CreateBusiness(owner, data)
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
    return Businesses[businessId]
end

function UpdateBusiness(businessId, data)
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
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local business = Businesses[businessId]
    if not business or business.owner ~= Player.PlayerData.citizenid then
        TriggerClientEvent('SLCore:Notify', src, 'No permission', 'error')
        return
    end
    
    if ProcessTransaction(businessId, data) then
        TriggerClientEvent('SLCore:Notify', src, 'Transaction processed', 'success')
        TriggerClientEvent('sl-business:client:transactionProcessed', src, businessId, data)
    else
        TriggerClientEvent('SLCore:Notify', src, 'Failed to process transaction', 'error')
    end
end)

-- Callbacks
SLCore.Functions.CreateCallback('sl-business:server:getBusinesses', function(source, cb)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end
    
    local playerBusinesses = {}
    for id, business in pairs(Businesses) do
        if business.owner == Player.PlayerData.citizenid then
            playerBusinesses[id] = business
        end
    end
    
    cb(playerBusinesses)
end)

SLCore.Functions.CreateCallback('sl-business:server:getBusiness', function(source, cb, businessId)
    cb(Businesses[businessId])
end)

-- Exports
exports('GetBusiness', GetBusiness)
exports('UpdateBusiness', UpdateBusiness)
exports('ProcessTransaction', ProcessTransaction)
