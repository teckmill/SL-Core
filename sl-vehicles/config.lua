Config = {}

-- General Settings
Config.UseKeys = true -- Require keys to enter vehicles
Config.LockDistance = 5.0 -- Distance to lock/unlock vehicles
Config.HotwireTime = 20 -- Time in seconds to hotwire
Config.EngineToggle = true -- Allow manual engine toggle

-- Fuel Settings
Config.FuelSystem = true
Config.FuelDecor = "_FUEL_LEVEL"
Config.FuelUsage = {
    [1.0] = 1.0, -- Default fuel usage
    [0.9] = 0.9, -- Slightly damaged engine
    [0.8] = 0.8,
    [0.7] = 0.7,
    [0.6] = 0.6,
    [0.5] = 0.5,
    [0.4] = 0.4,
    [0.3] = 0.3,
    [0.2] = 0.2,
    [0.1] = 0.1,
    [0.0] = 0.0,
}

-- Damage Settings
Config.DamageSystem = true
Config.EngineDisablePercent = 35.0 -- Engine dies below this health percentage
Config.DamageFactors = {
    Body = 1.0,
    Engine = 1.0,
    Petrol = 1.0,
}

-- Vehicle Classes
Config.VehicleClasses = {
    [0] = "Compacts",
    [1] = "Sedans",
    [2] = "SUVs",
    [3] = "Coupes",
    [4] = "Muscle",
    [5] = "Sports Classics",
    [6] = "Sports",
    [7] = "Super",
    [8] = "Motorcycles",
    [9] = "Off-road",
    [10] = "Industrial",
    [11] = "Utility",
    [12] = "Vans",
    [13] = "Cycles",
    [14] = "Boats",
    [15] = "Helicopters",
    [16] = "Planes",
    [17] = "Service",
    [18] = "Emergency",
    [19] = "Military",
    [20] = "Commercial",
    [21] = "Trains"
}

-- Vehicle Ownership
Config.AllowSelling = true
Config.SellPercentage = 60 -- Percentage of original price when selling
Config.MaxVehicles = 5 -- Maximum vehicles per player 