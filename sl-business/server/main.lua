local SLCore = exports['sl-core']:GetCoreObject()
local Businesses = {}
local CachedPlayers = {}

-- Initialize
CreateThread(function()
    Wait(1000) -- Wait for database to be ready
    LoadBusinesses()
end)

-- Load all businesses from database
function LoadBusinesses()
    local success, result = pcall(function()
        return MySQL.query.await('SELECT * FROM businesses')
    end)

    if success and result then
        for _, business in ipairs(result) do
            Businesses[business.id] = business
            LoadBusinessEmployees(business.id)
            LoadBusinessUpgrades(business.id)
            LoadBusinessInventory(business.id)
        end
        print('^2[sl-business] ^7Loaded ' .. #result .. ' businesses')
    else
        print('^1[sl-business] ^7Failed to load businesses')
    end
end

-- Business Creation
function CreateBusiness(source, data)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end

    -- Validate business creation
    local canCreate, reason = ValidateBusinessCreation(Player, data)
    if not canCreate then
        TriggerClientEvent('sl-core:client:notify', source, reason, 'error')
        return false
    end

    -- Insert business into database
    local success, result = pcall(function()
        return MySQL.insert.await('INSERT INTO businesses (name, type, owner, zone, coords) VALUES (?, ?, ?, ?, ?)', {
            data.name,
            data.type,
            Player.PlayerData.citizenid,
            data.zone,
            json.encode(data.coords)
        })
    end)

    if success and result then
        -- Deduct creation cost
        local businessType = Config.BusinessTypes[data.type]
        Player.Functions.RemoveMoney('bank', businessType.basePrice, 'business-creation')
        
        -- Load business data
        LoadBusinesses()
        
        -- Notify player
        TriggerClientEvent('sl-core:client:notify', source, 'Business created successfully!', 'success')
        return true
    else
        TriggerClientEvent('sl-core:client:notify', source, 'Failed to create business', 'error')
        return false
    end
end

-- Business Management
function GetBusinessData(businessId)
    if not Businesses[businessId] then return nil end
    
    local business = Businesses[businessId]
    business.employees = GetBusinessEmployees(businessId)
    business.upgrades = GetBusinessUpgrades(businessId)
    business.inventory = GetBusinessInventory(businessId)
    business.analytics = GetBusinessAnalytics(businessId)
    
    return business
end

function UpdateBusiness(businessId, data)
    if not Businesses[businessId] then return false end

    local success = pcall(function()
        MySQL.update.await('UPDATE businesses SET ? WHERE id = ?', {data, businessId})
    end)

    if success then
        Businesses[businessId] = {...Businesses[businessId], ...data}
        return true
    end
    return false
end

-- Employee Management
function HireEmployee(businessId, employeeId, role, wage)
    local business = Businesses[businessId]
    if not business then return false end

    -- Validate hire
    if #GetBusinessEmployees(businessId) >= Config.BusinessTypes[business.type].maxEmployees then
        return false, 'Maximum employees reached'
    end

    local success = pcall(function()
        MySQL.insert.await('INSERT INTO business_employees (business_id, citizen_id, role, wage) VALUES (?, ?, ?, ?)', {
            businessId, employeeId, role, wage
        })
    end)

    if success then
        LoadBusinessEmployees(businessId)
        return true
    end
    return false
end

function FireEmployee(businessId, employeeId)
    local success = pcall(function()
        MySQL.query.await('DELETE FROM business_employees WHERE business_id = ? AND citizen_id = ?', {
            businessId, employeeId
        })
    end)

    if success then
        LoadBusinessEmployees(businessId)
        return true
    end
    return false
end

-- Financial Management
function ProcessTransaction(businessId, data)
    local business = Businesses[businessId]
    if not business then return false end

    -- Validate transaction
    if data.type == 'withdrawal' and business.funds < data.amount then
        return false, 'Insufficient funds'
    end

    -- Process transaction
    local newBalance = business.funds
    if data.type == 'deposit' then
        newBalance = newBalance + data.amount
    elseif data.type == 'withdrawal' then
        newBalance = newBalance - data.amount
    end

    local success = pcall(function()
        MySQL.transaction.await({
            {
                query = 'UPDATE businesses SET funds = ? WHERE id = ?',
                values = {newBalance, businessId}
            },
            {
                query = 'INSERT INTO business_transactions (business_id, type, amount, description) VALUES (?, ?, ?, ?)',
                values = {businessId, data.type, data.amount, data.description}
            }
        })
    end)

    if success then
        Businesses[businessId].funds = newBalance
        return true
    end
    return false
end

-- Inventory Management
function UpdateInventory(businessId, item, amount, type)
    local business = Businesses[businessId]
    if not business then return false end

    local currentAmount = 0
    local inventory = GetBusinessInventory(businessId)
    for _, inv in ipairs(inventory) do
        if inv.item == item then
            currentAmount = inv.amount
            break
        end
    end

    local newAmount = type == 'add' and currentAmount + amount or currentAmount - amount
    if newAmount < 0 then return false, 'Insufficient stock' end

    local success = pcall(function()
        if currentAmount == 0 then
            MySQL.insert.await('INSERT INTO business_inventory (business_id, item, amount) VALUES (?, ?, ?)', {
                businessId, item, newAmount
            })
        else
            MySQL.update.await('UPDATE business_inventory SET amount = ? WHERE business_id = ? AND item = ?', {
                newAmount, businessId, item
            })
        end
    end)

    if success then
        LoadBusinessInventory(businessId)
        return true
    end
    return false
end

-- Business Events
function CreateBusinessEvent(businessId, data)
    local success = pcall(function()
        MySQL.insert.await('INSERT INTO business_events (business_id, type, start_time, end_time, details) VALUES (?, ?, ?, ?, ?)', {
            businessId, data.type, data.startTime, data.endTime, json.encode(data.details)
        })
    end)

    return success
end

-- Utility Functions
function ValidateBusinessCreation(Player, data)
    -- Check if player has required license
    local businessType = Config.BusinessTypes[data.type]
    if not businessType then
        return false, 'Invalid business type'
    end

    local hasLicense = Player.Functions.HasItem(businessType.requiredLicense)
    if not hasLicense then
        return false, 'Missing required license'
    end

    -- Check if player has enough money
    local balance = Player.Functions.GetMoney('bank')
    if balance < businessType.basePrice then
        return false, 'Insufficient funds'
    end

    -- Check business name availability
    local exists = MySQL.scalar.await('SELECT 1 FROM businesses WHERE name = ?', {data.name})
    if exists then
        return false, 'Business name already taken'
    end

    -- Check maximum businesses per player
    local ownedCount = MySQL.scalar.await('SELECT COUNT(*) FROM businesses WHERE owner = ?', {Player.PlayerData.citizenid})
    if ownedCount >= Config.MaxBusinessesPerPlayer then
        return false, 'Maximum businesses reached'
    end

    return true
end

-- Events
RegisterNetEvent('sl-business:server:createBusiness', function(data)
    CreateBusiness(source, data)
end)

RegisterNetEvent('sl-business:server:updateBusiness', function(businessId, data)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return end

    local business = Businesses[businessId]
    if not business or business.owner ~= Player.PlayerData.citizenid then
        TriggerClientEvent('sl-core:client:notify', source, 'You don\'t own this business', 'error')
        return
    end

    local success = UpdateBusiness(businessId, data)
    TriggerClientEvent('sl-core:client:notify', source, success and 'Business updated' or 'Update failed', success and 'success' or 'error')
end)

RegisterNetEvent('sl-business:server:hireEmployee', function(businessId, employeeId, role, wage)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return end

    local business = Businesses[businessId]
    if not business or business.owner ~= Player.PlayerData.citizenid then
        TriggerClientEvent('sl-core:client:notify', source, 'You don\'t own this business', 'error')
        return
    end

    local success = HireEmployee(businessId, employeeId, role, wage)
    TriggerClientEvent('sl-core:client:notify', source, success and 'Employee hired' or 'Hiring failed', success and 'success' or 'error')
end)

RegisterNetEvent('sl-business:server:fireEmployee', function(businessId, employeeId)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return end

    local business = Businesses[businessId]
    if not business or business.owner ~= Player.PlayerData.citizenid then
        TriggerClientEvent('sl-core:client:notify', source, 'You don\'t own this business', 'error')
        return
    end

    local success = FireEmployee(businessId, employeeId)
    TriggerClientEvent('sl-core:client:notify', source, success and 'Employee fired' or 'Firing failed', success and 'success' or 'error')
end)

RegisterNetEvent('sl-business:server:processTransaction', function(businessId, data)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return end

    local business = Businesses[businessId]
    if not business or business.owner ~= Player.PlayerData.citizenid then
        TriggerClientEvent('sl-core:client:notify', source, 'You don\'t own this business', 'error')
        return
    end

    local success = ProcessTransaction(businessId, data)
    TriggerClientEvent('sl-core:client:notify', source, success and 'Transaction processed' or 'Transaction failed', success and 'success' or 'error')
end)

-- Callbacks
SLCore.Functions.CreateCallback('sl-business:server:getBusinessData', function(source, cb, businessId)
    cb(GetBusinessData(businessId))
end)

SLCore.Functions.CreateCallback('sl-business:server:getOwnedBusinesses', function(source, cb)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end

    local businesses = {}
    for id, business in pairs(Businesses) do
        if business.owner == Player.PlayerData.citizenid then
            businesses[#businesses + 1] = GetBusinessData(id)
        end
    end
    cb(businesses)
end)

-- Exports
exports('GetBusinessData', GetBusinessData)
exports('ProcessTransaction', ProcessTransaction)
exports('UpdateInventory', UpdateInventory)
exports('CreateBusinessEvent', CreateBusinessEvent)
