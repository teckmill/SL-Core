local SLCore = nil
local CoreReady = false

-- Register Employee Callbacks
local function RegisterEmployeeCallbacks()
    if not CoreReady then return end

    SLCore.Functions.CreateCallback('sl-business:server:GetEmployeeData', function(source, cb, businessId, employeeId)
        local result = MySQL.Sync.fetchSingle('SELECT * FROM business_employees WHERE business_id = ? AND id = ?', {
            businessId, employeeId
        })
        cb(result)
    end)

    SLCore.Functions.CreateCallback('sl-business:server:GetEmployeeGrade', function(source, cb, businessId, citizenid)
        local result = MySQL.Sync.fetchSingle('SELECT grade FROM business_employees WHERE business_id = ? AND identifier = ?', {
            businessId, citizenid
        })
        cb(result and result.grade or 0)
    end)

    SLCore.Functions.CreateCallback('sl-business:server:getEmployeeData', function(source, cb, businessId, employeeId)
        if not CoreReady then return cb(nil) end
        
        local employees = GetBusinessEmployees(businessId)
        for _, employee in ipairs(employees) do
            if employee.citizen_id == employeeId then
                cb(employee)
                return
            end
        end
        cb(nil)
    end)
    
    SLCore.Functions.CreateCallback('sl-business:server:getEmployees', function(source, cb, businessId)
        if not CoreReady then return cb({}) end
        cb(GetBusinessEmployees(businessId))
    end)
    
    print('^2[SL-Business:Employees] ^7Callbacks registered successfully')
end

-- Wait for core to be ready
CreateThread(function()
    while SLCore == nil do
        if GetResourceState('sl-core') == 'started' then
            SLCore = exports['sl-core']:GetCoreObject()
            if SLCore then
                CoreReady = true
                print('^2[SL-Business:Employees] ^7Successfully connected to SL-Core')
                RegisterEmployeeCallbacks()
                break
            end
        end
        Wait(100)
    end
end)

