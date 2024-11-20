local SLCore = exports['sl-core']:GetCoreObject()
local cam = nil
local charPed = nil
local loadingCharacter = false

-- Cam coords and locations
local camCoords = vector4(-3962.39, 2013.95, 501.10, 250.85)
local pedCoords = vector4(-3960.62, 2012.64, 500.91, 67.76)

-- Function to create character preview camera
local function createCharacterCam()
    DoScreenFadeOut(0)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camCoords.x, camCoords.y, camCoords.z, 0.0, 0.0, camCoords.w, 60.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    DoScreenFadeIn(1000)
end

-- Function to delete character preview camera
local function deleteCharacterCam()
    if cam ~= nil then
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 1, true, true)
        cam = nil
    end
end

-- Function to create character preview ped
local function createCharacterPed()
    if charPed ~= nil then
        DeleteEntity(charPed)
    end
    
    local model = `mp_m_freemode_01`
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    
    charPed = CreatePed(2, model, pedCoords.x, pedCoords.y, pedCoords.z - 0.98, pedCoords.w, false, true)
    SetPedComponentVariation(charPed, 0, 0, 0, 2)
    FreezeEntityPosition(charPed, true)
    SetEntityInvincible(charPed, true)
    PlaceObjectOnGroundProperly(charPed)
    SetBlockingOfNonTemporaryEvents(charPed, true)
    
    SetModelAsNoLongerNeeded(model)
end

-- Function to delete character preview ped
local function deleteCharacterPed()
    if charPed ~= nil then
        DeleteEntity(charPed)
        charPed = nil
    end
end

-- Function to open multicharacter menu
local function openCharMenu(characters)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openUI",
        characters = characters
    })
    createCharacterCam()
    createCharacterPed()
end

-- Function to close multicharacter menu
local function closeCharMenu()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "closeUI"
    })
    deleteCharacterCam()
    deleteCharacterPed()
end

-- Event handler for showing multicharacter menu
RegisterNetEvent('sl-multicharacter:client:showUI')
AddEventHandler('sl-multicharacter:client:showUI', function(characters)
    if loadingCharacter then return end
    
    -- Set default spawn location
    SetEntityCoords(PlayerPedId(), camCoords.x, camCoords.y, camCoords.z, false, false, false, false)
    SetEntityVisible(PlayerPedId(), false, false)
    FreezeEntityPosition(PlayerPedId(), true)
    
    -- Open menu with characters
    openCharMenu(characters)
end)

-- Event handler for character selection
RegisterNetEvent('sl-multicharacter:client:selectCharacter')
AddEventHandler('sl-multicharacter:client:selectCharacter', function(character)
    loadingCharacter = true
    closeCharMenu()
    DoScreenFadeOut(500)
    Wait(1000)
    
    -- Reset player state
    SetEntityVisible(PlayerPedId(), true, false)
    FreezeEntityPosition(PlayerPedId(), false)
    
    -- Trigger character load
    TriggerServerEvent('sl-multicharacter:server:loadCharacter', character)
    loadingCharacter = false
end)

-- NUI Callbacks
RegisterNUICallback('selectCharacter', function(data, cb)
    if loadingCharacter then return end
    TriggerEvent('sl-multicharacter:client:selectCharacter', data.character)
    cb('ok')
end)

RegisterNUICallback('createCharacter', function(data, cb)
    if loadingCharacter then return end
    closeCharMenu()
    TriggerServerEvent('sl-multicharacter:server:createCharacter', data)
    cb('ok')
end)

RegisterNUICallback('deleteCharacter', function(data, cb)
    if loadingCharacter then return end
    TriggerServerEvent('sl-multicharacter:server:deleteCharacter', data.citizenid)
    cb('ok')
end)

RegisterNUICallback('closeUI', function(_, cb)
    if loadingCharacter then return end
    closeCharMenu()
    cb('ok')
end)

-- Initialize on resource start
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    Wait(100)
    TriggerServerEvent('sl-multicharacter:server:setupCharacters')
end)

-- Initialize on player spawn
AddEventHandler('playerSpawned', function()
    if loadingCharacter then return end
    TriggerServerEvent('sl-multicharacter:server:setupCharacters')
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    deleteCharacterCam()
    deleteCharacterPed()
    SetNuiFocus(false, false)
end)
