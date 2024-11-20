local SLCore = nil
local CoreReady = false

-- Wait for core to be ready
CreateThread(function()
    while true do
        if GetResourceState('sl-core') == 'started' then
            SLCore = exports['sl-core']:GetCoreObject()
            if SLCore then
                CoreReady = true
                print('^2[SL-Vehicle:Functions] ^7Successfully connected to SL-Core')
                break
            end
        end
        Wait(100)
    end
end)

-- Vehicle Functions
function GeneratePlate()
    local plate = ''
    local exists = true
    
    while exists do
        plate = string.upper(string.format('%s%s%s%s%s', 
            string.char(math.random(65, 90)), -- A-Z
            string.char(math.random(65, 90)), -- A-Z
            math.random(0, 9), -- 0-9
            string.char(math.random(65, 90)), -- A-Z
            math.random(100, 999) -- 100-999
        ))
        
        local result = MySQL.single.await('SELECT 1 FROM player_vehicles WHERE plate = ?', {plate})
        exists = result ~= nil
    end
    
    return plate
end

function GetVehiclePrice(model)
    if not CoreReady then return 0 end
    
    -- First check if we have a custom price in our database
    local result = MySQL.single.await('SELECT price FROM vehicle_prices WHERE model = ?', {model})
    if result then
        return result.price
    end
    
    -- If no custom price, return a base price based on vehicle class
    local vehicleClass = GetVehicleClassFromModel(model)
    local basePrice = {
        [0] = 25000,   -- Compacts
        [1] = 35000,   -- Sedans
        [2] = 45000,   -- SUVs
        [3] = 50000,   -- Coupes
        [4] = 60000,   -- Muscle
        [5] = 70000,   -- Sports Classics
        [6] = 80000,   -- Sports
        [7] = 150000,  -- Super
        [8] = 15000,   -- Motorcycles
        [9] = 40000,   -- Off-road
        [10] = 100000, -- Industrial
        [11] = 35000,  -- Utility
        [12] = 40000,  -- Vans
        [13] = 0,      -- Cycles
        [14] = 500000, -- Boats
        [15] = 800000, -- Helicopters
        [16] = 1500000,-- Planes
        [17] = 40000,  -- Service
        [18] = 75000,  -- Emergency
        [19] = 100000, -- Military
        [20] = 150000, -- Commercial
        [21] = 0       -- Trains
    }
    
    return basePrice[vehicleClass] or 25000
end

function GetVehicleClassFromModel(model)
    if type(model) == 'string' then
        model = GetHashKey(model)
    end
    return GetVehicleClassFromName(model)
end

function GetVehicleUpgradePrice(category, level)
    local basePrices = {
        engine = 5000,
        brakes = 3000,
        transmission = 4000,
        suspension = 3500,
        armor = 7000,
        turbo = 15000,
        xenon = 2500
    }
    
    local multiplier = {
        [-1] = 0,
        [0] = 1,
        [1] = 1.5,
        [2] = 2.0,
        [3] = 2.5,
        [4] = 3.0,
        [5] = 3.5
    }
    
    if not basePrices[category] or not multiplier[level] then
        return 0
    end
    
    return math.floor(basePrices[category] * multiplier[level])
end

function CalculateVehicleDamage(vehicle)
    if not CoreReady then return 0 end
    
    local damage = {
        engine = (1000 - GetVehicleEngineHealth(vehicle)) / 10,
        body = (1000 - GetVehicleBodyHealth(vehicle)) / 10,
        tank = (1000 - GetVehiclePetrolTankHealth(vehicle)) / 10
    }
    
    local totalDamage = (damage.engine + damage.body + damage.tank) / 3
    return math.floor(totalDamage)
end

function GetVehicleRepairCost(vehicle)
    if not CoreReady then return 0 end
    
    local damage = CalculateVehicleDamage(vehicle)
    local baseRepairCost = GetVehiclePrice(GetEntityModel(vehicle)) * 0.001 -- 0.1% of vehicle price
    
    return math.floor(baseRepairCost * damage)
end

-- Exports
exports('GeneratePlate', GeneratePlate)
exports('GetVehiclePrice', GetVehiclePrice)
exports('GetVehicleUpgradePrice', GetVehicleUpgradePrice)
exports('CalculateVehicleDamage', CalculateVehicleDamage)
exports('GetVehicleRepairCost', GetVehicleRepairCost)
