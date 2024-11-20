local SLCore = exports['sl-core']:GetCoreObject()

-- Functions
local function GetPlayerSpawnData(source)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return nil end
    
    local spawnData = {
        locations = Config.Spawns,
        lastLocation = Config.SpawnInLastPosition and Player.PlayerData.position or Config.DefaultSpawn,
        apartments = {},
        hotels = {}
    }
    
    -- Add apartments if player owns any
    if Player.PlayerData.metadata and Player.PlayerData.metadata.apartments then
        for _, apartment in pairs(Player.PlayerData.metadata.apartments) do
            if Config.ApartmentSpawns[apartment] then
                spawnData.apartments[apartment] = Config.ApartmentSpawns[apartment]
            end
        end
    end
    
    -- Add hotels for new characters
    if not Player.PlayerData.metadata.firstSpawn then
        spawnData.hotels = Config.HotelSpawns
    end
    
    return spawnData
end

-- Events
RegisterNetEvent('sl-spawn:server:requestSpawnData', function()
    local src = source
    local spawnData = GetPlayerSpawnData(src)
    if spawnData then
        TriggerClientEvent('sl-spawn:client:openUI', src, spawnData)
    end
end)

RegisterNetEvent('sl-spawn:server:playerSpawned', function(data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Update player's last position
    Player.Functions.SetMetaData('lastLocation', data.coords)
    
    -- Mark as spawned for new characters
    if not Player.PlayerData.metadata.firstSpawn then
        Player.Functions.SetMetaData('firstSpawn', true)
    end
    
    -- Trigger spawn on client
    TriggerClientEvent('sl-spawn:client:spawn', src, data.coords)
end)

-- Commands
SLCore.Commands.Add('spawn', 'Open spawn menu (Admin Only)', {}, false, function(source)
    local Player = SLCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "admin" then
        TriggerClientEvent('sl-spawn:client:loadCharacter', source)
    end
end, 'admin')
