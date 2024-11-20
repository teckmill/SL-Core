local SLCore = exports['sl-core']:GetCoreObject()
local cam = nil
local charPed = nil
local loadingScreen = true

-- Initialization
local function loadCharacters()
    SLCore.Functions.TriggerCallback('sl-multicharacter:server:GetCharacters', function(result)
        SendNUIMessage({
            action = "setupCharacters",
            characters = result
        })
    end)
end

-- Camera Controls
local function createCamera()
    local coords = Config.Interior
    DoScreenFadeOut(10)
    Wait(1000)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z + 1.0, 0.0, 0.0, 0.0, 60.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    DoScreenFadeIn(1000)
    FreezeEntityPosition(PlayerPedId(), true)
end

local function deleteCharacterPed()
    if charPed then
        DeleteEntity(charPed)
        charPed = nil
    end
end

local function loadCharacterPed(data)
    deleteCharacterPed()
    
    local model = data.gender == "Male" and `mp_m_freemode_01` or `mp_f_freemode_01`
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    
    charPed = CreatePed(2, model, Config.Interior.x, Config.Interior.y, Config.Interior.z - 0.98, 0.0, false, true)
    SetPedComponentVariation(charPed, 0, 0, 0, 2)
    FreezeEntityPosition(charPed, true)
    SetEntityInvincible(charPed, true)
    PlaceObjectOnGroundProperly(charPed)
    SetBlockingOfNonTemporaryEvents(charPed, true)
    
    -- Load character customization here
    -- This would typically involve setting clothes, hair, and other appearance options
end

-- NUI Callbacks
RegisterNUICallback('selectCharacter', function(data, cb)
    local cData = data.cData
    DoScreenFadeOut(10)
    TriggerServerEvent('sl-multicharacter:server:loadUserData', cData)
    cb("ok")
end)

RegisterNUICallback('createCharacter', function(data, cb)
    local cData = data
    DoScreenFadeOut(10)
    TriggerServerEvent('sl-multicharacter:server:createCharacter', cData)
    cb("ok")
end)

RegisterNUICallback('deleteCharacter', function(data, cb)
    TriggerServerEvent('sl-multicharacter:server:deleteCharacter', data.citizenid)
    cb("ok")
end)

RegisterNUICallback('closeUI', function(_, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

-- Events
RegisterNetEvent('sl-multicharacter:client:chooseChar', function()
    SetNuiFocus(true, true)
    DoScreenFadeOut(10)
    Wait(1000)
    
    loadingScreen = false
    createCamera()
    loadCharacters()
    
    SendNUIMessage({
        action = "openUI",
        maxCharacters = Config.DefaultNumberOfCharacters
    })
end)

RegisterNetEvent('sl-multicharacter:client:spawnPlayer', function(data)
    local spawn = Config.DefaultSpawn
    if Config.Spawns[data.spawn] then
        spawn = Config.Spawns[data.spawn].coords
    end
    
    deleteCharacterPed()
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    RenderScriptCams(false, false, 1, true, true)
    
    DoScreenFadeOut(500)
    Wait(2000)
    SetEntityCoords(PlayerPedId(), spawn.x, spawn.y, spawn.z)
    SetEntityHeading(PlayerPedId(), spawn.w)
    FreezeEntityPosition(PlayerPedId(), false)
    Wait(500)
    DoScreenFadeIn(250)
end)

-- Initial Setup
CreateThread(function()
    while true do
        Wait(0)
        if NetworkIsSessionStarted() then
            TriggerEvent('sl-multicharacter:client:chooseChar')
            break
        end
    end
end)
