local SLCore = exports['sl-core']:GetCoreObject()
local Inventories = {}
local Drops = {}
local DropsIndex = 1

-- Initialize
CreateThread(function()
    MySQL.ready(function()
        -- Create tables if they don't exist
        local sqlFile = LoadResourceFile(GetCurrentResourceName(), 'sql/inventory.sql')
        if sqlFile then
            MySQL.Sync.execute(sqlFile)
        end

        -- Load all player inventories from database
        local result = MySQL.query.await('SELECT identifier, inventory FROM player_inventory')
        if result then
            for _, data in ipairs(result) do
                if data.inventory then
                    Inventories[data.identifier] = json.decode(data.inventory)
                end
            end
        end
    end)
end)

-- Helper Functions
local function GetInventoryMaxWeight(type, identifier)
    if Config.InventoryTypes[type] then
        return Config.InventoryTypes[type].maxWeight
    end
    return Config.MaxWeight
end

local function GetInventoryMaxSlots(type, identifier)
    if Config.InventoryTypes[type] then
        return Config.InventoryTypes[type].maxSlots
    end
    return Config.MaxSlots
end

local function CanCarryItem(inventory, item, amount)
    local itemInfo = SLCore.Shared.Items[item]
    if not itemInfo then return false end
    
    local currentWeight = 0
    for _, v in pairs(inventory) do
        currentWeight = currentWeight + (SLCore.Shared.Items[v.name].weight * v.amount)
    end
    
    return (currentWeight + (itemInfo.weight * amount)) <= GetInventoryMaxWeight('player', identifier)
end

local function GetFirstEmptySlot(inventory)
    local slots = {}
    for _, item in pairs(inventory) do
        slots[item.slot] = true
    end
    
    for i = 1, Config.MaxSlots do
        if not slots[i] then
            return i
        end
    end
    return nil
end

