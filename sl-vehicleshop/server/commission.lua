local SLCore = exports['sl-core']:GetCoreObject()

-- Database functions
function CreateSaleRecord(citizenid, vehicleData, salePrice, commission)
    local success = MySQL.insert.await('INSERT INTO vehicle_sales (seller_id, vehicle_model, sale_price, commission, sale_date) VALUES (?, ?, ?, ?, ?)', {
        citizenid,
        vehicleData.model,
        salePrice,
        commission,
        os.time()
    })
    return success
end

function GetDealerSales(citizenid, timeframe)
    local query = 'SELECT * FROM vehicle_sales WHERE seller_id = ?'
    local params = {citizenid}
    
    if timeframe then
        local startTime = os.time() - (timeframe * 24 * 60 * 60)
        query = query .. ' AND sale_date >= ?'
        params[#params + 1] = startTime
    end
    
    local sales = MySQL.query.await(query, params)
    return sales
end

function GetTotalCommission(citizenid, timeframe)
    local query = 'SELECT SUM(commission) as total FROM vehicle_sales WHERE seller_id = ?'
    local params = {citizenid}
    
    if timeframe then
        local startTime = os.time() - (timeframe * 24 * 60 * 60)
        query = query .. ' AND sale_date >= ?'
        params[#params + 1] = startTime
    end
    
    local result = MySQL.query.await(query, params)
    return result[1].total or 0
end

-- Core Functions
function CalculateCommission(salePrice)
    local baseCommission = Config.Commission.BaseRate
    local bonusThresholds = Config.Commission.BonusThresholds
    local commission = salePrice * baseCommission
    
    -- Apply bonus rates for high-value sales
    for _, threshold in ipairs(bonusThresholds) do
        if salePrice >= threshold.minPrice then
            commission = salePrice * threshold.rate
            break
        end
    end
    
    return math.ceil(commission)
end

function ProcessSaleCommission(src, vehicleData, salePrice)
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return false end
    
    -- Check if player is a car dealer
    if Player.PlayerData.job.name ~= Config.DealerJob then
        return false
    end
    
    local commission = CalculateCommission(salePrice)
    
    -- Record sale
    local success = CreateSaleRecord(Player.PlayerData.citizenid, vehicleData, salePrice, commission)
    if success then
        -- Pay commission
        Player.Functions.AddMoney('bank', commission, 'vehicle-sale-commission')
        TriggerClientEvent('SLCore:Notify', src, 'Commission payment received: $'..commission, 'success')
        return true
    end
    
    return false
end

function GetDealerStats(src, timeframe)
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return nil end
    
    if Player.PlayerData.job.name ~= Config.DealerJob then
        return nil
    end
    
    local sales = GetDealerSales(Player.PlayerData.citizenid, timeframe)
    local totalCommission = GetTotalCommission(Player.PlayerData.citizenid, timeframe)
    
    return {
        totalSales = #sales,
        totalCommission = totalCommission,
        sales = sales
    }
end

-- Events
RegisterNetEvent('sl-vehicleshop:server:ProcessSale', function(vehicleData, salePrice)
    local src = source
    ProcessSaleCommission(src, vehicleData, salePrice)
end)

RegisterNetEvent('sl-vehicleshop:server:GetStats', function(timeframe)
    local src = source
    local stats = GetDealerStats(src, timeframe)
    if stats then
        TriggerClientEvent('sl-vehicleshop:client:ShowStats', src, stats)
    end
end)

-- Exports
exports('CalculateCommission', CalculateCommission)
exports('GetDealerStats', GetDealerStats)
