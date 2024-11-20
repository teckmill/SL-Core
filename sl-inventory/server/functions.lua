local SLCore = exports['sl-core']:GetCoreObject()

-- Get slot by item
local function GetSlotByItem(items, itemName)
    for slot, item in pairs(items) do
        if item.name == itemName then
            return tonumber(slot)
        end
    end
    return nil
end

-- Add item to inventory
function AddItem(source, item, amount, slot, info)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local totalWeight = GetTotalWeight(Player.PlayerData.items)
    local itemInfo = SLCore.Shared.Items[item:lower()]
    if not itemInfo then return false end
    
    amount = tonumber(amount) or 1
    slot = tonumber(slot) or GetFirstSlotByItem(Player.PlayerData.items, item)
    info = info or {}
    
    if itemInfo["type"] == "weapon" then
        amount = 1
        info.serie = info.serie or tostring(SLCore.Shared.RandomInt(2) .. SLCore.Shared.RandomStr(3) .. SLCore.Shared.RandomInt(1) .. SLCore.Shared.RandomStr(2) .. SLCore.Shared.RandomInt(3) .. SLCore.Shared.RandomStr(4))
    end
    
    if (totalWeight + (itemInfo["weight"] * amount)) <= Config.MaxInventoryWeight then
        if (slot and Player.PlayerData.items[slot]) and (Player.PlayerData.items[slot].name:lower() == item:lower()) and (itemInfo["type"] == "item" and not itemInfo["unique"]) then
            Player.PlayerData.items[slot].amount = Player.PlayerData.items[slot].amount + amount
            Player.Functions.SetPlayerData("items", Player.PlayerData.items)
            
            TriggerEvent("sl-log:server:CreateLog", "inventory", "Added Item", "green", "**".. GetPlayerName(source) .. "** got item: [slot:" ..slot.."], itemname: " .. itemInfo["name"] .. ", added amount: " .. amount .. ", new total amount: " .. Player.PlayerData.items[slot].amount)
            
            return true
        elseif not Player.PlayerData.items[slot] then
            Player.PlayerData.items[slot] = {
                name = itemInfo["name"],
                amount = amount,
                info = info or "",
                label = itemInfo["label"],
                description = itemInfo["description"] or "",
                weight = itemInfo["weight"],
                type = itemInfo["type"],
                unique = itemInfo["unique"],
                useable = itemInfo["useable"],
                image = itemInfo["image"],
                shouldClose = itemInfo["shouldClose"],
                slot = slot,
                combinable = itemInfo["combinable"]
            }
            Player.Functions.SetPlayerData("items", Player.PlayerData.items)
            
            TriggerEvent("sl-log:server:CreateLog", "inventory", "Added Item", "green", "**".. GetPlayerName(source) .. "** got item: [slot:" ..slot.."], itemname: " .. itemInfo["name"] .. ", added amount: " .. amount .. ", new total amount: " .. amount)
            
            return true
        end
    end
    return false
end

-- Remove item from inventory
function RemoveItem(source, item, amount, slot)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    amount = tonumber(amount) or 1
    slot = tonumber(slot) or GetSlotByItem(Player.PlayerData.items, item)
    
    if slot then
        if Player.PlayerData.items[slot].amount > amount then
            Player.PlayerData.items[slot].amount = Player.PlayerData.items[slot].amount - amount
            Player.Functions.SetPlayerData("items", Player.PlayerData.items)
            
            TriggerEvent("sl-log:server:CreateLog", "inventory", "Removed Item", "red", "**".. GetPlayerName(source) .. "** lost item: [slot:" ..slot.."], itemname: " .. Player.PlayerData.items[slot].name .. ", removed amount: " .. amount .. ", new total amount: " .. Player.PlayerData.items[slot].amount)
            
            return true
        else
            Player.PlayerData.items[slot] = nil
            Player.Functions.SetPlayerData("items", Player.PlayerData.items)
            
            TriggerEvent("sl-log:server:CreateLog", "inventory", "Removed Item", "red", "**".. GetPlayerName(source) .. "** lost item: [slot:" ..slot.."], itemname: " .. item .. ", removed amount: " .. amount .. ", item removed")
            
            return true
        end
    end
    return false
end

-- Get total weight of inventory
function GetTotalWeight(items)
    local weight = 0
    if not items then return 0 end
    
    for _, item in pairs(items) do
        weight = weight + (item.weight * item.amount)
    end
    return weight
end

-- Export functions
exports('AddItem', AddItem)
exports('RemoveItem', RemoveItem)
exports('GetTotalWeight', GetTotalWeight)
