local SLCore = exports['sl-core']:GetCoreObject()
local Events = {}
local EventHandlers = {}

-- Initialize client-side events
CreateThread(function()
    while not SLCore do
        Wait(100)
        SLCore = exports['sl-core']:GetCoreObject()
    end
end)

-- Event Functions
function Events.Register(eventName, handler)
    if not eventName or type(handler) ~= 'function' then return false end
    
    if not EventHandlers[eventName] then
        EventHandlers[eventName] = {}
    end
    
    table.insert(EventHandlers[eventName], handler)
    return true
end

function Events.Trigger(eventName, ...)
    if not eventName or not EventHandlers[eventName] then return false end
    
    for _, handler in ipairs(EventHandlers[eventName]) do
        handler(...)
    end
    
    return true
end

function Events.Remove(eventName, handler)
    if not eventName or not EventHandlers[eventName] then return false end
    
    if handler then
        for i, registeredHandler in ipairs(EventHandlers[eventName]) do
            if registeredHandler == handler then
                table.remove(EventHandlers[eventName], i)
                break
            end
        end
    else
        EventHandlers[eventName] = nil
    end
    
    return true
end

-- Export event functions
exports('RegisterEvent', Events.Register)
exports('TriggerEvent', Events.Trigger)
exports('RemoveEvent', Events.Remove)

-- Register some default events
RegisterNetEvent('sl-events:onPlayerSpawn')
AddEventHandler('sl-events:onPlayerSpawn', function()
    Events.Trigger('playerSpawn')
end)

RegisterNetEvent('sl-events:onPlayerDeath')
AddEventHandler('sl-events:onPlayerDeath', function()
    Events.Trigger('playerDeath')
end)

RegisterNetEvent('sl-events:onResourceStart')
AddEventHandler('sl-events:onResourceStart', function(resource)
    Events.Trigger('resourceStart', resource)
end)

RegisterNetEvent('sl-events:onResourceStop')
AddEventHandler('sl-events:onResourceStop', function(resource)
    Events.Trigger('resourceStop', resource)
end)
