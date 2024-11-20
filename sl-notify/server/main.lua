local SL = exports['sl-core']:GetCoreObject()

-- Notification Functions
local function Notify(source, data)
    if type(data) == 'string' then
        data = {
            Message = data,
            Type = Config.Types.INFO
        }
    end
    
    TriggerClientEvent('sl-notify:client:Notify', source, data)
end

local function Success(source, message, title)
    TriggerClientEvent('sl-notify:client:Success', source, message, title)
end

local function Error(source, message, title)
    TriggerClientEvent('sl-notify:client:Error', source, message, title)
end

local function Info(source, message, title)
    TriggerClientEvent('sl-notify:client:Info', source, message, title)
end

local function Warning(source, message, title)
    TriggerClientEvent('sl-notify:client:Warning', source, message, title)
end

local function System(source, message, title)
    TriggerClientEvent('sl-notify:client:System', source, message, title)
end

-- Event Handlers
RegisterNetEvent('sl-notify:server:Notify', function(target, data)
    if target then
        Notify(target, data)
    end
end)

RegisterNetEvent('sl-notify:server:Success', function(target, message, title)
    if target then
        Success(target, message, title)
    end
end)

RegisterNetEvent('sl-notify:server:Error', function(target, message, title)
    if target then
        Error(target, message, title)
    end
end)

RegisterNetEvent('sl-notify:server:Info', function(target, message, title)
    if target then
        Info(target, message, title)
    end
end)

RegisterNetEvent('sl-notify:server:Warning', function(target, message, title)
    if target then
        Warning(target, message, title)
    end
end)

RegisterNetEvent('sl-notify:server:System', function(target, message, title)
    if target then
        System(target, message, title)
    end
end)

-- Broadcast Functions
local function BroadcastNotify(data)
    TriggerClientEvent('sl-notify:client:Notify', -1, data)
end

local function BroadcastSuccess(message, title)
    TriggerClientEvent('sl-notify:client:Success', -1, message, title)
end

local function BroadcastError(message, title)
    TriggerClientEvent('sl-notify:client:Error', -1, message, title)
end

local function BroadcastInfo(message, title)
    TriggerClientEvent('sl-notify:client:Info', -1, message, title)
end

local function BroadcastWarning(message, title)
    TriggerClientEvent('sl-notify:client:Warning', -1, message, title)
end

local function BroadcastSystem(message, title)
    TriggerClientEvent('sl-notify:client:System', -1, message, title)
end

-- Exports
exports('Notify', Notify)
exports('Success', Success)
exports('Error', Error)
exports('Info', Info)
exports('Warning', Warning)
exports('System', System)
exports('BroadcastNotify', BroadcastNotify)
exports('BroadcastSuccess', BroadcastSuccess)
exports('BroadcastError', BroadcastError)
exports('BroadcastInfo', BroadcastInfo)
exports('BroadcastWarning', BroadcastWarning)
exports('BroadcastSystem', BroadcastSystem)
