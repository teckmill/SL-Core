Config = {}

-- Vehicle Settings
Config.DefaultFuel = 100.0
Config.FuelUsage = {
    [0] = 1.0,   -- Compacts
    [1] = 1.0,   -- Sedans
    [2] = 1.2,   -- SUVs
    [3] = 1.3,   -- Coupes
    [4] = 1.4,   -- Muscle
    [5] = 1.2,   -- Sports Classics
    [6] = 1.5,   -- Sports
    [7] = 1.6,   -- Super
    [8] = 0.8,   -- Motorcycles
    [9] = 1.8,   -- Off-road
    [10] = 2.0,  -- Industrial
    [11] = 1.5,  -- Utility
    [12] = 1.8,  -- Vans
    [13] = 0.0,  -- Cycles
    [14] = 1.0,  -- Boats
    [15] = 1.0,  -- Helicopters
    [16] = 1.0,  -- Planes
    [17] = 1.4,  -- Service
    [18] = 1.8,  -- Emergency
    [19] = 2.0,  -- Military
    [20] = 1.8,  -- Commercial
}

-- Damage Settings
Config.DamageMultiplier = 1.0
Config.EngineFailureChance = 0.1
Config.BrakeFailureChance = 0.05

-- Racing Settings
Config.RaceTypes = {
    sprint = {
        name = "Sprint Race",
        minPlayers = 2,
        maxPlayers = 8,
        buyIn = 100,
        minBet = 50,
        maxBet = 1000
    },
    circuit = {
        name = "Circuit Race",
        minPlayers = 2,
        maxPlayers = 12,
        buyIn = 200,
        minBet = 100,
        maxBet = 2000
    }
}

-- Tuning Settings
Config.MaxTuningLevel = 5
Config.TuningPrices = {
    engine = {
        [1] = 1000,
        [2] = 2500,
        [3] = 5000,
        [4] = 8500,
        [5] = 15000
    },
    brakes = {
        [1] = 800,
        [2] = 1500,
        [3] = 3000,
        [4] = 5500,
        [5] = 8000
    },
    transmission = {
        [1] = 800,
        [2] = 2000,
        [3] = 4000,
        [4] = 7000,
        [5] = 10000
    },
    suspension = {
        [1] = 700,
        [2] = 1400,
        [3] = 2800,
        [4] = 4900,
        [5] = 7500
    },
    turbo = {
        [1] = 15000
    }
}
