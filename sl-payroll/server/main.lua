local SLCore = exports['sl-core']:GetCoreObject()

-- Utility Functions
local function CalculateTax(amount)
    if not Config.Taxes.enabled then return 0 end
    
    local totalTax = 0
    local remainingAmount = amount
    
    for i, bracket in ipairs(Config.Taxes.brackets) do
        local nextBracket = Config.Taxes.brackets[i + 1]
        local taxableAmount = nextBracket and math.min(remainingAmount, nextBracket.threshold - bracket.threshold) or remainingAmount
        
        totalTax = totalTax + (taxableAmount * bracket.rate)
        remainingAmount = remainingAmount - taxableAmount
        
        if remainingAmount <= 0 then break end
    end
    
    return totalTax
end

local function CalculateDeductions(employeeId, grossPay)
    local deductions = {
        total = 0,
        breakdown = {}
    }
    
    local result = MySQL.query.await('SELECT * FROM employee_benefits WHERE employee_id = ?', {employeeId})
    if not result[1] then return deductions end
    
    local benefits = result[1]
    
    if benefits.healthcare_plan then
        local plan = Config.Benefits.healthcare.plans[benefits.healthcare_plan]
        if plan then
            deductions.breakdown.healthcare = plan.cost
            deductions.total = deductions.total + plan.cost
        end
    end
    
    if benefits.retirement_contribution > 0 then
        local contribution = grossPay * benefits.retirement_contribution
        deductions.breakdown.retirement = contribution
        deductions.total = deductions.total + contribution
    end
    
    if benefits.insurance_plan then
        local premium = grossPay * Config.Taxes.deductions.insurance
        deductions.breakdown.insurance = premium
        deductions.total = deductions.total + premium
    end
    
    return deductions
end

local function CalculateNetPay(employeeId, grossPay)
    local tax = CalculateTax(grossPay)
    local deductions = CalculateDeductions(employeeId, grossPay)
    
    return {
        gross = grossPay,
        tax = tax,
        deductions = deductions.total,
        net = grossPay - tax - deductions.total,
        breakdown = {
            tax = tax,
            deductions = deductions.breakdown
        }
    }
end

local function ProcessPayroll(businessId, payPeriod)
    local success, result = pcall(function()
        local employees = MySQL.query.await('SELECT ep.*, eb.* FROM employee_payroll ep LEFT JOIN employee_benefits eb ON eb.employee_id = ep.id WHERE ep.business_id = ?', {businessId})
        
        for _, employee in ipairs(employees) do
            local timeEntries = MySQL.query.await('SELECT SUM(regular_hours) as total_regular, SUM(overtime_hours) as total_overtime FROM time_entries WHERE employee_id = ? AND clock_in BETWEEN ? AND ? AND status = "approved"', {employee.id, payPeriod.start, payPeriod.end})
            
            local regularHours = timeEntries[1].total_regular or 0
            local overtimeHours = timeEntries[1].total_overtime or 0
            
            local regularPay = regularHours * employee.base_rate
            local overtimePay = overtimeHours * (employee.base_rate * Config.OvertimeMultiplier)
            local grossPay = regularPay + overtimePay
            
            local bonuses = MySQL.query.await('SELECT SUM(amount) as total FROM payroll_adjustments WHERE employee_id = ? AND status = "approved" AND processed_at IS NULL', {employee.id})
            grossPay = grossPay + (bonuses[1].total or 0)
            
            local payDetails = CalculateNetPay(employee.id, grossPay)
            
            MySQL.insert.await('INSERT INTO payroll_history (employee_id, business_id, pay_period_start, pay_period_end, regular_hours, overtime_hours, gross_pay, net_pay, tax_amount, deductions_amount, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())', {
                employee.id, businessId, payPeriod.start, payPeriod.end,
                regularHours, overtimeHours, payDetails.gross, payDetails.net,
                payDetails.tax, payDetails.deductions
            })
        end
        return true
    end)
    return success and result or false
