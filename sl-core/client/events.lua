local SLCore = exports['sl-core']:GetCoreObject()

-- Player Events
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    ShutdownLoadingScreen()
    LocalPlayer.state:set('isLoggedIn', true, false)
    
    -- Initialize player state
    SetCanAttackFriendly(PlayerPedId(), true, false)
    NetworkSetFriendlyFireOption(true)
    
    -- Load saved data
    TriggerServerEvent('SLCore:Server:OnPlayerLoaded')
end)

RegisterNetEvent('SLCore:Client:OnPlayerUnload', function()
    LocalPlayer.state:set('isLoggedIn', false, false)
end)

-- Money Events
RegisterNetEvent('SLCore:Client:OnMoneyChange', function(type, amount, action)
    if not SLCore.PlayerData then return end
    SLCore.PlayerData.money[type] = amount
    
    if Config.Debug then
        print(string.format('[Money] %s %s: $%s', action, type, amount))
    end
    
    TriggerEvent('sl-hud:client:OnMoneyChange', type, amount, action)
end)

-- Job Events
RegisterNetEvent('SLCore:Client:OnJobUpdate', function(JobInfo)
    SLCore.PlayerData.job = JobInfo
    TriggerEvent('sl-hud:client:OnJobUpdate')
end)

-- Gang Events
RegisterNetEvent('SLCore:Client:OnGangUpdate', function(GangInfo)
    SLCore.PlayerData.gang = GangInfo
    TriggerEvent('sl-hud:client:OnGangUpdate')
end)

-- Permission Events
RegisterNetEvent('SLCore:Client:OnPermissionUpdate', function(Permission)
    SLCore.PlayerData.permission = Permission
end)

-- Callback Events
RegisterNetEvent('SLCore:Client:TriggerCallback', function(name, ...)
    if SLCore.ServerCallbacks[name] then
        SLCore.ServerCallbacks[name](...)
        SLCore.ServerCallbacks[name] = nil
    end
end)

-- Death Events
RegisterNetEvent('SLCore:Client:OnPlayerDeath', function()
    SLCore.PlayerData.metadata['dead'] = true
    TriggerEvent('sl-hud:client:OnPlayerDeath')
end)

RegisterNetEvent('SLCore:Client:OnPlayerRevive', function()
    SLCore.PlayerData.metadata['dead'] = false
    TriggerEvent('sl-hud:client:OnPlayerRevive')
end)
