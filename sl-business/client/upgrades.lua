local SLCore = exports['sl-core']:GetCoreObject()

-- Upgrade Menu Functions
function OpenUpgradeMenu()
    local business = exports['sl-business']:GetCurrentBusiness()
    if not business then return end

    local businessType = Config.BusinessTypes[business.type]
    if not businessType or not businessType.upgrades then return end

    local menu = {
        {
            header = Lang:t('info.upgrade_menu'),
            icon = "fas fa-arrow-up",
            isMenuHeader = true
        }
    }

    -- Add available upgrades
    for id, upgrade in pairs(businessType.upgrades) do
        local hasUpgrade = business.upgrades and business.upgrades[id]
        menu[#menu + 1] = {
            header = upgrade.label,
            txt = hasUpgrade and "Already purchased" or ("Price: $" .. upgrade.price),
            icon = hasUpgrade and "fas fa-check" or "fas fa-coins",
            params = {
                event = hasUpgrade and "" or "sl-business:client:purchaseUpgrade",
                args = {
                    upgradeId = id,
                    price = upgrade.price,
                    label = upgrade.label
                }
            },
            disabled = hasUpgrade
        }
    end

    -- Add back button
    menu[#menu + 1] = {
        header = Lang:t('menu.back'),
        icon = "fas fa-arrow-left",
        params = {
            event = "sl-business:client:openMenu"
        }
    }

    exports['sl-menu']:openMenu(menu)
end

-- Events
RegisterNetEvent('sl-business:client:purchaseUpgrade', function(data)
    local business = exports['sl-business']:GetCurrentBusiness()
    if not business then return end

    -- Confirm purchase
    local confirm = exports['sl-input']:ShowInput({
        header = Lang:t('info.confirm_purchase'),
        submitText = "Confirm",
        inputs = {
            {
                text = "Type 'CONFIRM' to purchase " .. data.label .. " for $" .. data.price,
                name = "confirm",
                type = "text",
                isRequired = true
            }
        }
    })

    if confirm and confirm.confirm == 'CONFIRM' then
        TriggerServerEvent('sl-business:server:purchaseUpgrade', business.id, data.upgradeId)
    end
end)

-- Menu Events
RegisterNetEvent('sl-business:client:openUpgradeMenu', OpenUpgradeMenu)
