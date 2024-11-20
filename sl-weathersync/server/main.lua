local SLCore = exports['sl-core']:GetCoreObject()

-- Core Ready Check
local CoreReady = false
AddEventHandler('SLCore:Server:OnCoreReady', function()
    CoreReady = true
    InitializeWeather()
end)

-- Variables
local currentWeather = Config.WeatherTypes[1]
local currentTime = {hour = Config.StartHour, minute = Config.StartMinute}
local blackout = false
local weatherTimer = 0

-- Initialize Weather System
function InitializeWeather()
    -- Set initial weather
    SetWeather(currentWeather)
    
    -- Start weather cycle if dynamic weather is enabled
    if Config.DynamicWeather then
        CreateThread(function()
            while true do
                Wait(Config.WeatherInterval * 60000)
                if not Config.FreezeTime then
                    AdvanceTime()
                end
                if Config.DynamicWeather then
                    UpdateWeather()
                end
            end
        end)
    end
end

-- Time Management
function AdvanceTime()
    currentTime.minute = currentTime.minute + 1
    if currentTime.minute >= 60 then
        currentTime.minute = 0
        currentTime.hour = currentTime.hour + 1
        if currentTime.hour >= 24 then
            currentTime.hour = 0
        end
    end
    TriggerClientEvent('sl-weathersync:client:SyncTime', -1, currentTime.hour, currentTime.minute)
end

-- Weather Management
function UpdateWeather()
    local validNextWeathers = Config.WeatherPatterns[currentWeather]
    if not validNextWeathers then return end
    
    local nextWeather = validNextWeathers[math.random(#validNextWeathers)]
    SetWeather(nextWeather)
end

function SetWeather(weather)
    currentWeather = weather
    TriggerClientEvent('sl-weathersync:client:SyncWeather', -1, weather, blackout)
end

-- Events
RegisterNetEvent('sl-weathersync:server:RequestSync', function()
    local src = source
    TriggerClientEvent('sl-weathersync:client:SyncWeather', src, currentWeather, blackout)
    TriggerClientEvent('sl-weathersync:client:SyncTime', src, currentTime.hour, currentTime.minute)
end)

RegisterNetEvent('sl-weathersync:server:SetWeather', function(weather)
    local src = source
    if not CoreReady then return end
    
    -- Check if player has permission
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player.PlayerData.job.name == 'admin' then return end
    
    if Config.WeatherTypes[weather] then
        SetWeather(weather)
    end
end)

RegisterNetEvent('sl-weathersync:server:SetTime', function(hour, minute)
    local src = source
    if not CoreReady then return end
    
    -- Check if player has permission
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player.PlayerData.job.name == 'admin' then return end
    
    if hour >= 0 and hour <= 23 and minute >= 0 and minute <= 59 then
        currentTime.hour = hour
        currentTime.minute = minute
        TriggerClientEvent('sl-weathersync:client:SyncTime', -1, hour, minute)
    end
end)

RegisterNetEvent('sl-weathersync:server:ToggleBlackout', function()
    local src = source
    if not CoreReady then return end
    if not Config.AllowBlackout then return end
    
    -- Check if player has permission
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player.PlayerData.job.name == 'admin' then return end
    
    blackout = not blackout
    TriggerClientEvent('sl-weathersync:client:SyncWeather', -1, currentWeather, blackout)
end)

-- Commands
SLCore.Commands.Add('weather', 'Set server weather (Admin Only)', {{name = 'type', help = 'Weather Type'}}, true, function(source, args)
    local weather = string.upper(args[1])
    if Config.WeatherTypes[weather] then
        SetWeather(weather)
    end
end, 'admin')

SLCore.Commands.Add('time', 'Set server time (Admin Only)', {
    {name = 'hour', help = '0-23'},
    {name = 'minute', help = '0-59'}
}, true, function(source, args)
    local hour = tonumber(args[1])
    local minute = tonumber(args[2])
    
    if hour and minute and hour >= 0 and hour <= 23 and minute >= 0 and minute <= 59 then
        currentTime.hour = hour
        currentTime.minute = minute
        TriggerClientEvent('sl-weathersync:client:SyncTime', -1, hour, minute)
    end
end, 'admin')

SLCore.Commands.Add(Config.BlackoutCommand, 'Toggle blackout (Admin Only)', {}, true, function(source)
    if not Config.AllowBlackout then return end
    
    blackout = not blackout
    TriggerClientEvent('sl-weathersync:client:SyncWeather', -1, currentWeather, blackout)
end, 'admin')
