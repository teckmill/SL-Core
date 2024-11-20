local SLCore = {}
local PlayerData = {}
local isLoggedIn = false

-- Core Functions
function SLCore.Functions.GetPlayerData(cb)
    if cb then
        cb(PlayerData)
    else
        return PlayerData
    end
end

function SLCore.Functions.IsPlayerLoaded()
    return isLoggedIn
end

-- Events
RegisterNetEvent('sl-core:client:playerLoaded', function(data)
    PlayerData = data
    isLoggedIn = true
    
    -- Set routing bucket
    SetRoutingBucketEntityLockdownMode(PlayerData.id, 'strict')
    
    -- Spawn player
    exports['spawnmanager']:spawnPlayer({
        x = PlayerData.position.x,
        y = PlayerData.position.y,
        z = PlayerData.position.z,
        heading = PlayerData.position.w,
        model = PlayerData.model or 'mp_m_freemode_01'
    }, function()
        TriggerEvent('sl-core:client:playerSpawned')
    end)
end)

RegisterNetEvent('sl-core:client:onPlayerUnload', function()
    isLoggedIn = false
    PlayerData = {}
end)

RegisterNetEvent('sl-core:client:OnMoneyChange', function(type, amount, action)
    PlayerData.money[type] = amount
    TriggerEvent('sl-hud:client:OnMoneyChange', type, amount, action)
end)

-- Exports
exports('GetCoreObject', function()
    return SLCore
end)

