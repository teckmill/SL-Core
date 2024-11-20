local SLCore = exports['sl-core']:GetCoreObject()

-- Load business finances
function LoadBusinessFinances(businessId)
    local success, result = pcall(function()
        return MySQL.query.await([[
            SELECT 
                t.*,
                DATE_FORMAT(t.created_at, '%Y-%m-%d %H:%i:%s') as formatted_date
            FROM business_transactions t
            WHERE t.business_id = ?
            ORDER BY t.created_at DESC
            LIMIT 100
        ]], {businessId})
    end)

    if success and result then
        return result
    end
    return {}
end

-- Process loan payment
function ProcessLoanPayment(businessId, loanId)
    local business = exports['sl-business']:GetBusinessData(businessId)
    if not business then return false end

    local success, loan = pcall(function()
        return MySQL.query.await('SELECT * FROM business_loans WHERE id = ? AND business_id = ?', {loanId, businessId})
    end)

    if not success or not loan[1] then return false end
    loan = loan[1]

    -- Calculate payment amount
    local monthlyInterest = loan.amount * (loan.interest_rate / 12)
    local monthlyPayment = (loan.amount / loan.term_months) + monthlyInterest

    -- Check if business has enough funds
    if business.funds < monthlyPayment then
        return false, 'Insufficient funds for loan payment'
    end

    -- Process payment
    local success = pcall(function()
        MySQL.transaction.await({
            {
                query = 'UPDATE businesses SET funds = funds - ? WHERE id = ?',
                values = {monthlyPayment, businessId}
            },
            {
                query = 'UPDATE business_loans SET remaining_balance = remaining_balance - ?, next_payment = DATE_ADD(next_payment, INTERVAL 1 MONTH) WHERE id = ?',
                values = {monthlyPayment - monthlyInterest, loanId}
            },
            {
                query = 'INSERT INTO business_transactions (business_id, type, amount, description) VALUES (?, ?, ?, ?)',
                values = {businessId, 'loan_payment', monthlyPayment, 'Loan payment - ID: ' .. loanId}
            }
        })
    end)

    if success then
        -- Check if loan is paid off
        if loan.remaining_balance - (monthlyPayment - monthlyInterest) <= 0 then
            MySQL.update.await('UPDATE business_loans SET status = ? WHERE id = ?', {'paid', loanId})
        end
    end

    return success
end

-- Apply for loan
function ApplyForLoan(businessId, amount, termMonths)
    local business = exports['sl-business']:GetBusinessData(businessId)
    if not business then return false end

    -- Validate loan amount
    if amount > Config.Finance.maxLoanAmount then
        return false, 'Loan amount exceeds maximum limit'
    end

    -- Check existing loans
    local success, existingLoans = pcall(function()
        return MySQL.query.await('SELECT COUNT(*) as count FROM business_loans WHERE business_id = ? AND status = ?', {
            businessId, 'active'
        })
    end)

    if success and existingLoans[1].count > 0 then
        return false, 'Business already has an active loan'
    end

    -- Calculate interest rate based on business reputation
    local interestRate = Config.Finance.interestRates.loan
    if business.reputation >= 75 then
        interestRate = interestRate * 0.8 -- 20% discount for high reputation
    elseif business.reputation <= 25 then
        interestRate = interestRate * 1.2 -- 20% penalty for low reputation
    end

    -- Create loan
    local success = pcall(function()
        MySQL.transaction.await({
            {
                query = 'INSERT INTO business_loans (business_id, amount, interest_rate, term_months, remaining_balance, next_payment) VALUES (?, ?, ?, ?, ?, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 1 MONTH))',
                values = {businessId, amount, interestRate, termMonths, amount}
            },
            {
                query = 'UPDATE businesses SET funds = funds + ? WHERE id = ?',
                values = {amount, businessId}
            },
            {
                query = 'INSERT INTO business_transactions (business_id, type, amount, description) VALUES (?, ?, ?, ?)',
                values = {businessId, 'loan_received', amount, 'Business loan received'}
            }
        })
    end)

    return success
end

-- Process insurance claim
function ProcessInsuranceClaim(businessId, data)
    local business = exports['sl-business']:GetBusinessData(businessId)
    if not business then return false end

    -- Validate claim amount
    if data.amount <= 0 then
        return false, 'Invalid claim amount'
    end

    -- Check if business has insurance
    local insurancePlan = Config.Finance.insurancePlans[business.insurance_plan]
    if not insurancePlan then
        return false, 'No active insurance plan'
    end

    -- Calculate coverage amount
    local coverageAmount = math.floor(data.amount * insurancePlan.coverage)

    -- Process claim
    local success = pcall(function()
        MySQL.transaction.await({
            {
                query = 'UPDATE businesses SET funds = funds + ? WHERE id = ?',
                values = {coverageAmount, businessId}
            },
            {
                query = 'INSERT INTO business_transactions (business_id, type, amount, description) VALUES (?, ?, ?, ?)',
                values = {businessId, 'insurance_claim', coverageAmount, 'Insurance claim - ' .. data.reason}
            }
        })
    end)

    return success, coverageAmount
