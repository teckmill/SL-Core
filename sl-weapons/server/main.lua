local SLCore = exports['sl-core']:GetCoreObject()

-- Update weapon durability
RegisterNetEvent('sl-weapons:server:UpdateDurability')
AddEventHandler('sl-weapons:server:UpdateDurability', function(weaponName, decrease)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end

    local weapon = Player.Functions.GetItemByName(weaponName)
    if not weapon then return end

    local newDurability = (weapon.info.quality or 100) - decrease
    if newDurability <= 0 then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.weapon_broken'), 'error')
        Player.Functions.RemoveItem(weaponName, 1)
        return
    end

    weapon.info.quality = newDurability
    Player.Functions.UpdateItemInfo(weapon.slot, weapon.info)
end)

-- Repair weapon
RegisterNetEvent('sl-weapons:server:RepairWeapon')
AddEventHandler('sl-weapons:server:RepairWeapon', function(weaponName)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end

    local weapon = Player.Functions.GetItemByName(weaponName)
    if not weapon then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.no_weapon'), 'error')
        return
    end

    local repairCost = Config.WeaponRepairCosts[weaponName]
    if not repairCost then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.cant_repair'), 'error')
        return
    end

    if Player.PlayerData.money.cash < repairCost then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.no_money'), 'error')
        return
    end

    Player.Functions.RemoveMoney('cash', repairCost)
    weapon.info.quality = 100
    Player.Functions.UpdateItemInfo(weapon.slot, weapon.info)
    TriggerClientEvent('SLCore:Notify', src, Lang:t('success.weapon_repaired'), 'success')
end)

-- Add weapon attachment
SLCore.Functions.CreateCallback('sl-weapons:server:AddAttachment', function(source, cb, weaponName, component)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return cb(false) end

    local weapon = Player.Functions.GetItemByName(weaponName)
    if not weapon then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.no_weapon'), 'error')
        return cb(false)
    end

    if not Config.WeaponAttachments[weaponName] or not table.contains(Config.WeaponAttachments[weaponName], component) then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.attachment_incompatible'), 'error')
        return cb(false)
    end

    local attachments = weapon.info.attachments or {}
    if table.contains(attachments, component) then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.attachment_already'), 'error')
        return cb(false)
    end

    table.insert(attachments, component)
    weapon.info.attachments = attachments
    Player.Functions.UpdateItemInfo(weapon.slot, weapon.info)
    TriggerClientEvent('SLCore:Notify', src, Lang:t('success.attachment_added'), 'success')
    cb(true)
end)

-- Remove weapon attachment
SLCore.Functions.CreateCallback('sl-weapons:server:RemoveAttachment', function(source, cb, weaponName, component)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return cb(false) end

    local weapon = Player.Functions.GetItemByName(weaponName)
    if not weapon then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.no_weapon'), 'error')
        return cb(false)
    end

    local attachments = weapon.info.attachments or {}
    local index = table.indexOf(attachments, component)
    if not index then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.no_attachment'), 'error')
        return cb(false)
    end

    table.remove(attachments, index)
    weapon.info.attachments = attachments
    Player.Functions.UpdateItemInfo(weapon.slot, weapon.info)
    TriggerClientEvent('SLCore:Notify', src, Lang:t('success.attachment_removed'), 'success')
    cb(true)
end)

-- Helper function to find index in table
function table.indexOf(table, value)
    for i, v in ipairs(table) do
        if v == value then
            return i
        end
    end
    return nil
end

-- Helper function to check if table contains value
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end
