local SLCore = exports['sl-core']:GetCoreObject()

-- Menu Functions
function OpenBusinessMenu()
    local business = exports['sl-business']:GetCurrentBusiness()
    if not business then return end

    local businessType = Config.BusinessTypes[business.type]
    if not businessType then return end

    local menu = {
        {
            header = business.name,
            icon = "fas fa-building",
            isMenuHeader = true
        },
        {
            header = Lang:t('info.employee_menu'),
            txt = "Manage your employees",
            icon = "fas fa-users",
            params = {
                event = "sl-business:client:openEmployeeMenu",
            }
        },
        {
            header = Lang:t('info.inventory_menu'),
            txt = "Manage your inventory",
            icon = "fas fa-box",
            params = {
                event = "sl-business:client:openInventoryMenu",
            }
        }
    }

    -- Add upgrade menu if business type has upgrades
    if businessType.upgrades then
        menu[#menu + 1] = {
            header = Lang:t('info.upgrade_menu'),
            txt = "Purchase business upgrades",
            icon = "fas fa-arrow-up",
            params = {
                event = "sl-business:client:openUpgradeMenu",
            }
        }
    end

    -- Add funds management
    menu[#menu + 1] = {
        header = "Funds: $" .. business.funds,
        txt = "Manage business funds",
        icon = "fas fa-dollar-sign",
        params = {
            event = "sl-business:client:openFundsMenu",
        }
    }

    -- Add close button
    menu[#menu + 1] = {
        header = Lang:t('menu.close'),
        icon = "fas fa-times",
        params = {
            event = "sl-menu:client:closeMenu"
        }
    }

    exports['sl-menu']:openMenu(menu)
end

function OpenFundsMenu()
    local business = exports['sl-business']:GetCurrentBusiness()
    if not business then return end

    local menu = {
        {
            header = "Business Funds",
            txt = "Current Balance: $" .. business.funds,
            icon = "fas fa-dollar-sign",
            isMenuHeader = true
        },
        {
            header = "Deposit Funds",
            txt = "Add money to business account",
            icon = "fas fa-plus",
            params = {
                event = "sl-business:client:depositFunds",
            }
        },
        {
            header = "Withdraw Funds",
            txt = "Take money from business account",
            icon = "fas fa-minus",
            params = {
                event = "sl-business:client:withdrawFunds",
            }
        },
        {
            header = Lang:t('menu.back'),
            icon = "fas fa-arrow-left",
            params = {
                event = "sl-business:client:openMenu"
            }
        }
    }

    exports['sl-menu']:openMenu(menu)
end

-- Events
RegisterNetEvent('sl-business:client:depositFunds', function()
    local business = exports['sl-business']:GetCurrentBusiness()
    if not business then return end

    local input = exports['sl-input']:ShowInput({
        header = "Deposit Funds",
        submitText = "Confirm",
        inputs = {
            {
                text = "Amount",
                name = "amount",
                type = "number",
                isRequired = true,
                default = 100
            }
        }
    })

    if input and input.amount and tonumber(input.amount) > 0 then
        TriggerServerEvent('sl-business:server:processTransaction', business.id, {
            type = 'deposit',
            amount = tonumber(input.amount)
        })
    end
end)

RegisterNetEvent('sl-business:client:withdrawFunds', function()
    local business = exports['sl-business']:GetCurrentBusiness()
    if not business then return end

    local input = exports['sl-input']:ShowInput({
        header = "Withdraw Funds",
        submitText = "Confirm",
        inputs = {
            {
                text = "Amount",
                name = "amount",
                type = "number",
                isRequired = true,
                default = 100
            }
        }
    })

    if input and input.amount and tonumber(input.amount) > 0 then
        TriggerServerEvent('sl-business:server:processTransaction', business.id, {
            type = 'withdraw',
            amount = tonumber(input.amount)
        })
    end
end)
