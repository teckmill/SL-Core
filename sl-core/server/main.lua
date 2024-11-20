SLCore = {}
SLCore.Config = {}
SLCore.Shared = {}
SLCore.ServerCallbacks = {}
SLCore.Player = {}
SLCore.Functions = {}
SLCore.Commands = {}

local Players = {}
local Commands = {}

-- Initialize Core
CreateThread(function()
    -- Load configurations
    SLCore.Config = json.decode(LoadResourceFile(GetCurrentResourceName(), 'config.json') or '{}')
    SLCore.Shared = json.decode(LoadResourceFile(GetCurrentResourceName(), 'shared/config.json') or '{}')
    
    -- Initialize database
    if GetResourceState('oxmysql') == 'started' then
        MySQL.ready(function()
            print('^2[SL-Core] ^7Database connection established')
        end)
    else
        print('^1[SL-Core] ^7Error: oxmysql not found or not started')
    end
end)

-- Player Functions
function SLCore.Player.Login(source, identifier, newData)
    if source and source ~= "" then
        if Players[source] then
            return false
        end
        
        if not newData.identifier then
            newData.identifier = identifier
        end

        Players[source] = SLCore.Player.CreatePlayer(newData, source)
        return true
    else
        return false
    end
end

function SLCore.Player.GetPlayers()
    local sources = {}
    for k, _ in pairs(Players) do
        sources[#sources+1] = k
    end
    return sources
end

function SLCore.Player.GetOfflinePlayer(identifier)
    return MySQL.Sync.fetchAll('SELECT * FROM players WHERE identifier = ? LIMIT 1', {identifier})[1] or nil
end

function SLCore.Player.Save(source)
    local PlayerData = Players[source]
    if PlayerData then
        PlayerData.Functions.Save()
    end
end

-- Command Registration
function SLCore.Commands.Add(name, help, arguments, argsrequired, callback, permission)
    Commands[name:lower()] = {
        name = name:lower(),
        permission = permission,
        help = help,
        arguments = arguments,
        argsrequired = argsrequired,
        callback = callback
    }
end

-- Callback System
function SLCore.Functions.CreateCallback(name, cb)
    SLCore.ServerCallbacks[name] = cb
end

function SLCore.Functions.TriggerCallback(name, source, cb, ...)
    if SLCore.ServerCallbacks[name] then
        SLCore.ServerCallbacks[name](source, cb, ...)
    end
end

-- Export
function GetCoreObject()
    return SLCore
end

-- Events
RegisterNetEvent('sl-core:server:TriggerCallback', function(name, ...)
    local src = source
    SLCore.Functions.TriggerCallback(name, src, function(...)
        TriggerClientEvent('sl-core:client:TriggerCallback', src, name, ...)
    end, ...)
end)

AddEventHandler('playerDropped', function()
    local src = source
    if Players[src] then
        Players[src].Functions.Save()
        Players[src] = nil
    end
end)

exports('GetCoreObject', GetCoreObject)