-- Event Handlers
RegisterNetEvent('sl-inventory:server:OpenInventory', function(type, data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local inventory = {
        type = type,
        slots = GetInventoryMaxSlots(type, Player.PlayerData.identifier),
        maxWeight = GetInventoryMaxWeight(type, Player.PlayerData.identifier),
        items = {}
    }
    
    if type == 'player' then
        inventory.items = Player.PlayerData.items
    elseif type == 'trunk' then
        local vehicle = NetworkGetEntityFromNetworkId(data.netId)
        if not vehicle or not DoesEntityExist(vehicle) then return end
        
        local plate = GetVehicleNumberPlateText(vehicle)
        if not Inventories['trunk-'..plate] then
            Inventories['trunk-'..plate] = {}
        end
        inventory.items = Inventories['trunk-'..plate]
    elseif type == 'glovebox' then
        local vehicle = NetworkGetEntityFromNetworkId(data.netId)
        if not vehicle or not DoesEntityExist(vehicle) then return end
        
        local plate = GetVehicleNumberPlateText(vehicle)
        if not Inventories['glovebox-'..plate] then
            Inventories['glovebox-'..plate] = {}
        end
        inventory.items = Inventories['glovebox-'..plate]
    elseif type == 'shop' then
        if not Config.Shops[data.shopType] then return end
        inventory.items = Config.Shops[data.shopType].items
    elseif type == 'drop' then
        if not Drops[data.dropId] then return end
        inventory.items = Drops[data.dropId].items
    end
    
    TriggerClientEvent('sl-inventory:client:RefreshInventory', src, inventory)
end)

RegisterNetEvent('sl-inventory:server:UseItem', function(item)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local itemData = Player.Functions.GetItemByName(item)
    if not itemData then return end
    
    if Config.Durability.enabled and itemData.durability then
        local decayRate = Config.Durability.decayRate[itemData.type] or 0
        itemData.durability = math.max(0, itemData.durability - decayRate)
        if itemData.durability <= 0 then
            Player.Functions.RemoveItem(item, 1)
            TriggerClientEvent('sl-inventory:client:ItemBroke', src, item)
            return
        end
    end
    
    local itemInfo = SLCore.Shared.Items[item]
    if itemInfo and itemInfo.useable then
        if type(itemInfo.useable) == 'string' then
            TriggerEvent(itemInfo.useable, src, itemData)
        end
        TriggerClientEvent('sl-inventory:client:ItemUsed', src, item)
    end
end)

RegisterNetEvent('sl-inventory:server:MoveItem', function(data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local fromType = data.from.type
    local toType = data.to.type
    local fromInventory = nil
    local toInventory = nil
    
    -- Get source inventory
    if fromType == 'player' then
        fromInventory = Player.PlayerData.items
    elseif fromType == 'trunk' or fromType == 'glovebox' then
        fromInventory = Inventories[fromType..'-'..data.from.id]
    elseif fromType == 'drop' then
        fromInventory = Drops[data.from.id].items
    end
    
    -- Get target inventory
    if toType == 'player' then
        toInventory = Player.PlayerData.items
    elseif toType == 'trunk' or toType == 'glovebox' then
        toInventory = Inventories[toType..'-'..data.to.id]
    elseif toType == 'drop' then
        toInventory = Drops[data.to.id].items
    end
    
    if not fromInventory or not toInventory then return end
    
    -- Handle item movement
    local fromItem = fromInventory[data.fromSlot]
    local toItem = toInventory[data.toSlot]
    
    if not fromItem then return end
    
    if toItem then
        -- Swap items
        fromInventory[data.fromSlot] = toItem
        toInventory[data.toSlot] = fromItem
    else
        -- Move item
        toInventory[data.toSlot] = fromItem
        fromInventory[data.fromSlot] = nil
    end
    
    -- Update inventories
    if fromType == 'player' then
        Player.Functions.SetInventory(fromInventory)
    end
    if toType == 'player' then
        Player.Functions.SetInventory(toInventory)
    end
    
    -- Refresh client inventories
    TriggerClientEvent('sl-inventory:client:RefreshInventory', src, {
        type = fromType,
        items = fromInventory
    })
    if fromType ~= toType then
        TriggerClientEvent('sl-inventory:client:RefreshInventory', src, {
            type = toType,
            items = toInventory
        })
    end
end)

RegisterNetEvent('sl-inventory:server:DropItem', function(item, count)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local itemData = Player.Functions.GetItemByName(item)
    if not itemData or itemData.amount < count then return end
    
    -- Create drop
    local coords = GetEntityCoords(GetPlayerPed(src))
    local dropId = DropsIndex
    DropsIndex = DropsIndex + 1
    
    Drops[dropId] = {
        id = dropId,
        coords = coords,
        items = {
            [1] = {
                name = item,
                amount = count,
                info = itemData.info,
                label = SLCore.Shared.Items[item].label,
                description = SLCore.Shared.Items[item].description,
                weight = SLCore.Shared.Items[item].weight,
                type = SLCore.Shared.Items[item].type,
                unique = SLCore.Shared.Items[item].unique,
                useable = SLCore.Shared.Items[item].useable,
                image = SLCore.Shared.Items[item].image,
                slot = 1,
                durability = itemData.durability
            }
        },
        time = os.time()
    }
    
    -- Remove item from player
    Player.Functions.RemoveItem(item, count)
    
    -- Notify nearby players
    local players = SLCore.Functions.GetPlayers()
    for _, v in ipairs(players) do
        local targetPed = GetPlayerPed(v)
        local distance = #(coords - GetEntityCoords(targetPed))
        if distance <= Config.Drops.showDistance then
            TriggerClientEvent('sl-inventory:client:ShowDrops', v, Drops)
        end
    end
end)

-- Periodic Save
CreateThread(function()
    while true do
        Wait(Config.SaveInterval)
        
        -- Save player inventories
        local players = SLCore.Functions.GetPlayers()
        for _, v in ipairs(players) do
            local Player = SLCore.Functions.GetPlayer(v)
            if Player then
                MySQL.update('UPDATE player_inventory SET inventory = ? WHERE identifier = ?', {
                    json.encode(Player.PlayerData.items),
                    Player.PlayerData.identifier
                })
            end
        end
        
        -- Clean up old drops
        local currentTime = os.time()
        for k, v in pairs(Drops) do
            if (currentTime - v.time) > Config.Drops.defaultDespawnTime then
                Drops[k] = nil
                TriggerClientEvent('sl-inventory:client:ShowDrops', -1, Drops)
            end
        end
    end
end)

-- Exports
exports('GetInventory', function(type, id)
    if type == 'player' then
        local Player = SLCore.Functions.GetPlayer(id)
        if Player then
            return Player.PlayerData.items
        end
    elseif type == 'trunk' or type == 'glovebox' then
        return Inventories[type..'-'..id]
    elseif type == 'drop' then
        return Drops[id]
    end
    return nil
end)

exports('AddItem', function(source, item, count, slot, info)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local itemData = SLCore.Shared.Items[item]
    if not itemData then return false end
    
    -- Check if player can carry item
    if not CanCarryItem(Player.PlayerData.items, item, count) then
        TriggerClientEvent('sl-inventory:client:SendMessage', source, Lang:t('error.cant_carry'))
        return false
    end
    
    -- Find slot
    local targetSlot = slot or GetFirstEmptySlot(Player.PlayerData.items)
    if not targetSlot then
        TriggerClientEvent('sl-inventory:client:SendMessage', source, Lang:t('error.no_slots'))
        return false
    end
    
    -- Add item
    if Player.Functions.AddItem(item, count, targetSlot, info) then
        TriggerClientEvent('sl-inventory:client:RefreshInventory', source, {
            type = 'player',
            items = Player.PlayerData.items
        })
        return true
    end
    
    return false
end)

exports('RemoveItem', function(source, item, count)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    if Player.Functions.RemoveItem(item, count) then
        TriggerClientEvent('sl-inventory:client:RefreshInventory', source, {
            type = 'player',
            items = Player.PlayerData.items
        })
        return true
    end
    
    return false
end)
