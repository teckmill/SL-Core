local SLCore = exports['sl-core']:GetCoreObject()

-- Purchase Vehicle
RegisterNetEvent('sl-dealership:client:PurchaseVehicle', function(data)
    local vehicle = data.vehicle
    
    SLCore.Functions.TriggerCallback('sl-dealership:server:CanPurchaseVehicle', function(canBuy)
        if canBuy then
            -- Generate plate
            local plate = GeneratePlate()
            
            -- Trigger purchase
            TriggerServerEvent('sl-dealership:server:PurchaseVehicle', {
                model = vehicle.model,
                name = vehicle.name,
                plate = plate,
                price = vehicle.price,
                finance = false
            })
        else
            SLCore.Functions.Notify('You cannot afford this vehicle!', 'error')
        end
    end, vehicle.price)
end)

-- Finance Vehicle
RegisterNetEvent('sl-dealership:client:FinanceVehicle', function(data)
    local vehicle = data.vehicle
    
    SLCore.Functions.TriggerCallback('sl-dealership:server:CheckFinanceEligibility', function(eligible, reason)
        if eligible then
            OpenFinanceMenu(vehicle)
        else
            SLCore.Functions.Notify(reason, 'error')
        end
    end)
end)

-- Finance Menu
function OpenFinanceMenu(vehicle)
    local minDown = math.ceil(vehicle.price * (Config.Finance.minDownPayment / 100))
    
    local dialog = exports['sl-input']:ShowInput({
        header = "Finance " .. vehicle.name,
        submitText = "Calculate",
        inputs = {
            {
                text = "Down Payment (Min: $" .. minDown .. ")",
                name = "downpayment",
                type = "number",
                isRequired = true,
                default = minDown
            },
            {
                text = "Months (Max: " .. Config.Finance.maxMonths .. ")",
                name = "months",
                type = "number",
                isRequired = true,
                default = 12
            }
        }
    })
    
    if dialog then
        local downPayment = tonumber(dialog.downpayment)
        local months = tonumber(dialog.months)
        
        if downPayment < minDown then
            SLCore.Functions.Notify('Down payment too low!', 'error')
            return
        end
        
        if months > Config.Finance.maxMonths then
            SLCore.Functions.Notify('Too many months!', 'error')
            return
        end
        
        -- Calculate monthly payment
        local principal = vehicle.price - downPayment
        local rate = Config.Finance.interestRate / 100 / 12
        local monthlyPayment = principal * (rate * (1 + rate)^months) / ((1 + rate)^months - 1)
        
        -- Show confirmation menu
        local menu = {
            {
                header = "Finance Details",
                isMenuHeader = true,
                txt = "Vehicle: " .. vehicle.name .. "\nPrice: $" .. vehicle.price
            },
            {
                header = "Payment Details",
                isMenuHeader = true,
                txt = "Down Payment: $" .. downPayment .. 
                      "\nMonthly Payment: $" .. math.ceil(monthlyPayment) ..
                      "\nTotal Cost: $" .. math.ceil(downPayment + (monthlyPayment * months))
            },
            {
                header = "Confirm Finance",
                txt = "Accept financing terms",
                params = {
                    event = "sl-dealership:client:ConfirmFinance",
                    args = {
                        vehicle = vehicle,
                        downPayment = downPayment,
                        months = months,
                        monthlyPayment = math.ceil(monthlyPayment)
                    }
                }
            },
            {
                header = "Cancel",
                txt = "Return to vehicle menu",
                params = {
                    event = "sl-dealership:client:ViewVehicle",
                    args = {
                        displayId = displayId
                    }
                }
            }
        }
        
        exports['sl-menu']:openMenu(menu)
    end
end

-- Confirm Finance
RegisterNetEvent('sl-dealership:client:ConfirmFinance', function(data)
    local plate = GeneratePlate()
    
    TriggerServerEvent('sl-dealership:server:PurchaseVehicle', {
        model = data.vehicle.model,
        name = data.vehicle.name,
        plate = plate,
        price = data.vehicle.price,
        finance = true,
        downPayment = data.downPayment,
        months = data.months,
        monthlyPayment = data.monthlyPayment
    })
end)

-- Utility Functions
function GeneratePlate()
    local plate = ""
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    for i = 1, 8 do
        local rand = math.random(1, #charset)
        plate = plate .. string.sub(charset, rand, rand)
    end
    
    return plate
end 