local SLCore = exports['sl-core']:GetCoreObject()
local PlayerData = {}
local isInventoryOpen = false
local currentInventory = nil
local isDragging = false
local dragData = {}
local nearbyDrops = {}
local isCrafting = false

-- Initialize
CreateThread(function()
    while not SLCore.Functions.IsPlayerLoaded() do
        Wait(100)
    end
    PlayerData = SLCore.Functions.GetPlayerData()
end)

-- Event Handlers
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    PlayerData = SLCore.Functions.GetPlayerData()
end)

RegisterNetEvent('SLCore:Client:OnPlayerUnload', function()
    PlayerData = {}
    isInventoryOpen = false
    currentInventory = nil
    nearbyDrops = {}
end)

RegisterNetEvent('sl-inventory:client:OpenInventory', function(inventoryType, data)
    if isInventoryOpen then return end
    if IsPlayerInRestrictedArea() then
        SLCore.Functions.Notify(Lang:t('error.restricted_area'), 'error')
        return
    end
    
    OpenInventory(inventoryType, data)
end)

RegisterNetEvent('sl-inventory:client:RefreshInventory', function(inventory)
    if not isInventoryOpen then return end
    
    SendNUIMessage({
        action = 'refreshInventory',
        inventory = inventory
    })
end)

RegisterNetEvent('sl-inventory:client:ItemUsed', function(itemName)
    local item = Config.UseAnimations[itemName]
    if item then
        PlayAnimAndWait(item.dict, item.anim, item.time)
    end
end)

RegisterNetEvent('sl-inventory:client:ShowDrops', function(drops)
    nearbyDrops = drops
end)

-- NUI Callbacks
RegisterNUICallback('UseItem', function(data, cb)
    TriggerServerEvent('sl-inventory:server:UseItem', data.item)
    cb('ok')
end)

RegisterNUICallback('MoveItem', function(data, cb)
    TriggerServerEvent('sl-inventory:server:MoveItem', data.from, data.to, data.count)
    cb('ok')
end)

RegisterNUICallback('CloseInventory', function(_, cb)
    CloseInventory()
    cb('ok')
end)

RegisterNUICallback('DropItem', function(data, cb)
    TriggerServerEvent('sl-inventory:server:DropItem', data.item, data.count)
    cb('ok')
end)

RegisterNUICallback('CraftItem', function(data, cb)
    if isCrafting then
        SLCore.Functions.Notify(Lang:t('error.already_crafting'), 'error')
        cb('error')
        return
    end
    
    TriggerServerEvent('sl-inventory:server:CraftItem', data.recipe)
    cb('ok')
end)

-- Functions
function OpenInventory(inventoryType, data)
    if not inventoryType then return end
    
    isInventoryOpen = true
    currentInventory = {
        type = inventoryType,
        data = data
    }
    
    -- Request inventory data from server
    TriggerServerEvent('sl-inventory:server:OpenInventory', inventoryType, data)
    
    -- Show UI
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openInventory',
        inventoryType = inventoryType,
        data = data
    })
    
    -- Apply blur if enabled
    if Config.UI.blur then
        TriggerScreenblurFadeIn(0)
    end
end

function CloseInventory()
    if not isInventoryOpen then return end
    
    isInventoryOpen = false
    currentInventory = nil
    
    -- Hide UI
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'closeInventory'
    })
    
    -- Remove blur
    if Config.UI.blur then
        TriggerScreenblurFadeOut(0)
    end
    
    -- Notify server
    TriggerServerEvent('sl-inventory:server:CloseInventory')
end

function PlayAnimAndWait(dict, anim, time)
    CreateThread(function()
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(10)
        end
        
        TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, -8.0, time, 0, 0, false, false, false)
        Wait(time)
        StopAnimTask(PlayerPedId(), dict, anim, 1.0)
    end)
end

function IsPlayerInRestrictedArea()
    local playerCoords = GetEntityCoords(PlayerPedId())
    for _, coords in ipairs(Config.RestrictedAreas) do
        if #(playerCoords - coords) < 50.0 then
            return true
        end
    end
    return false
end

-- Hotbar
CreateThread(function()
    while true do
        if Config.Hotbar.enabled then
            for slot, key in pairs(Config.Hotbar.keys) do
                if IsControlJustPressed(0, key) then
                    TriggerServerEvent('sl-inventory:server:UseHotbarItem', slot)
                end
            end
        end
        Wait(0)
    end
end)

-- Drops
CreateThread(function()
    while true do
        if next(nearbyDrops) then
            local playerCoords = GetEntityCoords(PlayerPedId())
            for dropId, drop in pairs(nearbyDrops) do
                local distance = #(playerCoords - vector3(drop.coords.x, drop.coords.y, drop.coords.z))
                if distance <= Config.Drops.showDistance then
                    DrawMarker(
                        Config.Drops.marker.type,
                        drop.coords.x, drop.coords.y, drop.coords.z - 1.0,
                        0.0, 0.0, 0.0,
                        0.0, 0.0, 0.0,
                        Config.Drops.marker.scale.x, Config.Drops.marker.scale.y, Config.Drops.marker.scale.z,
                        Config.Drops.marker.color.x, Config.Drops.marker.color.y, Config.Drops.marker.color.z, 100,
                        Config.Drops.marker.bob,
                        false, 2, Config.Drops.marker.rotate,
                        nil, nil, false
                    )
                end
            end
        end
        Wait(0)
    end
end)

-- Key Mappings
RegisterKeyMapping('inventory', 'Open Inventory', 'keyboard', 'TAB')
RegisterCommand('inventory', function()
    if not isInventoryOpen then
        TriggerEvent('sl-inventory:client:OpenInventory', 'player')
    else
        CloseInventory()
    end
end, false)

-- Export functions
exports('IsInventoryOpen', function()
    return isInventoryOpen
end)

exports('GetCurrentInventory', function()
    return currentInventory
end)

exports('CloseInventory', CloseInventory)
