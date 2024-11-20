local SLCore = exports['sl-core']:GetCoreObject()

-- Inventory Menu Functions
function OpenInventoryMenu()
    local business = exports['sl-business']:GetCurrentBusiness()
    if not business then return end

    local menu = {
        {
            header = Lang:t('info.inventory_menu'),
            icon = "fas fa-box",
            isMenuHeader = true
        },
        {
            header = "View Stock",
            txt = "Check current inventory",
            icon = "fas fa-list",
            params = {
                event = "sl-business:client:viewStock",
            }
        },
        {
            header = "Add Stock",
            txt = "Add items to inventory",
            icon = "fas fa-plus",
            params = {
                event = "sl-business:client:addStock",
            }
        },
        {
            header = "Remove Stock",
            txt = "Remove items from inventory",
            icon = "fas fa-minus",
            params = {
                event = "sl-business:client:removeStock",
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

function OpenStockViewMenu()
    local business = exports['sl-business']:GetCurrentBusiness()
    if not business then return end

    local menu = {
        {
            header = "Current Stock",
            icon = "fas fa-box",
            isMenuHeader = true
        }
    }

    -- Add inventory entries
    for item, data in pairs(business.inventory) do
        menu[#menu + 1] = {
            header = data.label,
            txt = "Amount: " .. data.amount,
            icon = "fas fa-box",
            params = {
                event = "sl-business:client:itemOptions",
                args = {
                    item = item,
                    data = data
                }
            }
        }
    end

    -- Add back button
    menu[#menu + 1] = {
        header = Lang:t('menu.back'),
        icon = "fas fa-arrow-left",
        params = {
            event = "sl-business:client:openInventoryMenu"
        }
    }

    exports['sl-menu']:openMenu(menu)
end

function OpenItemOptionsMenu(data)
    if not data.item or not data.data then return end

    local menu = {
        {
            header = data.data.label,
            txt = "Amount: " .. data.data.amount,
            icon = "fas fa-box",
            isMenuHeader = true
        },
        {
            header = "Add Stock",
            txt = "Add more of this item",
            icon = "fas fa-plus",
            params = {
                event = "sl-business:client:addItemStock",
                args = {
                    item = data.item,
                    label = data.data.label
                }
            }
        },
        {
            header = "Remove Stock",
            txt = "Remove some of this item",
            icon = "fas fa-minus",
            params = {
                event = "sl-business:client:removeItemStock",
                args = {
                    item = data.item,
                    label = data.data.label,
                    current = data.data.amount
                }
            }
        },
        {
            header = Lang:t('menu.back'),
            icon = "fas fa-arrow-left",
            params = {
                event = "sl-business:client:viewStock"
            }
        }
    }

    exports['sl-menu']:openMenu(menu)
end

-- Events
RegisterNetEvent('sl-business:client:addStock', function()
    local business = exports['sl-business']:GetCurrentBusiness()
    if not business then return end

    local input = exports['sl-input']:ShowInput({
        header = "Add Stock",
        submitText = "Confirm",
        inputs = {
            {
                text = "Item Name",
                name = "item",
                type = "text",
                isRequired = true
            },
            {
                text = "Amount",
                name = "amount",
                type = "number",
                isRequired = true,
                default = 1
            }
        }
    })

    if input and input.item and input.amount then
        TriggerServerEvent('sl-business:server:updateInventory', business.id, input.item, tonumber(input.amount), 'add')
    end
end)

RegisterNetEvent('sl-business:client:removeStock', function()
    local business = exports['sl-business']:GetCurrentBusiness()
    if not business then return end

    local input = exports['sl-input']:ShowInput({
        header = "Remove Stock",
        submitText = "Confirm",
        inputs = {
            {
                text = "Item Name",
                name = "item",
                type = "text",
                isRequired = true
            },
            {
                text = "Amount",
                name = "amount",
                type = "number",
                isRequired = true,
                default = 1
            }
        }
    })

    if input and input.item and input.amount then
        TriggerServerEvent('sl-business:server:updateInventory', business.id, input.item, tonumber(input.amount), 'remove')
    end
end)

RegisterNetEvent('sl-business:client:addItemStock', function(data)
    local business = exports['sl-business']:GetCurrentBusiness()
    if not business then return end

    local input = exports['sl-input']:ShowInput({
        header = "Add " .. data.label,
        submitText = "Confirm",
        inputs = {
            {
                text = "Amount to Add",
                name = "amount",
                type = "number",
                isRequired = true,
                default = 1
            }
        }
    })

    if input and input.amount then
        TriggerServerEvent('sl-business:server:updateInventory', business.id, data.item, tonumber(input.amount), 'add')
    end
end)

RegisterNetEvent('sl-business:client:removeItemStock', function(data)
    local business = exports['sl-business']:GetCurrentBusiness()
    if not business then return end

    local input = exports['sl-input']:ShowInput({
        header = "Remove " .. data.label,
        submitText = "Confirm",
        inputs = {
            {
                text = "Amount to Remove (Max: " .. data.current .. ")",
                name = "amount",
                type = "number",
                isRequired = true,
                default = 1
            }
        }
    })

    if input and input.amount and tonumber(input.amount) <= data.current then
        TriggerServerEvent('sl-business:server:updateInventory', business.id, data.item, tonumber(input.amount), 'remove')
    end
end)

-- Menu Events
RegisterNetEvent('sl-business:client:openInventoryMenu', OpenInventoryMenu)
RegisterNetEvent('sl-business:client:viewStock', OpenStockViewMenu)
RegisterNetEvent('sl-business:client:itemOptions', OpenItemOptionsMenu)
