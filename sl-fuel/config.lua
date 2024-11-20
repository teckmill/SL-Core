Config = {}

-- General Settings
Config.UseESX = false -- Set to true if using ESX framework
Config.UseLegacyFuel = false -- Set to true to use LegacyFuel's fuel system

-- Fuel Settings
Config.FuelDecor = "_FUEL_LEVEL" -- Don't touch
Config.FuelUsage = {
    [1.0] = 1.0, -- Full throttle
    [0.9] = 0.9,
    [0.8] = 0.8,
    [0.7] = 0.7,
    [0.6] = 0.6,
    [0.5] = 0.5,
    [0.4] = 0.4,
    [0.3] = 0.3,
    [0.2] = 0.2,
    [0.1] = 0.1,
    [0.0] = 0.0, -- Engine idling
}

-- Price Settings
Config.CostMultiplier = 3.0 -- Price multiplier for fuel cost
Config.GlobalTax = 0.15 -- Global tax on fuel purchases

-- Gas Station Settings
Config.MaxFuel = 100.0
Config.RefillSpeed = 1.0 -- How fast to refill (in fuel units per second)
Config.PumpModels = {
    [-2007231801] = true,
    [1339433404] = true,
    [1694452750] = true,
    [1933174915] = true,
    [-462817101] = true,
    [-469694731] = true,
    [-164877493] = true
}

-- Locations of all gas stations
Config.GasStations = {
    vector3(49.4187, 2778.793, 58.043),
    vector3(263.894, 2606.463, 44.983),
    vector3(1039.958, 2671.134, 39.550),
    vector3(1207.260, 2660.175, 37.899),
    vector3(2539.685, 2594.192, 37.944),
    vector3(2679.858, 3263.946, 55.240),
    vector3(2005.055, 3773.887, 32.403),
    vector3(1687.156, 4929.392, 42.078),
    vector3(1701.314, 6416.028, 32.763),
    vector3(179.857, 6602.839, 31.868),
    vector3(-94.4619, 6419.594, 31.489),
    vector3(-2554.996, 2334.40, 33.078),
    vector3(-1800.375, 803.661, 138.651),
    vector3(-1437.622, -276.747, 46.207),
    vector3(-2096.243, -320.286, 13.168),
    vector3(-724.619, -935.1631, 19.213),
    vector3(-526.019, -1211.003, 18.184),
    vector3(-70.2148, -1761.792, 29.534),
    vector3(265.648, -1261.309, 29.292),
    vector3(819.653, -1028.846, 26.403),
    vector3(1208.951, -1402.567, 35.224),
    vector3(1181.381, -330.847, 69.316),
    vector3(620.843, 269.100, 103.089),
    vector3(2581.321, 362.039, 108.468),
    vector3(176.631, -1562.025, 29.263),
    vector3(176.631, -1562.025, 29.263),
    vector3(-319.292, -1471.715, 30.549),
    vector3(1784.324, 3330.55, 41.253)
}

-- Jerry Can Settings
Config.JerryCanCost = 100
Config.JerryCanCapacity = 20.0
Config.JerryCanRefillCost = 50

-- Electric Vehicle Settings
Config.ElectricVehicles = {
    [`teslapd`] = true,
    [`models`] = true,
    [`modelx`] = true,
    [`cyber`] = true,
}
