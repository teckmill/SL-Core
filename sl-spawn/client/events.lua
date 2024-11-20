local SLCore = exports['sl-core']:GetCoreObject()

-- Event handlers
RegisterNetEvent('sl-spawn:client:openUI', function(data)
    SendNUIMessage({
        action = "openSpawnMenu",
        locations = data.locations,
        lastLocation = data.lastLocation,
        apartments = data.apartments,
        hotels = data.hotels,
        settings = Config.UISettings
    })
    SetNuiFocus(true, true)
    exports['sl-spawn']:StartCam()
end)

RegisterNetEvent('sl-spawn:client:closeUI', function()
    SetNuiFocus(false, false)
    exports['sl-spawn']:EndCam()
end)

RegisterNetEvent('sl-spawn:client:spawnPlayer', function(coords)
    if not coords then return end
    exports['sl-spawn']:TransitionToSpawn(coords)
end)

-- NUI Callbacks
RegisterNUICallback('previewLocation', function(data, cb)
    if exports['sl-spawn']:IsCamTransitioning() then
        cb('transitioning')
        return
    end
    
    local location = data.location
    if not location or not location.coords then
        cb('invalid_location')
        return
    end
    
    exports['sl-spawn']:SetCamFocus(location.coords, false)
    cb('success')
end)

RegisterNUICallback('spawnPlayer', function(data, cb)
    local spawnType = data.type
    local spawnId = data.id
    
    -- Validate spawn data
    if not spawnType or not spawnId then
        cb({status = 'error', message = Lang:t('error.invalid_spawn')})
        return
    end
    
    -- Get spawn coordinates based on type
    local coords = nil
    if spawnType == 'last' and data.lastLocation then
        coords = data.lastLocation
    elseif spawnType == 'spawn' and Config.Spawns[spawnId] then
        coords = Config.Spawns[spawnId].coords
    elseif spawnType == 'apartment' and Config.ApartmentSpawns[spawnId] then
        coords = Config.ApartmentSpawns[spawnId].coords
    elseif spawnType == 'hotel' and Config.HotelSpawns[spawnId] then
        coords = Config.HotelSpawns[spawnId].coords
    end
    
    if not coords then
        cb({status = 'error', message = Lang:t('error.spawn_not_found')})
        return
    end
    
    -- Trigger spawn
    TriggerServerEvent('sl-spawn:server:playerSpawned', {
        spawnType = spawnType,
        spawnId = spawnId,
        coords = coords
    })
    
    SetNuiFocus(false, false)
    cb({status = 'success'})
end)

RegisterNUICallback('closeUI', function(_, cb)
    TriggerEvent('sl-spawn:client:closeUI')
    cb('ok')
end)

-- Initialize spawn system when player loads
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('sl-spawn:server:requestSpawnData')
end)

-- Debug commands if enabled
if Config.Debug then
    RegisterCommand('spawndebug', function()
        TriggerEvent('sl-spawn:client:openUI', {
            locations = Config.Spawns,
            lastLocation = Config.DefaultSpawn,
            apartments = Config.ApartmentSpawns,
            hotels = Config.HotelSpawns
        })
    end)
end