end

-- Generate financial report
function GenerateFinancialReport(businessId, startDate, endDate)
    local success, result = pcall(function()
        return MySQL.query.await([[
            SELECT 
                DATE(created_at) as date,
                type,
                SUM(CASE WHEN type IN ('sale', 'deposit', 'insurance_claim') THEN amount ELSE 0 END) as income,
                SUM(CASE WHEN type IN ('withdrawal', 'payroll', 'loan_payment') THEN amount ELSE 0 END) as expenses
            FROM business_transactions
            WHERE business_id = ? AND created_at BETWEEN ? AND ?
            GROUP BY DATE(created_at), type
            ORDER BY date DESC
        ]], {businessId, startDate, endDate})
    end)

    if not success then return nil end

    -- Process results
    local report = {
        totalIncome = 0,
        totalExpenses = 0,
        netProfit = 0,
        dailyBreakdown = {},
        transactionTypes = {}
    }

    for _, row in ipairs(result) do
        -- Update totals
        report.totalIncome = report.totalIncome + row.income
        report.totalExpenses = report.totalExpenses + row.expenses

        -- Update daily breakdown
        if not report.dailyBreakdown[row.date] then
            report.dailyBreakdown[row.date] = {
                income = 0,
                expenses = 0
            }
        end
        report.dailyBreakdown[row.date].income = report.dailyBreakdown[row.date].income + row.income
        report.dailyBreakdown[row.date].expenses = report.dailyBreakdown[row.date].expenses + row.expenses

        -- Update transaction types
        if not report.transactionTypes[row.type] then
            report.transactionTypes[row.type] = 0
        end
        report.transactionTypes[row.type] = report.transactionTypes[row.type] + (row.income + row.expenses)
    end

    report.netProfit = report.totalIncome - report.totalExpenses
    return report
end

-- Events
RegisterNetEvent('sl-business:server:applyForLoan', function(businessId, amount, termMonths)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return end

    local business = exports['sl-business']:GetBusinessData(businessId)
    if not business or business.owner ~= Player.PlayerData.citizenid then
        TriggerClientEvent('sl-core:client:notify', source, 'You don\'t own this business', 'error')
        return
    end

    local success, result = ApplyForLoan(businessId, amount, termMonths)
    if success then
        TriggerClientEvent('sl-core:client:notify', source, 'Loan application approved', 'success')
    else
        TriggerClientEvent('sl-core:client:notify', source, result or 'Loan application failed', 'error')
    end
end)

RegisterNetEvent('sl-business:server:processLoanPayment', function(businessId, loanId)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return end

    local business = exports['sl-business']:GetBusinessData(businessId)
    if not business or business.owner ~= Player.PlayerData.citizenid then
        TriggerClientEvent('sl-core:client:notify', source, 'You don\'t own this business', 'error')
        return
    end

    local success, result = ProcessLoanPayment(businessId, loanId)
    if success then
        TriggerClientEvent('sl-core:client:notify', source, 'Loan payment processed', 'success')
    else
        TriggerClientEvent('sl-core:client:notify', source, result or 'Payment failed', 'error')
    end
end)

RegisterNetEvent('sl-business:server:processInsuranceClaim', function(businessId, data)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return end

    local business = exports['sl-business']:GetBusinessData(businessId)
    if not business or business.owner ~= Player.PlayerData.citizenid then
        TriggerClientEvent('sl-core:client:notify', source, 'You don\'t own this business', 'error')
        return
    end

    local success, amount = ProcessInsuranceClaim(businessId, data)
    if success then
        TriggerClientEvent('sl-core:client:notify', source, 'Insurance claim processed: $' .. amount, 'success')
    else
        TriggerClientEvent('sl-core:client:notify', source, amount or 'Claim processing failed', 'error')
    end
end)

-- Callbacks
SLCore.Functions.CreateCallback('sl-business:server:getFinancialReport', function(source, cb, businessId, startDate, endDate)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb(nil) end

    local business = exports['sl-business']:GetBusinessData(businessId)
    if not business or business.owner ~= Player.PlayerData.citizenid then
        return cb(nil)
    end

    local report = GenerateFinancialReport(businessId, startDate, endDate)
    cb(report)
end)

-- Exports
exports('LoadBusinessFinances', LoadBusinessFinances)
exports('ProcessLoanPayment', ProcessLoanPayment)
exports('ApplyForLoan', ApplyForLoan)
exports('ProcessInsuranceClaim', ProcessInsuranceClaim)
exports('GenerateFinancialReport', GenerateFinancialReport)
