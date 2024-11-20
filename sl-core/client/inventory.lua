-- Inventory Client Functions
function SLCore.Functions.HasItem(item)
    local p = promise.new()
    SLCore.Functions.TriggerCallback('sl-core:server:HasItem', function(result)
        p:resolve(result)
    end, item)
    return Citizen.Await(p)
end

function SLCore.Functions.UseItem(item)
    TriggerServerEvent('sl-core:server:UseItem', item)
end

-- Item Use Events
RegisterNetEvent('sl-core:client:ItemBox')
AddEventHandler('sl-core:client:ItemBox', function(itemData, type)
    SendNUIMessage({
        action = "itemBox",
        item = itemData.name,
        type = type
    })
end)

RegisterNetEvent('sl-core:client:UseItem')
AddEventHandler('sl-core:client:UseItem', function(item)
    if item.type == "weapon" then
        TriggerServerEvent("sl-weapons:server:EquipWeapon", item)
    elseif item.useable then
        TriggerServerEvent("sl-core:server:UseItem", item.name)
    end
end)

-- Inventory UI
RegisterNetEvent('sl-core:client:OpenInventory')
AddEventHandler('sl-core:client:OpenInventory', function()
    local PlayerData = SLCore.Functions.GetPlayerData()
    if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] then
        SendNUIMessage({
            action = "open",
            inventory = PlayerData.items,
            maxweight = SLConfig.Player.MaxWeight,
            slots = SLConfig.Player.MaxInvSlots,
        })
        SetNuiFocus(true, true)
    end
end)

RegisterNUICallback('UseItem', function(data, cb)
    TriggerServerEvent("sl-core:server:UseItem", data.inventory, data.item)
    cb('ok')
end)

RegisterNUICallback('CloseInventory', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Hotkeys
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 289) then -- F2 key
            TriggerEvent('sl-core:client:OpenInventory')
        end
    end
end)

-- Item Use Effects
RegisterNetEvent('sl-core:client:UseConsumable')
AddEventHandler('sl-core:client:UseConsumable', function(item)
    local itemData = SLShared.Items[item]
    if itemData.thirst then
        TriggerServerEvent('sl-hud:server:RelieveThirst', itemData.thirst)
    end
    if itemData.hunger then
        TriggerServerEvent('sl-hud:server:RelieveHunger', itemData.hunger)
    end
    TriggerEvent('sl-core:client:ItemBox', itemData, 'use')
end)

-- Weapon Management
RegisterNetEvent('sl-core:client:AddWeapon')
AddEventHandler('sl-core:client:AddWeapon', function(weaponName, ammo)
    local ped = PlayerPedId()
    GiveWeaponToPed(ped, GetHashKey(weaponName), ammo, false, false)
end)

RegisterNetEvent('sl-core:client:RemoveWeapon')
AddEventHandler('sl-core:client:RemoveWeapon', function(weaponName)
    local ped = PlayerPedId()
    RemoveWeaponFromPed(ped, GetHashKey(weaponName))
end)
