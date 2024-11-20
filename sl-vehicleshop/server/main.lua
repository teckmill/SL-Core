local SLCore = exports['sl-core']:GetCoreObject()

-- Database initialization
CreateThread(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS player_vehicles (
            id INT AUTO_INCREMENT PRIMARY KEY,
            citizenid VARCHAR(50),
            vehicle VARCHAR(50),
            hash VARCHAR(50),
            plate VARCHAR(15),
            garage VARCHAR(50),
            state INT DEFAULT 1,
            finance BOOLEAN DEFAULT false,
            financeAmount INT DEFAULT 0,
            paymentsMade INT DEFAULT 0,
            paymentsLeft INT DEFAULT 0,
            paymentAmount INT DEFAULT 0,
            lastPayment TIMESTAMP
        )
    ]])
end)

-- Core Functions
function GeneratePlate()
    local plate = ""
    local plateFormat = "LLLDDD" -- L = letter, D = digit
    local usedPlates = {}
    
    -- Get all used plates
    local result = MySQL.query.await('SELECT plate FROM player_vehicles')
    for i = 1, #result do
        usedPlates[result[i].plate] = true
    end

    -- Generate unique plate
    repeat
        plate = ""
        for i = 1, #plateFormat do
            local c = plateFormat:sub(i,i)
            if c == "L" then
                plate = plate .. string.char(math.random(65, 90)) -- A-Z
            elseif c == "D" then
                plate = plate .. math.random(0, 9)
            end
        end
    until not usedPlates[plate]

    return plate
end

function CalculateFinance(price, downPayment, paymentCount)
    local financeAmount = price - downPayment
    local totalAmount = financeAmount * (1 + Config.FinanceOptions.interestRate)
    local paymentAmount = math.ceil(totalAmount / paymentCount)
    
    return {
        financeAmount = financeAmount,
        totalAmount = totalAmount,
        paymentAmount = paymentAmount,
        paymentCount = paymentCount
    }
end

function GetVehiclePrice(shop, model)
    for category, vehicles in pairs(Config.Vehicles) do
        if vehicles[model] then
            return vehicles[model].price
        end
    end
    return 0
end

function GetVehicleStock(shop, model)
    for category, vehicles in pairs(Config.Vehicles) do
        if vehicles[model] then
            return vehicles[model].stock
        end
    end
    return 0
end

function UpdateVehicleStock(shop, model, amount)
    for category, vehicles in pairs(Config.Vehicles) do
        if vehicles[model] then
            vehicles[model].stock = vehicles[model].stock + amount
            break
        end
    end
end

-- Events
RegisterNetEvent('sl-vehicleshop:server:purchaseVehicle', function(shop, model, paymentType)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end

    local price = GetVehiclePrice(shop, model)
    local stock = GetVehicleStock(shop, model)

    if stock <= 0 then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.no_stock'), 'error')
        return
    end

    if paymentType == Config.PaymentType.cash then
        if Player.PlayerData.money.cash < price then
            TriggerClientEvent('SLCore:Notify', src, Lang:t('error.not_enough_money'), 'error')
            return
        end
        Player.Functions.RemoveMoney('cash', price)
    elseif paymentType == Config.PaymentType.bank then
        if Player.PlayerData.money.bank < price then
            TriggerClientEvent('SLCore:Notify', src, Lang:t('error.not_enough_money'), 'error')
            return
        end
        Player.Functions.RemoveMoney('bank', price)
    else
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.invalid_payment'), 'error')
        return
    end

    -- Generate plate and add vehicle
    local plate = GeneratePlate()
    MySQL.insert('INSERT INTO player_vehicles (citizenid, vehicle, hash, plate) VALUES (?, ?, ?, ?)', {
        Player.PlayerData.citizenid,
        model,
        GetHashKey(model),
        plate
    })

    -- Update stock
    UpdateVehicleStock(shop, model, -1)

    -- Give commission to dealer if applicable
    local shopConfig = Config.Shops[shop]
    if shopConfig.job then
        local commission = math.floor(price * Config.Commission)
        if Player.PlayerData.job.name == shopConfig.job then
            Player.Functions.AddMoney('bank', commission)
            TriggerClientEvent('SLCore:Notify', src, Lang:t('success.commission_received', {amount = commission}), 'success')
        end
    end

    TriggerClientEvent('SLCore:Notify', src, Lang:t('success.vehicle_purchased'), 'success')
end)

RegisterNetEvent('sl-vehicleshop:server:financeVehicle', function(shop, model, downPayment, paymentCount)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end

    local price = GetVehiclePrice(shop, model)
    local stock = GetVehicleStock(shop, model)

    if stock <= 0 then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.no_stock'), 'error')
        return
    end

    -- Validate finance options
    if downPayment < (price * (Config.FinanceOptions.downPaymentMin / 100)) then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.invalid_downpayment'), 'error')
        return
    end

    if paymentCount > Config.FinanceOptions.maxPayments then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.invalid_payment_count'), 'error')
        return
    end

    -- Check if player can afford down payment
    if Player.PlayerData.money.bank < downPayment then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.not_enough_money_finance'), 'error')
        return
    end

    -- Calculate finance details
    local finance = CalculateFinance(price, downPayment, paymentCount)

    -- Take down payment
    Player.Functions.RemoveMoney('bank', downPayment)

    -- Generate plate and add vehicle
    local plate = GeneratePlate()
    MySQL.insert('INSERT INTO player_vehicles (citizenid, vehicle, hash, plate, finance, financeAmount, paymentsLeft, paymentAmount) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        Player.PlayerData.citizenid,
        model,
        GetHashKey(model),
        plate,
        true,
        finance.financeAmount,
        finance.paymentCount,
        finance.paymentAmount
    })

    -- Update stock
    UpdateVehicleStock(shop, model, -1)

    -- Give commission to dealer if applicable
    local shopConfig = Config.Shops[shop]
    if shopConfig.job then
        local commission = math.floor(downPayment * Config.FinanceCommission)
        if Player.PlayerData.job.name == shopConfig.job then
            Player.Functions.AddMoney('bank', commission)
            TriggerClientEvent('SLCore:Notify', src, Lang:t('success.commission_received', {amount = commission}), 'success')
        end
    end

    TriggerClientEvent('SLCore:Notify', src, Lang:t('success.vehicle_financed'), 'success')
end)

RegisterNetEvent('sl-vehicleshop:server:payTestDrive', function(shop)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end

    local shopConfig = Config.Shops[shop]
    local price = shopConfig.testDrive.price

    if Player.PlayerData.money.cash >= price then
        Player.Functions.RemoveMoney('cash', price)
        TriggerClientEvent('SLCore:Notify', src, Lang:t('success.testdrive_started', {time = shopConfig.testDrive.duration}), 'success')
    else
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.not_enough_money'), 'error')
    end
end)

-- Callbacks
SLCore.Functions.CreateCallback('sl-vehicleshop:server:getVehicles', function(source, cb, shop)
    local vehicles = {}
    for category, categoryVehicles in pairs(Config.Vehicles) do
        if Config.Shops[shop].categories[category] then
            vehicles[category] = categoryVehicles
        end
    end
    cb(vehicles)
end)
