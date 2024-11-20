local SLCore = exports['sl-core']:GetCoreObject()
local spawned = false
local firstSpawn = true

-- Functions
local function LoadPlayerModel(skin)
    local model = skin and skin.model or `mp_m_freemode_01`
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    SetPlayerModel(PlayerId(), model)
    SetPedDefaultComponentVariation(PlayerPedId())
    SetModelAsNoLongerNeeded(model)
end

local function PreSpawnPlayer()
    spawned = false
    local ped = PlayerPedId()
    SetEntityVisible(ped, false)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityCoords(ped, Config.DefaultSpawn.x, Config.DefaultSpawn.y, Config.DefaultSpawn.z)
    SetEntityHeading(ped, Config.DefaultSpawn.w)
end

local function PostSpawnPlayer()
    local ped = PlayerPedId()
    SetEntityVisible(ped, true)
    SetEntityInvincible(ped, false)
    FreezeEntityPosition(ped, false)
    SetPedDefaultComponentVariation(ped)
    spawned = true
end

-- Main spawn logic
local function HandleSpawn()
    PreSpawnPlayer()
    
    -- Get player data from SL-Core
    local PlayerData = SLCore.Functions.GetPlayerData()
    if not PlayerData then return end
    
    -- Load player model
    if PlayerData.skin then
        LoadPlayerModel(PlayerData.skin)
    end
    
    -- Get spawn locations
    local spawnData = {
        locations = Config.Spawns,
        lastLocation = firstSpawn and Config.DefaultSpawn or PlayerData.position,
        apartments = {},
        hotels = {}
    }
    
    -- Add apartments if player owns any
    if PlayerData.metadata and PlayerData.metadata.apartments then
        for _, apartment in pairs(PlayerData.metadata.apartments) do
            if Config.ApartmentSpawns[apartment] then
                spawnData.apartments[apartment] = Config.ApartmentSpawns[apartment]
            end
        end
    end
    
    -- Add hotels for new characters
    if firstSpawn then
        spawnData.hotels = Config.HotelSpawns
    end
    
    -- Open spawn UI
    TriggerEvent('sl-spawn:client:openUI', spawnData)
    firstSpawn = false
end

-- Events
RegisterNetEvent('sl-spawn:client:spawn', function(data)
    if spawned then return end
    
    local coords = type(data) == 'table' and vector4(data.x, data.y, data.z, data.w) or Config.DefaultSpawn
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
    SetEntityHeading(PlayerPedId(), coords.w)
    
    PostSpawnPlayer()
    
    -- Trigger post-spawn events
    TriggerEvent('sl-spawn:client:spawned')
    TriggerServerEvent('sl-spawn:server:spawned')
end)

RegisterNetEvent('sl-spawn:client:loadCharacter', function()
    if not spawned then
        HandleSpawn()
    end
end)

-- Initialize
CreateThread(function()
    while not SLCore do
        Wait(100)
    end
    
    -- Wait for player to be loaded
    while not SLCore.Functions.GetPlayerData() do
        Wait(100)
    end
    
    -- Handle first spawn
    if not spawned then
        HandleSpawn()
    end
end)

-- Debug
if Config.Debug then
    RegisterCommand('respawn', function()
        HandleSpawn()
    end)
end
