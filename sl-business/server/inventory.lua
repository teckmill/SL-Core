local SLCore = exports['sl-core']:GetCoreObject()

-- Core Functions
function UpdateInventory(businessId, item, amount, type)
    local business = exports['sl-business']:GetBusiness(businessId)
    if not business then return false end

    -- Initialize inventory if not exists
    if not business.inventory then business.inventory = {} end
    if not business.inventory[item] then
        business.inventory[item] = {
            label = SLCore.Shared.Items[item] and SLCore.Shared.Items[item].label or item,
            amount = 0
        }
    end

    -- Calculate new amount
    local newAmount = type == 'add' 
        and business.inventory[item].amount + amount 
        or business.inventory[item].amount - amount

    -- Validate amount
    if newAmount < 0 then
        TriggerClientEvent('SLCore:Notify', source, Lang:t('error.insufficient_stock'), 'error')
        return false
    end

    -- Update inventory
    local success = exports['sl-business']:UpdateBusiness(businessId, {
        inventory = business.inventory
    })

    if success then
        business.inventory[item].amount = newAmount
        return true
    end
    return false
end

-- Events
RegisterNetEvent('sl-business:server:updateInventory', function(businessId, item, amount, type)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end

    local business = exports['sl-business']:GetBusiness(businessId)
    if not business or business.owner ~= Player.PlayerData.citizenid then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.no_permission'), 'error')
        return
    end

    if UpdateInventory(businessId, item, amount, type) then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('success.inventory_updated'), 'success')
    else
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.inventory_update_failed'), 'error')
    end
end)

-- Exports
exports('UpdateInventory', UpdateInventory)
