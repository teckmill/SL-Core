local SLCore = exports['sl-core']:GetCoreObject()

-- Utility Functions
local function FormatDate(timestamp, format)
    return os.date(format or Config.DateFormat, timestamp)
end

local function CalculateGrowthRate(current, previous)
    if not previous or previous == 0 then return 0 end
    return ((current - previous) / previous) * 100
end

-- Analytics Functions
local function CollectFinancialMetrics(businessId, startDate, endDate)
    local metrics = {}
    
    -- Get revenue data
    local revenue = MySQL.query.await([[
        SELECT SUM(amount) as total
        FROM business_transactions
        WHERE business_id = ? AND type = 'income'
        AND created_at BETWEEN ? AND ?
    ]], {businessId, startDate, endDate})
    
    -- Get expense data
    local expenses = MySQL.query.await([[
        SELECT SUM(amount) as total
        FROM business_transactions
        WHERE business_id = ? AND type = 'expense'
        AND created_at BETWEEN ? AND ?
    ]], {businessId, startDate, endDate})
    
    metrics.revenue = revenue[1].total or 0
    metrics.expenses = expenses[1].total or 0
    metrics.profit = metrics.revenue - metrics.expenses
    metrics.profitMargin = metrics.revenue > 0 and (metrics.profit / metrics.revenue) * 100 or 0
    
    return metrics
end

local function CollectInventoryMetrics(businessId)
    local metrics = {}
    
    -- Get inventory data
    local inventory = MySQL.query.await([[
        SELECT 
            i.*,
            COALESCE(s.total_sold, 0) as units_sold
        FROM inventory_items i
        LEFT JOIN (
            SELECT item_id, SUM(quantity) as total_sold
            FROM sales_history
            WHERE business_id = ?
            AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
            GROUP BY item_id
        ) s ON s.item_id = i.id
        WHERE i.business_id = ?
    ]], {businessId, businessId})
    
    metrics.totalItems = #inventory
    metrics.totalValue = 0
    metrics.lowStock = 0
    
    for _, item in ipairs(inventory) do
        metrics.totalValue = metrics.totalValue + (item.quantity * item.price)
        if item.quantity <= item.reorder_point then
            metrics.lowStock = metrics.lowStock + 1
        end
    end
    
    return metrics
end

local function CollectEmployeeMetrics(businessId, startDate, endDate)
    local metrics = {}
    
    -- Get employee performance data
    local performance = MySQL.query.await([[
        SELECT 
            AVG(performance_score) as avg_performance,
            AVG(attendance_rate) as avg_attendance,
            AVG(productivity_rate) as avg_productivity
        FROM employee_analytics
        WHERE business_id = ?
        AND period_start >= ? AND period_end <= ?
    ]], {businessId, startDate, endDate})
    
    metrics.avgPerformance = performance[1].avg_performance or 0
    metrics.avgAttendance = performance[1].avg_attendance or 0
    metrics.avgProductivity = performance[1].avg_productivity or 0
    
    return metrics
end

local function GenerateReport(businessId, reportType, startDate, endDate)
    local report = {
        businessId = businessId,
        type = reportType,
        period = {
            start = startDate,
            end = endDate
        },
        metrics = {}
    }
    
    -- Collect metrics based on report type
    if reportType == 'financial' or reportType == 'complete' then
        report.metrics.financial = CollectFinancialMetrics(businessId, startDate, endDate)
    end
    
    if reportType == 'inventory' or reportType == 'complete' then
        report.metrics.inventory = CollectInventoryMetrics(businessId)
    end
    
    if reportType == 'employees' or reportType == 'complete' then
        report.metrics.employees = CollectEmployeeMetrics(businessId, startDate, endDate)
    end
    
    -- Store report in database
    MySQL.insert.await([[
        INSERT INTO report_history (business_id, report_data, generated_by)
        VALUES (?, ?, ?)
    ]], {
        businessId,
        json.encode(report),
        'system'
    })
    
    return report
end

