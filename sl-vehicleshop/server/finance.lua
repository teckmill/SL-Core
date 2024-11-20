local SLCore = exports['sl-core']:GetCoreObject()

-- Database functions
function CreateFinanceContract(citizenid, vehicleData, terms)
    local success = MySQL.insert.await('INSERT INTO vehicle_finance (citizenid, vehicle, model, plate, price, down_payment, monthly_payment, payments_remaining, interest_rate, next_payment) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
        citizenid,
        json.encode(vehicleData),
        vehicleData.model,
        vehicleData.plate,
        terms.price,
        terms.downPayment,
        terms.monthlyPayment,
        terms.totalPayments,
        terms.interestRate,
        os.time() + (30 * 24 * 60 * 60) -- 30 days from now
    })
    return success
end

function GetPlayerContracts(citizenid)
    local contracts = MySQL.query.await('SELECT * FROM vehicle_finance WHERE citizenid = ?', {citizenid})
    return contracts
end

function UpdateContract(contractId, paymentsRemaining, nextPayment)
    local success = MySQL.update.await('UPDATE vehicle_finance SET payments_remaining = ?, next_payment = ? WHERE id = ?', {
        paymentsRemaining,
        nextPayment,
        contractId
    })
    return success
end

function DeleteContract(contractId)
    local success = MySQL.query.await('DELETE FROM vehicle_finance WHERE id = ?', {contractId})
    return success
end

-- Core Functions
function CalculateFinanceTerms(price, downPayment, months)
    local interestRate = Config.Finance.InterestRate
    local loanAmount = price - downPayment
    local monthlyInterest = interestRate / 12
    local monthlyPayment = (loanAmount * monthlyInterest * math.pow(1 + monthlyInterest, months)) / (math.pow(1 + monthlyInterest, months) - 1)
    
    return {
        price = price,
        downPayment = downPayment,
        loanAmount = loanAmount,
        monthlyPayment = math.ceil(monthlyPayment),
        totalPayments = months,
        interestRate = interestRate,
        totalCost = (monthlyPayment * months) + downPayment
    }
end

function ProcessMonthlyPayment(src, contractId)
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return false end

    local contracts = MySQL.query.await('SELECT * FROM vehicle_finance WHERE id = ?', {contractId})
    if not contracts[1] then return false end

    local contract = contracts[1]
    if contract.citizenid ~= Player.PlayerData.citizenid then return false end

    local bankBalance = Player.PlayerData.money['bank']
    if bankBalance < contract.monthly_payment then return false end

    -- Process payment
    Player.Functions.RemoveMoney('bank', contract.monthly_payment, 'vehicle-finance-payment')
    
    local paymentsRemaining = contract.payments_remaining - 1
    local nextPayment = os.time() + (30 * 24 * 60 * 60) -- 30 days from now
    
    if paymentsRemaining <= 0 then
        -- Contract completed
        DeleteContract(contractId)
        TriggerClientEvent('SLCore:Notify', src, 'Vehicle loan paid off!', 'success')
    else
        -- Update contract
        UpdateContract(contractId, paymentsRemaining, nextPayment)
        TriggerClientEvent('SLCore:Notify', src, 'Monthly payment processed. '..paymentsRemaining..' payments remaining', 'success')
    end
    
    return true
end

-- Events
RegisterNetEvent('sl-vehicleshop:server:FinanceVehicle', function(vehicleData, downPayment, months)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    if not Config.Finance.Enabled then
        TriggerClientEvent('SLCore:Notify', src, 'Financing is not available', 'error')
        return
    end
    
    local terms = CalculateFinanceTerms(vehicleData.price, downPayment, months)
    
    -- Check if player can afford down payment
    if Player.PlayerData.money['bank'] < terms.downPayment then
        TriggerClientEvent('SLCore:Notify', src, 'Insufficient funds for down payment', 'error')
        return
    end
    
    -- Process down payment
    Player.Functions.RemoveMoney('bank', terms.downPayment, 'vehicle-finance-down-payment')
    
    -- Create finance contract
    local success = CreateFinanceContract(Player.PlayerData.citizenid, vehicleData, terms)
    if success then
        TriggerClientEvent('SLCore:Notify', src, 'Vehicle financed successfully', 'success')
        TriggerClientEvent('sl-vehicleshop:client:FinanceSuccess', src, vehicleData)
    else
        -- Refund down payment if contract creation fails
        Player.Functions.AddMoney('bank', terms.downPayment, 'vehicle-finance-refund')
        TriggerClientEvent('SLCore:Notify', src, 'Failed to create finance contract', 'error')
    end
end)

RegisterNetEvent('sl-vehicleshop:server:PayMonthly', function(contractId)
    local src = source
    ProcessMonthlyPayment(src, contractId)
end)

-- Exports
exports('CalculateFinanceTerms', CalculateFinanceTerms)
exports('GetPlayerContracts', GetPlayerContracts)
