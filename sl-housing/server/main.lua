local SLCore = exports['sl-core']:GetCoreObject()
local Properties = {}
local ActiveViewers = {}
local OwnedProperties = {}

-- Database initialization
CreateThread(function()
    local success, error = pcall(function()
        MySQL.query.await([[
            CREATE TABLE IF NOT EXISTS `sl_properties` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `property_id` varchar(50) NOT NULL,
                `owner` varchar(50) DEFAULT NULL,
                `price` int(11) NOT NULL DEFAULT 0,
                `rent_price` int(11) DEFAULT NULL,
                `furniture` longtext DEFAULT NULL,
                `storage` longtext DEFAULT NULL,
                `keys` longtext DEFAULT NULL,
                `settings` longtext DEFAULT NULL,
                `last_payment` timestamp NULL DEFAULT current_timestamp(),
                `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
                PRIMARY KEY (`id`),
                UNIQUE KEY `property_id` (`property_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])
    end)
    
    if not success then
        print('^1Error initializing sl_properties table: ' .. tostring(error) .. '^0')
        return
    end

    LoadProperties()
end)

-- Load all properties from config and database
function LoadProperties()
    local Config = Config or {}
    Properties = Config.Properties or {}
    
    local results = MySQL.query.await('SELECT * FROM sl_properties')
    if not results then return end
    
    for _, data in ipairs(results) do
        local propertyId = data.property_id
        if Properties[propertyId] then
            Properties[propertyId].owner = data.owner
            Properties[propertyId].furniture = json.decode(data.furniture or '[]')
            Properties[propertyId].storage = json.decode(data.storage or '[]')
            Properties[propertyId].keys = json.decode(data.keys or '[]')
            Properties[propertyId].settings = json.decode(data.settings or '{}')
            Properties[propertyId].lastPayment = data.last_payment
            
            if data.owner then
                OwnedProperties[data.owner] = OwnedProperties[data.owner] or {}
                OwnedProperties[data.owner][propertyId] = true
            end
        end
    end
end

-- Property Purchase
SLCore.Functions.CreateCallback('sl-housing:server:PurchaseProperty', function(source, cb, propertyId)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return cb(false, 'Invalid player') end
    
    local property = Properties[propertyId]
    if not property then return cb(false, 'Invalid property') end
    if property.owner then return cb(false, 'Property already owned') end
    
    local price = property.price
    if Player.PlayerData.money.bank < price then
        return cb(false, 'Not enough money')
    end
    
    -- Check max properties limit
    local ownedCount = 0
    for _ in pairs(OwnedProperties[Player.PlayerData.citizenid] or {}) do
        ownedCount = ownedCount + 1
    end
    if ownedCount >= Config.MaxProperties then
        return cb(false, 'Maximum properties owned')
    end
    
    -- Process purchase
    if Player.Functions.RemoveMoney('bank', price, 'property-purchase') then
        property.owner = Player.PlayerData.citizenid
        OwnedProperties[Player.PlayerData.citizenid] = OwnedProperties[Player.PlayerData.citizenid] or {}
        OwnedProperties[Player.PlayerData.citizenid][propertyId] = true
        
        MySQL.insert('INSERT INTO sl_properties (property_id, owner, price) VALUES (?, ?, ?)', {
            propertyId, Player.PlayerData.citizenid, price
        })
        
        TriggerClientEvent('sl-housing:client:UpdateProperties', -1, Properties)
        cb(true, 'Property purchased successfully')
    else
        cb(false, 'Transaction failed')
    end
end)

-- Property Sale
SLCore.Functions.CreateCallback('sl-housing:server:SellProperty', function(source, cb, propertyId)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return cb(false, 'Invalid player') end
    
    local property = Properties[propertyId]
    if not property then return cb(false, 'Invalid property') end
    if property.owner ~= Player.PlayerData.citizenid then
        return cb(false, 'Not your property')
    end
    
    local sellPrice = math.floor(property.price * Config.SellPriceMultiplier)
    
    -- Process sale
    Player.Functions.AddMoney('bank', sellPrice, 'property-sale')
    property.owner = nil
    property.furniture = {}
    property.storage = {}
    property.keys = {}
    property.settings = {}
    
    OwnedProperties[Player.PlayerData.citizenid][propertyId] = nil
    if next(OwnedProperties[Player.PlayerData.citizenid]) == nil then
        OwnedProperties[Player.PlayerData.citizenid] = nil
    end
    
    MySQL.query('DELETE FROM sl_properties WHERE property_id = ?', {propertyId})
    
    TriggerClientEvent('sl-housing:client:UpdateProperties', -1, Properties)
    cb(true, 'Property sold successfully')
end)

-- Property Access
SLCore.Functions.CreateCallback('sl-housing:server:HasAccess', function(source, cb, propertyId)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return cb(false) end
    
    local property = Properties[propertyId]
    if not property then return cb(false) end
    
    local hasAccess = property.owner == Player.PlayerData.citizenid or
                      (property.keys and table.contains(property.keys, Player.PlayerData.citizenid))
    
    cb(hasAccess)
end)

-- Furniture Management
RegisterNetEvent('sl-housing:server:PlaceFurniture', function(propertyId, furnitureData)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local property = Properties[propertyId]
    if not property or property.owner ~= Player.PlayerData.citizenid then return end
    
    -- Validate furniture data and placement
    if not Config.Furniture[furnitureData.model] then return end
    if #(property.furniture or {}) >= Config.MaxFurniture then return end
    
    table.insert(property.furniture, furnitureData)
    MySQL.update('UPDATE sl_properties SET furniture = ? WHERE property_id = ?', {
        json.encode(property.furniture), propertyId
    })
    
    TriggerClientEvent('sl-housing:client:UpdateFurniture', -1, propertyId, property.furniture)
end)

-- Storage Management
SLCore.Functions.CreateCallback('sl-housing:server:GetStorage', function(source, cb, propertyId)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return cb({}) end
    
    local property = Properties[propertyId]
    if not property then return cb({}) end
    
    if property.owner ~= Player.PlayerData.citizenid and 
       (not property.keys or not table.contains(property.keys, Player.PlayerData.citizenid)) then
        return cb({})
    end
    
    cb(property.storage or {})
end)

-- Key Management
RegisterNetEvent('sl-housing:server:GiveKeys', function(propertyId, targetId)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    local Target = SLCore.Functions.GetPlayer(targetId)
    if not Player or not Target then return end
    
    local property = Properties[propertyId]
    if not property or property.owner ~= Player.PlayerData.citizenid then return end
    
    property.keys = property.keys or {}
    if #property.keys >= Config.MaxKeys then return end
    if table.contains(property.keys, Target.PlayerData.citizenid) then return end
    
    table.insert(property.keys, Target.PlayerData.citizenid)
    MySQL.update('UPDATE sl_properties SET keys = ? WHERE property_id = ?', {
        json.encode(property.keys), propertyId
    })
    
    TriggerClientEvent('sl-housing:client:UpdateKeys', targetId, propertyId, true)
end)

-- Utility Functions
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then return true end
    end
    return false
end

-- Property Maintenance
CreateThread(function()
    while true do
        Wait(Config.MaintenanceInterval)
        for propertyId, property in pairs(Properties) do
            if property.owner then
                -- Check rent/utility payments
                local lastPayment = property.lastPayment
                if lastPayment then
                    local timeSincePayment = os.time() - lastPayment
                    if timeSincePayment > Config.PaymentDueInterval then
                        local Player = SLCore.Functions.GetPlayerByCitizenId(property.owner)
                        if Player then
                            TriggerClientEvent('sl-housing:client:PaymentDue', Player.PlayerData.source, propertyId)
                        end
                    end
                end
                
                -- Update property condition
                if property.settings and property.settings.condition then
                    property.settings.condition = math.max(0, property.settings.condition - Config.DegradationRate)
                    if property.settings.condition < Config.MaintenanceThreshold then
                        local Player = SLCore.Functions.GetPlayerByCitizenId(property.owner)
                        if Player then
                            TriggerClientEvent('sl-housing:client:MaintenanceNeeded', Player.PlayerData.source, propertyId)
                        end
                    end
                end
            end
        end
    end
end)

-- Export property data for other resources
exports('GetPropertyData', function(propertyId)
    return Properties[propertyId]
end)

-- Save all property data periodically
CreateThread(function()
    while true do
        Wait(Config.SaveInterval)
        for propertyId, property in pairs(Properties) do
            if property.owner then
                MySQL.update([[
                    UPDATE sl_properties 
                    SET furniture = ?, storage = ?, keys = ?, settings = ? 
                    WHERE property_id = ?
                ]], {
                    json.encode(property.furniture or {}),
                    json.encode(property.storage or {}),
                    json.encode(property.keys or {}),
                    json.encode(property.settings or {}),
                    propertyId
                })
            end
        end
    end
end)
