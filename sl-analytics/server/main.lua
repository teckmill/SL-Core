local SLCore = exports['sl-core']:GetCoreObject()

local function CheckAlertThresholds(businessId, metricType, value)
    local success, result = pcall(function()
        local thresholds = MySQL.query.await([[
            SELECT * FROM alert_thresholds 
            WHERE business_id = ? AND metric_type = ?
            ORDER BY threshold_value DESC
        ]], {businessId, metricType})
        
        if not thresholds[1] then return end
        
        for _, threshold in ipairs(thresholds) do
            if value >= threshold.threshold_value then
                MySQL.insert.await([[
                    INSERT INTO business_alerts 
                    (business_id, alert_type, metric_type, metric_value, threshold_id, created_at)
                    VALUES (?, ?, ?, ?, ?, NOW())
                ]], {
                    businessId,
                    threshold.alert_type,
                    metricType,
                    value,
                    threshold.id
                })
                
                local owners = MySQL.query.await([[
                    SELECT citizen_id 
                    FROM business_employees 
                    WHERE business_id = ? AND role = 'owner'
                ]], {businessId})
                
                for _, owner in ipairs(owners) do
                    local Player = SLCore.Functions.GetPlayerByCitizenId(owner.citizen_id)
                    if Player then
                        TriggerClientEvent('sl-core:client:notify', Player.PlayerData.source, {
                            title = "Business Alert",
                            description = string.format("%s threshold reached: %s", metricType, value),
                            type = "warning",
                            duration = 10000
                        })
                    end
                end
                
                break
            end
        end
        
        return true
    end)
    
    return success and result or false
end

local function RecordMetric(businessId, metricType, value)
    local success = pcall(function()
        MySQL.insert.await([[
            INSERT INTO business_metrics 
            (business_id, metric_type, metric_value, created_at)
            VALUES (?, ?, ?, NOW())
        ]], {businessId, metricType, value})
        
        CheckAlertThresholds(businessId, metricType, value)
    end)
    
    return success
end

RegisterNetEvent('sl-analytics:server:recordMetric', function(data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local hasPermission = exports['sl-business']:HasPermission(Player.PlayerData.citizenid, data.businessId, 'analytics.record')
    if not hasPermission then
        TriggerClientEvent('sl-core:client:notify', src, {
            title = "Error",
            description = "You don't have permission to record metrics",
            type = "error"
        })
        return
    end
    
    local success = RecordMetric(data.businessId, data.metricType, data.value)
    if success then
        TriggerClientEvent('sl-core:client:notify', src, {
            title = "Success",
            description = "Metric recorded successfully",
            type = "success"
        })
    else
        TriggerClientEvent('sl-core:client:notify', src, {
            title = "Error",
            description = "Failed to record metric",
            type = "error"
        })
    end
end)

SLCore.Functions.CreateCallback('sl-analytics:server:getMetrics', function(source, cb, data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return cb(nil) end
    
    local hasPermission = exports['sl-business']:HasPermission(Player.PlayerData.citizenid, data.businessId, 'analytics.view')
    if not hasPermission then
        return cb(nil)
    end
    
    local metrics = MySQL.query.await([[
        SELECT 
            metric_type,
            metric_value,
            created_at
        FROM business_metrics
        WHERE business_id = ?
        AND created_at BETWEEN ? AND ?
        ORDER BY created_at DESC
    ]], {
        data.businessId,
        data.startDate,
        data.endDate
    })
    
    local alerts = MySQL.query.await([[
        SELECT 
            ba.*,
            at.threshold_value,
            at.alert_type
        FROM business_alerts ba
        JOIN alert_thresholds at ON at.id = ba.threshold_id
        WHERE ba.business_id = ?
        AND ba.created_at BETWEEN ? AND ?
        ORDER BY ba.created_at DESC
    ]], {
        data.businessId,
        data.startDate,
        data.endDate
    })
    
    cb({
        metrics = metrics,
        alerts = alerts
    })
end)

exports('RecordMetric', RecordMetric)
exports('CheckAlertThresholds', CheckAlertThresholds)
