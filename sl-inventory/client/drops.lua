local SLCore = exports['sl-core']:GetCoreObject()
local DropsNear = {}

CreateThread(function()
    while true do
        Wait(500)
        if LocalPlayer.state.isLoggedIn then
            local pos = GetEntityCoords(PlayerPedId())
            TriggerServerEvent("sl-inventory:server:updateDrops", pos.x, pos.y, pos.z)
        end
    end
end)

RegisterNetEvent('sl-inventory:client:AddDropItem')
AddEventHandler('sl-inventory:client:AddDropItem', function(dropId, player, coords)
    local coords = vector3(coords.x, coords.y, coords.z)
    DropsNear[dropId] = {
        id = dropId,
        coords = coords,
    }
end)

RegisterNetEvent('sl-inventory:client:RemoveDropItem')
AddEventHandler('sl-inventory:client:RemoveDropItem', function(dropId)
    DropsNear[dropId] = nil
end)

RegisterNetEvent('sl-inventory:client:DropItemAnim')
AddEventHandler('sl-inventory:client:DropItemAnim', function()
    local ped = PlayerPedId()
    LoadAnimDict("pickup_object")
    TaskPlayAnim(ped, "pickup_object", "pickup_low", 8.0, -8.0, -1, 1, 0, false, false, false)
    Wait(2000)
    ClearPedTasks(ped)
end)

-- Thread to draw markers at drop locations
CreateThread(function()
    while true do
        local sleep = 1000
        if LocalPlayer.state.isLoggedIn and DropsNear ~= nil then
            local pos = GetEntityCoords(PlayerPedId())
            for k, v in pairs(DropsNear) do
                if #(pos - v.coords) < 7.5 then
                    sleep = 0
                    DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 120, 10, 20, 155, false, false, false, 1, false, false, false)
                end
            end
        end
        Wait(sleep)
    end
end)
