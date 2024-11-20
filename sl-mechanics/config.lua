Config = {}

-- Job Settings
Config.MechanicJobs = {
    ['mechanic'] = true,
    ['bennys'] = true
}

-- Repair Settings
Config.RepairCosts = {
    ["body"] = 400,
    ["engine"] = 500,
    ["radiator"] = 300,
    ["drive_shaft"] = 400,
    ["brakes"] = 300,
    ["clutch"] = 350,
    ["fuel_injector"] = 250
}

Config.RepairTime = {
    ["body"] = 15000,    -- 15 seconds
    ["engine"] = 20000,  -- 20 seconds
    ["radiator"] = 10000,
    ["drive_shaft"] = 15000,
    ["brakes"] = 10000,
    ["clutch"] = 12000,
    ["fuel_injector"] = 8000
}

-- Locations
Config.Locations = {
    ["bennys"] = {
        coords = vector3(-211.55, -1324.55, 30.90),
        radius = 25.0,
        blip = {
            sprite = 446,
            color = 5,
            scale = 0.8,
            label = "Benny's Original Motor Works"
        }
    },
    ["paleto_mechanic"] = {
        coords = vector3(108.36, 6624.09, 31.79),
        radius = 25.0,
        blip = {
            sprite = 446,
            color = 5,
            scale = 0.8,
            label = "Paleto Bay Mechanics"
        }
    },
    ["sandy_mechanic"] = {
        coords = vector3(1178.11, 2640.15, 37.75),
        radius = 25.0,
        blip = {
            sprite = 446,
            color = 5,
            scale = 0.8,
            label = "Sandy Shores Mechanics"
        }
    }
}

-- Vehicle Classes that can be repaired
Config.AllowedVehicleClasses = {
    [0] = true,  -- Compacts
    [1] = true,  -- Sedans
    [2] = true,  -- SUVs
    [3] = true,  -- Coupes
    [4] = true,  -- Muscle
    [5] = true,  -- Sports Classics
    [6] = true,  -- Sports
    [7] = true,  -- Super
    [8] = true,  -- Motorcycles
    [9] = true,  -- Off-road
    [10] = true, -- Industrial
    [11] = true, -- Utility
    [12] = true, -- Vans
    [13] = false, -- Cycles
    [14] = true, -- Boats
    [15] = true, -- Helicopters
    [16] = true, -- Planes
    [17] = true, -- Service
    [18] = true, -- Emergency
    [19] = true  -- Military
}

-- Parts that can be repaired
Config.RepairableItems = {
    ["body"] = {
        label = "Body",
        requiredItems = {
            ["metalscrap"] = 4,
            ["steel"] = 2,
            ["plastic"] = 2
        }
    },
    ["engine"] = {
        label = "Engine",
        requiredItems = {
            ["metalscrap"] = 5,
            ["steel"] = 3,
            ["aluminum"] = 2
        }
    },
    ["radiator"] = {
        label = "Radiator",
        requiredItems = {
            ["metalscrap"] = 3,
            ["steel"] = 2,
            ["copper"] = 2
        }
    },
    ["drive_shaft"] = {
        label = "Drive Shaft",
        requiredItems = {
            ["metalscrap"] = 4,
            ["steel"] = 3,
            ["aluminum"] = 1
        }
    },
    ["brakes"] = {
        label = "Brakes",
        requiredItems = {
            ["metalscrap"] = 3,
            ["steel"] = 2,
            ["copper"] = 1
        }
    },
    ["clutch"] = {
        label = "Clutch",
        requiredItems = {
            ["metalscrap"] = 3,
            ["steel"] = 2,
            ["aluminum"] = 1
        }
    },
    ["fuel_injector"] = {
        label = "Fuel Injector",
        requiredItems = {
            ["metalscrap"] = 2,
            ["steel"] = 1,
            ["plastic"] = 2
        }
    }
}
