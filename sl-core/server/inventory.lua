-- Inventory Management Functions
function SLCore.Functions.AddItem(source, item, amount, slot, info)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local totalWeight = SLCore.Player.GetTotalWeight(Player.PlayerData.items)
    local itemInfo = SLShared.Items[item:lower()]
    if not itemInfo then return false end
    
    amount = tonumber(amount) or 1
    slot = tonumber(slot) or GetFirstAvailableSlot(Player.PlayerData.items)
    info = info or {}

    if itemInfo['unique'] then
        amount = 1
    end

    if (totalWeight + (itemInfo['weight'] * amount)) <= SLConfig.Player.MaxWeight then
        if (slot and Player.PlayerData.items[slot] and Player.PlayerData.items[slot].name:lower() == item:lower()) and not itemInfo['unique'] then
            Player.PlayerData.items[slot].amount = Player.PlayerData.items[slot].amount + amount
        else
            local itemData = {
                name = itemInfo['name'],
                amount = amount,
                info = info or '',
                label = itemInfo['label'],
                description = itemInfo['description'] or '',
                weight = itemInfo['weight'],
                type = itemInfo['type'],
                unique = itemInfo['unique'],
                useable = itemInfo['useable'],
                image = itemInfo['image'],
                shouldClose = itemInfo['shouldClose'],
                slot = slot,
            }
            Player.PlayerData.items[slot] = itemData
        end
        
        TriggerClientEvent('sl-core:client:updatePlayerData', Player.PlayerData.source)
        return true
    else
        TriggerClientEvent('sl-core:client:notify', source, 'Inventory too heavy!', 'error')
        return false
    end
end

function SLCore.Functions.RemoveItem(source, item, amount, slot)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    amount = tonumber(amount) or 1
    slot = tonumber(slot)

    if slot then
        if Player.PlayerData.items[slot].amount > amount then
            Player.PlayerData.items[slot].amount = Player.PlayerData.items[slot].amount - amount
            TriggerClientEvent('sl-core:client:updatePlayerData', Player.PlayerData.source)
            return true
        else
            Player.PlayerData.items[slot] = nil
            TriggerClientEvent('sl-core:client:updatePlayerData', Player.PlayerData.source)
            return true
        end
    else
        local slots = GetSlotsWithItem(Player.PlayerData.items, item)
        local amountToRemove = amount
        
        if not slots then return false end
        
        for _, slot in pairs(slots) do
            if amountToRemove <= 0 then break end
            
            if Player.PlayerData.items[slot].amount > amountToRemove then
                Player.PlayerData.items[slot].amount = Player.PlayerData.items[slot].amount - amountToRemove
                amountToRemove = 0
            else
                amountToRemove = amountToRemove - Player.PlayerData.items[slot].amount
                Player.PlayerData.items[slot] = nil
            end
        end
        
        if amountToRemove > 0 then return false end
        
        TriggerClientEvent('sl-core:client:updatePlayerData', Player.PlayerData.source)
        return true
    end
end

function SLCore.Functions.GetItemBySlot(source, slot)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return nil end
    return Player.PlayerData.items[slot]
end

function SLCore.Functions.GetItemByName(source, item)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return nil end
    
    local slots = GetSlotsWithItem(Player.PlayerData.items, item)
    if not slots then return nil end
    
    local totalAmount = 0
    for _, slot in pairs(slots) do
        totalAmount = totalAmount + Player.PlayerData.items[slot].amount
    end
    
    return totalAmount
end

-- Helper Functions
function GetFirstAvailableSlot(items)
    for i = 1, SLConfig.Player.MaxInvSlots do
        if not items[i] then
            return i
        end
    end
    return nil
end

function GetSlotsWithItem(items, itemName)
    local slots = {}
    for slot, item in pairs(items) do
        if item.name:lower() == itemName:lower() then
            table.insert(slots, slot)
        end
    end
    return #slots > 0 and slots or nil
end

function SLCore.Player.GetTotalWeight(items)
    local weight = 0
    if not items then return 0 end
    
    for _, item in pairs(items) do
        weight = weight + (item.weight * item.amount)
    end
    return weight
end
