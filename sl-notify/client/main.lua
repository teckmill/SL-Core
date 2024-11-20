local SL = exports['sl-core']:GetCoreObject()
local isNuiReady = false

-- Initialize NUI
CreateThread(function()
    while not isNuiReady do
        SendNUIMessage({
            action = 'config',
            data = Config
        })
        isNuiReady = true
        Wait(500)
    end
end)

-- Notification Functions
local function Notify(data)
    if type(data) == 'string' then
        data = {
            Message = data,
            Type = Config.Types.INFO
        }
    end
    
    -- Merge with default settings
    for k, v in pairs(Config.DefaultSettings) do
        if data[k] == nil then
            data[k] = v
        end
    end
    
    SendNUIMessage({
        action = 'notify',
        data = data
    })
end

-- Export notification types
local function Success(message, title)
    Notify({
        Message = message,
        Title = title,
        Type = Config.Types.SUCCESS
    })
end

local function Error(message, title)
    Notify({
        Message = message,
        Title = title,
        Type = Config.Types.ERROR
    })
end

local function Info(message, title)
    Notify({
        Message = message,
        Title = title,
        Type = Config.Types.INFO
    })
end

local function Warning(message, title)
    Notify({
        Message = message,
        Title = title,
        Type = Config.Types.WARNING
    })
end

local function System(message, title)
    Notify({
        Message = message,
        Title = title,
        Type = Config.Types.SYSTEM
    })
end

-- Event Handlers
RegisterNetEvent('sl-notify:client:Notify', function(data)
    Notify(data)
end)

RegisterNetEvent('sl-notify:client:Success', function(message, title)
    Success(message, title)
end)

RegisterNetEvent('sl-notify:client:Error', function(message, title)
    Error(message, title)
end)

RegisterNetEvent('sl-notify:client:Info', function(message, title)
    Info(message, title)
end)

RegisterNetEvent('sl-notify:client:Warning', function(message, title)
    Warning(message, title)
end)

RegisterNetEvent('sl-notify:client:System', function(message, title)
    System(message, title)
end)

-- Exports
exports('Notify', Notify)
exports('Success', Success)
exports('Error', Error)
exports('Info', Info)
exports('Warning', Warning)
exports('System', System)