end

local function ProcessPTORequest(requestId, status, approvedBy)
    local success, result = pcall(function()
        local request = MySQL.query.await('SELECT * FROM pto_requests WHERE id = ?', {requestId})
        if not request[1] then return false end
        
        if status == 'approved' then
            local employee = MySQL.query.await('SELECT eb.* FROM employee_benefits eb WHERE eb.employee_id = ?', {request[1].employee_id})
            
            if not employee[1] or employee[1].pto_balance < request[1].hours_requested then
                return false
            end
            
            MySQL.transaction.await({
                {
                    query = 'UPDATE employee_benefits SET pto_balance = pto_balance - ?, pto_used = pto_used + ? WHERE employee_id = ?',
                    values = {request[1].hours_requested, request[1].hours_requested, request[1].employee_id}
                },
                {
                    query = 'UPDATE pto_requests SET status = ?, approved_by = ? WHERE id = ?',
                    values = {status, approvedBy, requestId}
                }
            })
        else
            MySQL.update.await('UPDATE pto_requests SET status = ?, approved_by = ? WHERE id = ?', {status, approvedBy, requestId})
        end
        
        local employee = MySQL.query.await('SELECT citizen_id FROM employee_payroll WHERE id = ?', {request[1].employee_id})
        
        if employee[1] then
            local Player = SLCore.Functions.GetPlayerByCitizenId(employee[1].citizen_id)
            if Player then
                TriggerClientEvent('sl-core:client:notify', Player.PlayerData.source, {
                    title = "PTO Request " .. status:upper(),
                    description = string.format("Your PTO request for %s hours has been %s", request[1].hours_requested, status),
                    type = status == 'approved' and 'success' or 'error',
                    duration = 5000
                })
            end
        end
        
        return true
    end)
    return success and result or false
end

RegisterNetEvent('sl-payroll:server:requestPTO', function(data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local employee = MySQL.query.await('SELECT ep.* FROM employee_payroll ep WHERE ep.citizen_id = ?', {Player.PlayerData.citizenid})
    
    if not employee[1] then
        TriggerClientEvent('sl-core:client:notify', src, {
            title = "Error",
            description = "You are not registered as an employee",
            type = "error"
        })
        return
    end
    
    MySQL.insert.await('INSERT INTO pto_requests (employee_id, start_date, end_date, hours_requested, request_type, notes) VALUES (?, ?, ?, ?, ?, ?)', {
        employee[1].id,
        data.startDate,
        data.endDate,
        data.hours,
        data.type,
        data.notes
    })
    
    TriggerClientEvent('sl-core:client:notify', src, {
        title = "Success",
        description = "PTO request submitted successfully",
        type = "success"
    })
end)

SLCore.Functions.CreateCallback('sl-payroll:server:getPayrollInfo', function(source, cb)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return cb(nil) end
    
    local employee = MySQL.query.await('SELECT ep.*, eb.healthcare_plan, eb.retirement_contribution, eb.pto_balance, eb.pto_used, eb.insurance_plan FROM employee_payroll ep LEFT JOIN employee_benefits eb ON eb.employee_id = ep.id WHERE ep.citizen_id = ?', {Player.PlayerData.citizenid})
    
    if not employee[1] then return cb(nil) end
    
    local transactions = MySQL.query.await('SELECT * FROM payroll_transactions WHERE employee_id = ? ORDER BY created_at DESC LIMIT 5', {employee[1].id})
    local ptoRequests = MySQL.query.await('SELECT * FROM pto_requests WHERE employee_id = ? AND status = "pending"', {employee[1].id})
    
    cb({
        employee = employee[1],
        transactions = transactions,
        ptoRequests = ptoRequests
    })
end)

exports('ProcessPayroll', ProcessPayroll)
exports('ProcessPTORequest', ProcessPTORequest)
exports('CalculateNetPay', CalculateNetPay)
