local SLCore = exports['sl-core']:GetCoreObject()
local DroppedItems = {}

-- Generate unique drop ID
local function GenerateDropId()
    local dropId = math.random(1, 999999)
    while DroppedItems[dropId] do
        dropId = math.random(1, 999999)
    end
    return dropId
end

-- Create new drop
RegisterNetEvent('sl-inventory:server:CreateDrop')
AddEventHandler('sl-inventory:server:CreateDrop', function(items, coords)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end

    local dropId = GenerateDropId()
    DroppedItems[dropId] = {
        items = items,
        coords = coords,
        time = os.time()
    }

    TriggerClientEvent('sl-inventory:client:AddDropItem', -1, dropId, coords)
end)

-- Remove drop
RegisterNetEvent('sl-inventory:server:RemoveDrop')
AddEventHandler('sl-inventory:server:RemoveDrop', function(dropId)
    if DroppedItems[dropId] then
        DroppedItems[dropId] = nil
        TriggerClientEvent('sl-inventory:client:RemoveDropItem', -1, dropId)
    end
end)

-- Pickup drop
RegisterNetEvent('sl-inventory:server:PickupDrop')
AddEventHandler('sl-inventory:server:PickupDrop', function(dropId)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end

    if DroppedItems[dropId] then
        local canCarry = true
        local items = DroppedItems[dropId].items

        -- Check if player can carry all items
        for _, item in pairs(items) do
            if not exports['sl-inventory']:CanCarryItem(src, item.name, item.amount) then
                canCarry = false
                break
            end
        end

        if canCarry then
            -- Add items to player inventory
            for _, item in pairs(items) do
                exports['sl-inventory']:AddItem(src, item.name, item.amount, item.slot, item.info)
            end

            -- Remove drop
            DroppedItems[dropId] = nil
            TriggerClientEvent('sl-inventory:client:RemoveDropItem', -1, dropId)
        else
            TriggerClientEvent('SLCore:Notify', src, 'You cannot carry all these items', 'error')
        end
    end
end)

-- Cleanup old drops
CreateThread(function()
    while true do
        Wait(5 * 60 * 1000) -- Check every 5 minutes
        local currentTime = os.time()
        for dropId, drop in pairs(DroppedItems) do
            if (currentTime - drop.time) > (30 * 60) then -- Remove drops older than 30 minutes
                DroppedItems[dropId] = nil
                TriggerClientEvent('sl-inventory:client:RemoveDropItem', -1, dropId)
            end
        end
    end
end)
