-- SL Framework Server Wrapper
-- This file provides wrapper functions for common operations

local function TableContains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

-- Database Wrappers
function SLCore.Functions.ExecuteSql(query, params, callback)
    local result = MySQL.query.await(query, params)
    if callback then
        callback(result)
    end
    return result
end

function SLCore.Functions.GetSingle(query, params, callback)
    local result = MySQL.single.await(query, params)
    if callback then
        callback(result)
    end
    return result
end

function SLCore.Functions.Insert(query, params, callback)
    local result = MySQL.insert.await(query, params)
    if callback then
        callback(result)
    end
    return result
end

-- Player Wrappers
function SLCore.Functions.HasPermission(source, permission)
    if source == 0 then return true end -- Console has all permissions
    
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local permissions = Player.PlayerData.metadata.permissions or {}
    return TableContains(permissions, permission) or TableContains(permissions, 'god')
end

function SLCore.Functions.IsPlayerBanned(source, callback)
    local license = SLCore.Functions.GetIdentifier(source, 'license')
    if not license then 
        if callback then callback(true) end
        return true 
    end
    
    local result = MySQL.single.await('SELECT * FROM bans WHERE license = ?', {license})
    local isBanned = result ~= nil
    
    if callback then
        callback(isBanned, result)
    end
    return isBanned, result
end

-- Item Wrappers
function SLCore.Functions.CreateUseableItem(item, data)
    SLCore.Functions.CreateCallback('sl-core:server:UseItem', function(source, cb, itemName)
        if itemName ~= item then return cb(false) end
        
        local src = source
        local Player = SLCore.Functions.GetPlayer(src)
        if not Player then return cb(false) end
        
        if type(data) == 'function' then
            data(src, item)
        end
        cb(true)
    end)
end

-- Utility Wrappers
function SLCore.Functions.CreateCallback(name, cb)
    SLCore.ServerCallbacks[name] = cb
end

function SLCore.Functions.TriggerCallback(name, source, cb, ...)
    if not SLCore.ServerCallbacks[name] then return end
    SLCore.ServerCallbacks[name](source, cb, ...)
end

function SLCore.Functions.CreateUseableItem(item, cb)
    SLCore.UseableItems[item] = cb
end

function SLCore.Functions.CanUseItem(item)
    return SLCore.UseableItems[item] ~= nil
end

function SLCore.Functions.UseItem(source, item)
    if not SLCore.UseableItems[item.name] then return end
    SLCore.UseableItems[item.name](source, item)
end

-- Logging Wrapper
function SLCore.Functions.Log(type, message, metadata)
    if not type or not message then return end
    
    local logData = {
        type = type,
        message = message,
        metadata = metadata or {},
        timestamp = os.time()
    }
    
    -- Print to console
    print(string.format('[SL-Core] [%s] %s', type, message))
    
    -- Save to database if logging is enabled
    if SLCore.Config.EnableDatabaseLogging then
        MySQL.insert('INSERT INTO framework_logs (type, message, metadata, created_at) VALUES (?, ?, ?, ?)', {
            logData.type,
            logData.message,
            json.encode(logData.metadata),
            os.date('%Y-%m-%d %H:%M:%S', logData.timestamp)
        })
    end
    
    -- Trigger event for external logging systems
    TriggerEvent('sl-core:server:Log', logData)
end