-- Initialize Database Tables
CreateThread(function()
    while not CoreReady do Wait(100) end
    
    local queries = {
        [[
            CREATE TABLE IF NOT EXISTS `business_employees` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `business_id` INT(11) NOT NULL,
                `citizen_id` VARCHAR(50) NOT NULL,
                `role` VARCHAR(50) NOT NULL DEFAULT 'employee',
                `wage` INT(11) NOT NULL DEFAULT 0,
                `performance_data` TEXT,
                PRIMARY KEY (`id`),
                INDEX `business_id` (`business_id`),
                INDEX `citizen_id` (`citizen_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `employee_shifts` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `business_id` INT(11) NOT NULL,
                `citizen_id` VARCHAR(50) NOT NULL,
                `start_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                `end_time` TIMESTAMP NULL DEFAULT NULL,
                PRIMARY KEY (`id`),
                INDEX `business_id` (`business_id`),
                INDEX `citizen_id` (`citizen_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `offline_payments` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `citizen_id` VARCHAR(50) NOT NULL,
                `amount` INT(11) NOT NULL,
                `reason` VARCHAR(255) NOT NULL,
                PRIMARY KEY (`id`),
                INDEX `citizen_id` (`citizen_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `business_transactions` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `business_id` INT(11) NOT NULL,
                `type` VARCHAR(50) NOT NULL,
                `amount` INT(11) NOT NULL,
                `description` VARCHAR(255) NOT NULL,
                PRIMARY KEY (`id`),
                INDEX `business_id` (`business_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]]
    }

    for _, query in ipairs(queries) do
        local success = MySQL.Sync.execute(query)
        if not success then
            print('^1[SL-Business:Employees] ^7Failed to execute query: ' .. query)
        end
    end
    
    print('^2[SL-Business:Employees] ^7Database tables initialized successfully')
end)

local EmployeeCache = {}

-- Load business employees
function LoadBusinessEmployees(businessId)
    if not CoreReady then return {} end
    
    local success, result = pcall(function()
        return MySQL.query.await('SELECT * FROM business_employees WHERE business_id = ?', {businessId})
    end)

    if success and result then
        EmployeeCache[businessId] = result
    end
end

-- Get business employees
function GetBusinessEmployees(businessId)
    if not CoreReady then return {} end
    
    if not EmployeeCache[businessId] then
        LoadBusinessEmployees(businessId)
    end
    return EmployeeCache[businessId] or {}
end

-- Update employee role
function UpdateEmployeeRole(businessId, employeeId, role)
    if not CoreReady then return false end
    
    local success = pcall(function()
        MySQL.update.await('UPDATE business_employees SET role = ? WHERE business_id = ? AND citizen_id = ?', {
            role, businessId, employeeId
        })
    end)

    if success then
        LoadBusinessEmployees(businessId)
        return true
    end
    return false
end

-- Update employee wage
function UpdateEmployeeWage(businessId, employeeId, wage)
    if not CoreReady then return false end
    
    -- Validate wage
    if wage < Config.EmployeeSettings.minWage or wage > Config.EmployeeSettings.maxWage then
        return false, 'Invalid wage amount'
    end

    local success = pcall(function()
        MySQL.update.await('UPDATE business_employees SET wage = ? WHERE business_id = ? AND citizen_id = ?', {
            wage, businessId, employeeId
        })
    end)

    if success then
        LoadBusinessEmployees(businessId)
        return true
    end
    return false
end

-- Process employee payroll
function ProcessPayroll(businessId)
    if not CoreReady then return false end
    
    local employees = GetBusinessEmployees(businessId)
    local business = exports['sl-business']:GetBusinessData(businessId)
    if not business then return false end

    local totalWages = 0
    for _, employee in ipairs(employees) do
        totalWages = totalWages + employee.wage
    end

    -- Check if business has enough funds
    if business.funds < totalWages then
        return false, 'Insufficient funds for payroll'
    end

    -- Process payments
    local success = pcall(function()
        MySQL.transaction.await({
            {
                query = 'UPDATE businesses SET funds = funds - ? WHERE id = ?',
                values = {totalWages, businessId}
            },
            {
                query = 'INSERT INTO business_transactions (business_id, type, amount, description) VALUES (?, ?, ?, ?)',
                values = {businessId, 'payroll', totalWages, 'Employee payroll payment'}
            }
        })

        -- Pay each employee
        for _, employee in ipairs(employees) do
            local Player = SLCore.Functions.GetPlayerByCitizenId(employee.citizen_id)
            if Player then
                Player.Functions.AddMoney('bank', employee.wage, 'business-payroll')
                TriggerClientEvent('sl-core:client:notify', Player.PlayerData.source, 'You received your paycheck: $' .. employee.wage, 'success')
            else
                -- Store offline payment
                MySQL.insert.await('INSERT INTO offline_payments (citizen_id, amount, reason) VALUES (?, ?, ?)', {
                    employee.citizen_id, employee.wage, 'Business payroll'
                })
            end
        end
    end)

    return success
end

-- Track employee performance
function UpdateEmployeePerformance(businessId, employeeId, data)
    if not CoreReady then return false end
    
    -- Get current performance data
    local success, currentData = pcall(function()
        return MySQL.scalar.await('SELECT performance_data FROM business_employees WHERE business_id = ? AND citizen_id = ?', {
            businessId, employeeId
        })
    end)

    if not success then return false end

    -- Update performance data
    local performanceData = currentData and json.decode(currentData) or {}
    -- Merge the new data into performanceData
    for k, v in pairs(data) do
        performanceData[k] = v
    end

    success = pcall(function()
        MySQL.update.await('UPDATE business_employees SET performance_data = ? WHERE business_id = ? AND citizen_id = ?', {
            json.encode(performanceData), businessId, employeeId
        })
    end)

    return success
end

-- Employee shift management
function StartEmployeeShift(businessId, employeeId)
    if not CoreReady then return false end
    
    local success = pcall(function()
        MySQL.insert.await('INSERT INTO employee_shifts (business_id, citizen_id, start_time) VALUES (?, ?, CURRENT_TIMESTAMP)', {
            businessId, employeeId
        })
    end)

    return success
end

function EndEmployeeShift(businessId, employeeId)
    if not CoreReady then return false end
    
    local success, shift = pcall(function()
        return MySQL.query.await('SELECT * FROM employee_shifts WHERE business_id = ? AND citizen_id = ? AND end_time IS NULL', {
            businessId, employeeId
        })
    end)

    if success and shift[1] then
        success = pcall(function()
            MySQL.update.await('UPDATE employee_shifts SET end_time = CURRENT_TIMESTAMP WHERE id = ?', {shift[1].id})
        end)

        if success then
            -- Calculate hours worked and update performance
            local hoursWorked = os.difftime(os.time(), os.time(shift[1].start_time)) / 3600
            UpdateEmployeePerformance(businessId, employeeId, {
                hoursWorked = hoursWorked,
                shiftCompleted = true
            })
        end
    end

    return success
end

-- Events
RegisterNetEvent('sl-business:server:updateEmployeeRole', function(businessId, employeeId, role)
    if not CoreReady or not SLCore then return end
    
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return end

    local business = exports['sl-business']:GetBusinessData(businessId)
    if not business or business.owner ~= Player.PlayerData.citizenid then
        TriggerClientEvent('sl-core:client:notify', source, 'You don\'t own this business', 'error')
        return
    end

    local success = UpdateEmployeeRole(businessId, employeeId, role)
    TriggerClientEvent('sl-core:client:notify', source, success and 'Role updated' or 'Update failed', success and 'success' or 'error')
end)

RegisterNetEvent('sl-business:server:updateEmployeeWage', function(businessId, employeeId, wage)
    if not CoreReady or not SLCore then return end
    
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local success = UpdateEmployeeWage(businessId, employeeId, wage)
    if success then
        TriggerClientEvent('sl-core:client:notify', src, 'Wage updated successfully', 'success')
        TriggerClientEvent('sl-business:client:employeeWageUpdated', src, businessId, employeeId, wage)
    else
        TriggerClientEvent('sl-core:client:notify', src, 'Failed to update wage', 'error')
    end
end)

RegisterNetEvent('sl-business:server:startShift', function(businessId)
    if not CoreReady or not SLCore then return end
    
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return end
    
    local success = StartEmployeeShift(businessId, Player.PlayerData.citizenid)
    TriggerClientEvent('sl-core:client:notify', source, success and 'Shift started' or 'Failed to start shift', success and 'success' or 'error')
end)

RegisterNetEvent('sl-business:server:endShift', function(businessId)
    if not CoreReady or not SLCore then return end
    
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local success = EndEmployeeShift(businessId, Player.PlayerData.citizenid)
    TriggerClientEvent('sl-core:client:notify', src, success and 'Shift ended' or 'Failed to end shift', success and 'success' or 'error')
end)

-- Exports
exports('GetBusinessEmployees', GetBusinessEmployees)
exports('UpdateEmployeeRole', UpdateEmployeeRole)
exports('UpdateEmployeeWage', UpdateEmployeeWage)
exports('ProcessPayroll', ProcessPayroll)
exports('UpdateEmployeePerformance', UpdateEmployeePerformance)
exports('StartEmployeeShift', StartEmployeeShift)
exports('EndEmployeeShift', EndEmployeeShift)
