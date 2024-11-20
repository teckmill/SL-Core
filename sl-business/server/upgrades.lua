local SLCore = exports['sl-core']:GetCoreObject()

-- Core Functions
function PurchaseUpgrade(businessId, upgradeId)
    local business = exports['sl-business']:GetBusiness(businessId)
    if not business then return false end

    local businessType = Config.BusinessTypes[business.type]
    if not businessType or not businessType.upgrades or not businessType.upgrades[upgradeId] then
        return false
    end

    -- Check if already purchased
    if business.upgrades and business.upgrades[upgradeId] then
        return false, 'already_owned'
    end

    local upgrade = businessType.upgrades[upgradeId]
    
    -- Check if can afford
    if business.funds < upgrade.price then
        return false, 'insufficient_funds'
    end

    -- Initialize upgrades if not exists
    if not business.upgrades then business.upgrades = {} end

    -- Process purchase
    local success = exports['sl-business']:ProcessTransaction(businessId, {
        type = 'withdraw',
        amount = upgrade.price,
        description = 'Upgrade purchase: ' .. upgrade.label
    })

    if success then
        -- Update business upgrades
        business.upgrades[upgradeId] = {
            purchasedAt = os.time(),
            price = upgrade.price
        }

        success = exports['sl-business']:UpdateBusiness(businessId, {
            upgrades = business.upgrades
        })

        if success then
            -- Apply upgrade effects
            if upgrade.effects then
                ApplyUpgradeEffects(businessId, upgrade.effects)
            end
            return true
        end
    end

    return false
end

function ApplyUpgradeEffects(businessId, effects)
    local business = exports['sl-business']:GetBusiness(businessId)
    if not business then return end

    local updates = {}

    for key, value in pairs(effects) do
        if key == 'storage' then
            -- Increase storage capacity
            updates.maxStorage = (business.maxStorage or 100) + value
        elseif key == 'employees' then
            -- Increase max employees
            updates.maxEmployees = (business.maxEmployees or 5) + value
        elseif key == 'income' then
            -- Apply income multiplier
            updates.incomeMultiplier = (business.incomeMultiplier or 1.0) + value
        end
    end

    if next(updates) then
        exports['sl-business']:UpdateBusiness(businessId, updates)
    end
end

-- Events
RegisterNetEvent('sl-business:server:purchaseUpgrade', function(businessId, upgradeId)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end

    local business = exports['sl-business']:GetBusiness(businessId)
    if not business or business.owner ~= Player.PlayerData.citizenid then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.no_permission'), 'error')
        return
    end

    local success, reason = PurchaseUpgrade(businessId, upgradeId)
    
    if success then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('success.upgrade_purchased'), 'success')
        -- Refresh client business data
        TriggerClientEvent('sl-business:client:businessUpdated', src, businessId, {
            upgrades = business.upgrades
        })
    else
        local errorMessage = reason == 'already_owned' and 'error.upgrade_owned' or 'error.insufficient_funds'
        TriggerClientEvent('SLCore:Notify', src, Lang:t(errorMessage), 'error')
    end
end)

-- Exports
exports('PurchaseUpgrade', PurchaseUpgrade)