local function CheckAlertThresholds(businessId)
    local alerts = {}
    
    -- Check financial thresholds
    local financials = CollectFinancialMetrics(businessId, os.date('%Y-%m-%d', os.time() - 86400), os.date('%Y-%m-%d'))
    
    if financials.profitMargin < Config.Alerts.thresholds.financial.profitMargin then
        table.insert(alerts, {
            type = 'financial',
            priority = 'high',
            message = string.format('Profit margin (%.2f%%) below threshold (%.2f%%)',
                financials.profitMargin, Config.Alerts.thresholds.financial.profitMargin)
        })
    end
    
    -- Check inventory thresholds
    local inventory = CollectInventoryMetrics(businessId)
    
    if inventory.lowStock > 0 then
        table.insert(alerts, {
            type = 'inventory',
            priority = 'medium',
            message = string.format('%d items are below reorder point', inventory.lowStock)
        })
    end
    
    -- Store alerts in database
    for _, alert in ipairs(alerts) do
        MySQL.insert.await([[
            INSERT INTO analytics_alerts 
            (business_id, alert_type, priority, message)
            VALUES (?, ?, ?, ?)
        ]], {
            businessId,
            alert.type,
            alert.priority,
            alert.message
        })
    end
    
    return alerts
end

-- Events
RegisterNetEvent('sl-analytics:server:generateReport', function(data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Verify business ownership/permissions
    local hasPermission = exports['sl-business']:HasPermission(Player.PlayerData.citizenid, data.businessId, 'reports')
    if not hasPermission then
        TriggerClientEvent('sl-core:client:notify', src, {
            title = "Error",
            description = "You don't have permission to generate reports",
            type = "error"
        })
        return
    end
    
    local report = GenerateReport(data.businessId, data.type, data.startDate, data.endDate)
    
    TriggerClientEvent('sl-analytics:client:displayReport', src, report)
end)

RegisterNetEvent('sl-analytics:server:exportReport', function(data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Verify business ownership/permissions
    local hasPermission = exports['sl-business']:HasPermission(Player.PlayerData.citizenid, data.businessId, 'reports')
    if not hasPermission then
        TriggerClientEvent('sl-core:client:notify', src, {
            title = "Error",
            description = "You don't have permission to export reports",
            type = "error"
        })
        return
    end
    
    MySQL.insert.await([[
        INSERT INTO export_jobs 
        (business_id, export_type, format, parameters, created_by)
        VALUES (?, ?, ?, ?, ?)
    ]], {
        data.businessId,
        data.reportType,
        data.format,
        json.encode(data.parameters),
        Player.PlayerData.citizenid
    })
    
    TriggerClientEvent('sl-core:client:notify', src, {
        title = "Success",
        description = "Report export job created successfully",
        type = "success"
    })
end)

-- Callbacks
SLCore.Functions.CreateCallback('sl-analytics:server:getAnalytics', function(source, cb, businessId)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return cb(nil) end
    
    -- Verify business ownership/permissions
    local hasPermission = exports['sl-business']:HasPermission(Player.PlayerData.citizenid, businessId, 'analytics')
    if not hasPermission then return cb(nil) end
    
    -- Get analytics data
    local today = os.date('%Y-%m-%d')
    local thirtyDaysAgo = os.date('%Y-%m-%d', os.time() - (30 * 86400))
    
    local analytics = {
        financial = CollectFinancialMetrics(businessId, thirtyDaysAgo, today),
        inventory = CollectInventoryMetrics(businessId),
        employees = CollectEmployeeMetrics(businessId, thirtyDaysAgo, today)
    }
    
    cb(analytics)
end)

-- Exports
exports('GenerateReport', GenerateReport)
exports('CollectFinancialMetrics', CollectFinancialMetrics)
exports('CollectInventoryMetrics', CollectInventoryMetrics)
exports('CollectEmployeeMetrics', CollectEmployeeMetrics)
exports('CheckAlertThresholds', CheckAlertThresholds)
