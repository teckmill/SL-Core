local SLCore = exports['sl-core']:GetCoreObject()

-- Player Events
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    ShutdownLoadingScreenNui()
    LocalPlayer.state:set('isLoggedIn', true, false)
    if not SLCore.Functions.GetPlayerData().metadata["hunger"] then
        SLCore.Functions.Notify('Hunger and thirst values reset', 'error')
        TriggerServerEvent('SLCore:Server:SetMetaData', 'hunger', 100)
        TriggerServerEvent('SLCore:Server:SetMetaData', 'thirst', 100)
    end
end)

RegisterNetEvent('SLCore:Client:OnPlayerUnload', function()
    LocalPlayer.state:set('isLoggedIn', false, false)
end)

RegisterNetEvent('SLCore:Client:UpdateObject', function()
    SLCore = exports['sl-core']:GetCoreObject()
end)

-- Utility Events
RegisterNetEvent('SLCore:Client:Notify', function(text, type, time)
    SLCore.Functions.Notify(text, type, time)
end)

RegisterNetEvent('SLCore:Client:DrawText', function(text, position)
    exports['sl-core']:DrawText(text, position)
end)

RegisterNetEvent('SLCore:Client:TriggerCallback', function(name, ...)
    SLCore.Functions.TriggerCallback(name, ...)
end)

-- State Events
RegisterNetEvent('SLCore:Client:SetPlayerData', function(val)
    SLCore.PlayerData = val
end)

RegisterNetEvent('SLCore:Client:OnJobUpdate', function(JobInfo)
    SLCore.Functions.Notify("Job Updated: "..JobInfo.label)
    SLCore.PlayerData.job = JobInfo
end)

RegisterNetEvent('SLCore:Client:OnGangUpdate', function(GangInfo)
    SLCore.PlayerData.gang = GangInfo
end)

RegisterNetEvent('SLCore:Client:OnMoneyChange', function(type, amount, operation)
    SLCore.PlayerData.money[type] = amount
    SLCore.Functions.Notify('Money '..operation..': $'..amount..' ('..type..')', 'success')
end)

-- Permission Events
RegisterNetEvent('SLCore:Client:OnPermissionUpdate', function(permission)
    SLCore.PlayerData.permission = permission
end)

-- Item Events
RegisterNetEvent('SLCore:Client:OnItemAdd', function(itemName, amount, slot)
    SLCore.Functions.Notify(amount..'x '..SLCore.Shared.Items[itemName].label..' added', 'success')
end)

RegisterNetEvent('SLCore:Client:OnItemRemove', function(itemName, amount)
    SLCore.Functions.Notify(amount..'x '..SLCore.Shared.Items[itemName].label..' removed', 'error')
end)

RegisterNetEvent('SLCore:Client:OnItemUse', function(item)
    SLCore.Functions.Notify('Used '..item.label, 'success')
end)
