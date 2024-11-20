local SLCore = exports['sl-core']:GetCoreObject()

-- Initialize
CreateThread(function()
    MySQL.ready(function()
        -- Create tables if they don't exist
        MySQL.Sync.execute(LoadResourceFile(GetCurrentResourceName(), 'sql/dealership.sql'))
        InitializeStock()
    end)
end)

-- Stock Management
function InitializeStock()
    -- Initialize stock for all vehicles
    for category, data in pairs(Config.Categories) do
        for _, vehicle in ipairs(data.vehicles) do
            MySQL.Async.fetchAll('SELECT * FROM dealership_stock WHERE model = ?', {vehicle.model}, function(result)
                if #result == 0 then
                    MySQL.Async.execute('INSERT INTO dealership_stock (model, stock) VALUES (?, ?)',
                        {vehicle.model, math.random(5, 15)})
                end
            end)
        end
    end
end

-- Purchase Callbacks
SLCore.Functions.CreateCallback('sl-dealership:server:CanPurchaseVehicle', function(source, cb, price)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb(false) end
    
    cb(Player.PlayerData.money.bank >= price)
end)

SLCore.Functions.CreateCallback('sl-dealership:server:CheckFinanceEligibility', function(source, cb)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb(false, "Player not found") end
    
    -- Check credit score
    MySQL.Async.fetchAll('SELECT * FROM dealership_finances WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
        local creditScore = result[1] and result[1].credit_score or 500
        
        if creditScore < Config.Finance.minCreditScore then
            cb(false, "Credit score too low")
            return
        end
        
        -- Check job requirements
        if Player.PlayerData.job.payment < Config.Finance.jobRequirements.minimumPaycheck then
            cb(false, "Income too low")
            return
        end
        
        -- Check active loans
        if result[1] and result[1].active_loans >= 2 then
            cb(false, "Too many active loans")
            return
        end
        
        cb(true)
    end)
end)

-- Purchase Events
RegisterNetEvent('sl-dealership:server:PurchaseVehicle', function(data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Check stock
    local stock = MySQL.Sync.fetchScalar('SELECT stock FROM dealership_stock WHERE model = ?', {data.model})
    if stock <= 0 then
        TriggerClientEvent('SLCore:Notify', src, 'Vehicle out of stock!', 'error')
        return
    end
    
    -- Handle payment
    local success = false
    if data.finance then
        success = HandleFinancePurchase(src, data)
    else
        success = HandleCashPurchase(src, data)
    end
    
    if success then
        -- Update stock
        MySQL.Async.execute('UPDATE dealership_stock SET stock = stock - 1 WHERE model = ?', {data.model})
        
        -- Give vehicle to player
        exports['sl-vehicles']:GiveVehicle(src, data.model, data.plate)
        
        -- Handle commission if sold by dealer
        if data.salesperson then
            HandleCommission(data.salesperson, data.price)
        end
    end
end)

-- Test Drive Events
RegisterNetEvent('sl-dealership:server:StartTestDrive', function(deposit)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    if Player.PlayerData.money.bank >= deposit then
        Player.Functions.RemoveMoney('bank', deposit, 'test-drive-deposit')
        TriggerClientEvent('SLCore:Notify', src, 'Deposit paid: $' .. deposit, 'success')
        return true
    end
    
    return false
end)

RegisterNetEvent('sl-dealership:server:EndTestDrive', function(data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local dealership = Config.Dealerships[CurrentDealership]
    local deposit = dealership.testDrive.deposit
    
    -- Calculate refund
    local refund = deposit
    if data.damage > Config.TestDrive.damageLimit or not data.normal then
        refund = deposit / Config.TestDrive.penaltyMultiplier
    end
    
    Player.Functions.AddMoney('bank', refund, 'test-drive-refund')
    TriggerClientEvent('SLCore:Notify', src, 'Deposit refunded: $' .. refund, 'success')
end)

-- Commission Functions
function HandleCommission(citizenid, price)
    local Player = SLCore.Functions.GetPlayerByCitizenId(citizenid)
    if not Player then return end
    
    local commission = math.floor(price * (Config.Commission.percentage / 100))
    Player.Functions.AddMoney('bank', commission, 'vehicle-sale-commission')
    TriggerClientEvent('SLCore:Notify', Player.PlayerData.source, 'Commission received: $' .. commission, 'success')
end

-- Finance Functions
function HandleFinancePurchase(source, data)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    if Player.PlayerData.money.bank >= data.downPayment then
        Player.Functions.RemoveMoney('bank', data.downPayment, 'vehicle-downpayment')
        
        -- Record finance agreement
        MySQL.Async.execute([[
            INSERT INTO dealership_sales 
            (citizenid, vehicle, plate, price, finance, downpayment, monthly_payment, months_remaining, next_payment, salesperson)
            VALUES (?, ?, ?, ?, 1, ?, ?, ?, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 1 MONTH), ?)
        ]], {
            Player.PlayerData.citizenid,
            data.model,
            data.plate,
            data.price,
            data.downPayment,
            data.monthlyPayment,
            data.months,
            data.salesperson or nil
        })
        
        return true
    end
    
    return false
end

function HandleCashPurchase(source, data)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    if Player.PlayerData.money.bank >= data.price then
        Player.Functions.RemoveMoney('bank', data.price, 'vehicle-purchase')
        
        -- Record sale
        MySQL.Async.execute([[
            INSERT INTO dealership_sales 
            (citizenid, vehicle, plate, price, salesperson)
            VALUES (?, ?, ?, ?, ?)
        ]], {
            Player.PlayerData.citizenid,
            data.model,
            data.plate,
            data.price,
            data.salesperson or nil
        })
        
        return true
    end
    
    return false
end 