local SLCore = exports['sl-core']:GetCoreObject()

-- Menu Functions
function OpenVehicleShop(shop)
    local shopConfig = Config.Shops[shop]
    if not shopConfig then return end

    local menuItems = {}
    for category, label in pairs(shopConfig.categories) do
        menuItems[#menuItems + 1] = {
            header = label,
            txt = Lang:t('info.choose_category'),
            icon = 'fas fa-car',
            params = {
                event = 'sl-vehicleshop:client:showVehicleCategory',
                args = {
                    shop = shop,
                    category = category
                }
            }
        }
    end

    exports['sl-menu']:openMenu(menuItems)
end

function ShowVehicleCategory(data)
    if not data.shop or not data.category then return end
    
    SLCore.Functions.TriggerCallback('sl-vehicleshop:server:getVehicles', function(vehicles)
        if not vehicles[data.category] then return end

        local menuItems = {
            {
                header = Config.Shops[data.shop].categories[data.category],
                txt = Lang:t('info.available_vehicles'),
                icon = 'fas fa-info-circle',
                isMenuHeader = true
            }
        }

        for model, info in pairs(vehicles[data.category]) do
            if info.stock > 0 then
                menuItems[#menuItems + 1] = {
                    header = SLCore.Shared.Vehicles[model].name,
                    txt = Lang:t('info.price', {amount = info.price}) .. ' | ' .. Lang:t('info.stock', {amount = info.stock}),
                    icon = 'fas fa-car',
                    params = {
                        event = 'sl-vehicleshop:client:showVehicleInfo',
                        args = {
                            shop = data.shop,
                            category = data.category,
                            model = model,
                            price = info.price
                        }
                    }
                }
            end
        end

        menuItems[#menuItems + 1] = {
            header = Lang:t('menu.back'),
            icon = 'fas fa-arrow-left',
            params = {
                event = 'sl-vehicleshop:client:OpenShop',
                args = {
                    shop = data.shop
                }
            }
        }

        exports['sl-menu']:openMenu(menuItems)
    end, data.shop)
end

function ShowVehicleInfo(data)
    if not data.shop or not data.model then return end

    local menuItems = {
        {
            header = SLCore.Shared.Vehicles[data.model].name,
            txt = Lang:t('info.price', {amount = data.price}),
            icon = 'fas fa-info-circle',
            isMenuHeader = true
        }
    }

    -- Test Drive Option
    if Config.Shops[data.shop].testDrive.enabled then
        menuItems[#menuItems + 1] = {
            header = Lang:t('menu.test_drive'),
            txt = Lang:t('info.test_drive'),
            icon = 'fas fa-key',
            params = {
                event = 'sl-vehicleshop:client:TestDrive',
                args = {
                    shop = data.shop,
                    vehicle = data.model
                }
            }
        }
    end

    -- Purchase Options
    menuItems[#menuItems + 1] = {
        header = Lang:t('menu.purchase'),
        txt = Lang:t('info.purchase_vehicle'),
        icon = 'fas fa-money-bill',
        params = {
            event = 'sl-vehicleshop:client:showPaymentOptions',
            args = {
                shop = data.shop,
                model = data.model,
                price = data.price
            }
        }
    }

    -- Back Button
    menuItems[#menuItems + 1] = {
        header = Lang:t('menu.back'),
        icon = 'fas fa-arrow-left',
        params = {
            event = 'sl-vehicleshop:client:showVehicleCategory',
            args = {
                shop = data.shop,
                category = data.category
            }
        }
    }

    exports['sl-menu']:openMenu(menuItems)
end

function ShowPaymentOptions(data)
    if not data.shop or not data.model then return end

    local menuItems = {
        {
            header = Lang:t('info.payment_options'),
            txt = Lang:t('info.price', {amount = data.price}),
            icon = 'fas fa-info-circle',
            isMenuHeader = true
        },
        {
            header = Lang:t('menu.cash'),
            txt = Lang:t('info.purchase_vehicle'),
            icon = 'fas fa-money-bill',
            params = {
                event = 'sl-vehicleshop:client:PurchaseVehicle',
                args = {
                    shop = data.shop,
                    vehicle = data.model,
                    paymentType = Config.PaymentType.cash
                }
            }
        },
        {
            header = Lang:t('menu.bank'),
            txt = Lang:t('info.purchase_vehicle'),
            icon = 'fas fa-university',
            params = {
                event = 'sl-vehicleshop:client:PurchaseVehicle',
                args = {
                    shop = data.shop,
                    vehicle = data.model,
                    paymentType = Config.PaymentType.bank
                }
            }
        }
    }

    -- Finance Option
    if Config.FinanceOptions then
        menuItems[#menuItems + 1] = {
            header = Lang:t('menu.finance'),
            txt = Lang:t('info.finance_vehicle'),
            icon = 'fas fa-percentage',
            params = {
                event = 'sl-vehicleshop:client:showFinanceOptions',
                args = {
                    shop = data.shop,
                    model = data.model,
                    price = data.price
                }
            }
        }
    end

    -- Back Button
    menuItems[#menuItems + 1] = {
        header = Lang:t('menu.back'),
        icon = 'fas fa-arrow-left',
        params = {
            event = 'sl-vehicleshop:client:showVehicleInfo',
            args = {
                shop = data.shop,
                category = data.category,
                model = data.model,
                price = data.price
            }
        }
    }

    exports['sl-menu']:openMenu(menuItems)
end

function ShowFinanceOptions(data)
    if not data.shop or not data.model then return end

    local minDownPayment = math.ceil(data.price * (Config.FinanceOptions.downPaymentMin / 100))
    
    local input = exports['sl-input']:ShowInput({
        header = Lang:t('info.finance_options'),
        submitText = Lang:t('menu.submit'),
        inputs = {
            {
                text = Lang:t('menu.down_payment') .. ' (Min: $' .. minDownPayment .. ')',
                name = "downPayment",
                type = "number",
                isRequired = true,
                default = tostring(minDownPayment)
            },
            {
                text = Lang:t('menu.monthly_payments') .. ' (Max: ' .. Config.FinanceOptions.maxPayments .. ')',
                name = "paymentCount",
                type = "number",
                isRequired = true,
                default = "12"
            }
        }
    })

    if input then
        local downPayment = tonumber(input.downPayment)
        local paymentCount = tonumber(input.paymentCount)

        if downPayment and paymentCount then
            TriggerEvent('sl-vehicleshop:client:FinanceVehicle', {
                shop = data.shop,
                vehicle = data.model,
                downPayment = downPayment,
                paymentCount = paymentCount
            })
        end
    end
end

-- Events
RegisterNetEvent('sl-vehicleshop:client:OpenVehicleShop', function(shop)
    OpenVehicleShop(shop)
end)

RegisterNetEvent('sl-vehicleshop:client:showVehicleCategory', function(data)
    ShowVehicleCategory(data)
end)

RegisterNetEvent('sl-vehicleshop:client:showVehicleInfo', function(data)
    ShowVehicleInfo(data)
end)

RegisterNetEvent('sl-vehicleshop:client:showPaymentOptions', function(data)
    ShowPaymentOptions(data)
end)

RegisterNetEvent('sl-vehicleshop:client:showFinanceOptions', function(data)
    ShowFinanceOptions(data)
end)
