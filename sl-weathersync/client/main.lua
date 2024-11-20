local SLCore = exports['sl-core']:GetCoreObject()
local currentWeather = 'CLEAR'
local currentTime = 0
local weatherTimer = 0
local blackout = false
local timeScale = Config.TimeScale

-- Core Ready Check
local CoreReady = false
AddEventHandler('SLCore:Client:OnPlayerLoaded', function()
    CoreReady = true
    TriggerServerEvent('sl-weathersync:server:RequestSync')
end)

-- Time Management
RegisterNetEvent('sl-weathersync:client:SyncTime', function(hour, minute)
    NetworkOverrideClockTime(hour, minute, 0)
    currentTime = {hour = hour, minute = minute}
end)

CreateThread(function()
    while true do
        if CoreReady then
            if not Config.FreezeTime then
                NetworkOverrideClockTime(currentTime.hour, currentTime.minute, 0)
            end
        end
        Wait(Config.SyncDelay)
    end
end)

-- Weather Management
RegisterNetEvent('sl-weathersync:client:SyncWeather', function(newWeather, newBlackout)
    currentWeather = newWeather
    blackout = newBlackout
    SetWeatherTypeOverTime(currentWeather, 15.0)
    Wait(15000)
    SetWeatherTypeNow(currentWeather)
    SetBlackout(blackout)
end)

RegisterNetEvent('sl-weathersync:client:RequestSync', function()
    TriggerServerEvent('sl-weathersync:server:RequestSync')
end)

-- Weather Transition
function TransitionToWeather(newWeather)
    if currentWeather == newWeather then return end
    
    SetWeatherTypeOverTime(newWeather, 15.0)
    Wait(15000)
    SetWeatherTypeNow(newWeather)
    currentWeather = newWeather
end

-- Commands
RegisterCommand('weather', function(source, args)
    if not CoreReady then return end
    if not args[1] then return end
    
    local weather = string.upper(args[1])
    if not Config.WeatherTypes[weather] then
        SLCore.Functions.Notify('Invalid weather type', 'error')
        return
    end
    
    TriggerServerEvent('sl-weathersync:server:SetWeather', weather)
end)

RegisterCommand('time', function(source, args)
    if not CoreReady then return end
    if not args[1] or not args[2] then return end
    
    local hour = tonumber(args[1])
    local minute = tonumber(args[2])
    
    if not hour or not minute or hour < 0 or hour > 23 or minute < 0 or minute > 59 then
        SLCore.Functions.Notify('Invalid time format', 'error')
        return
    end
    
    TriggerServerEvent('sl-weathersync:server:SetTime', hour, minute)
end)

RegisterCommand(Config.BlackoutCommand, function()
    if not CoreReady then return end
    if not Config.AllowBlackout then return end
    
    TriggerServerEvent('sl-weathersync:server:ToggleBlackout')
end)

-- Exports
exports('GetCurrentWeather', function()
    return currentWeather
end)

exports('GetCurrentTime', function()
    return currentTime
end)

exports('IsBlackout', function()
    return blackout
end)
