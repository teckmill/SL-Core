Config = {}

-- Garage Types
Config.GarageTypes = {
    public = {
        label = "Public Garage",
        spawnFee = 0,
        storageFee = 0,
        blipSprite = 357,
        blipColor = 3,
    },
    job = {
        label = "Job Garage",
        spawnFee = 0,
        storageFee = 0,
        blipSprite = 357,
        blipColor = 2,
    },
    impound = {
        label = "Impound Lot",
        spawnFee = 500,
        storageFee = 150,
        blipSprite = 477,
        blipColor = 1,
    }
}

-- Garage Locations
Config.Garages = {
    ['legion'] = {
        label = "Legion Square Garage",
        type = "public",
        zones = {
            parking = vector4(215.09, -810.11, 30.73, 339.77),
            spawn = vector4(231.96, -797.76, 30.54, 161.19),
            store = vector3(223.80, -760.42, 30.82)
        },
        size = {
            parking = vector3(10, 10, 4),
            spawn = vector3(3, 6, 4),
            store = vector3(3, 3, 4)
        },
        maxDistance = 10.0,
        allowedJobs = {}
    },
    ['pillbox'] = {
        label = "Pillbox Garage",
        type = "public",
        zones = {
            parking = vector4(215.95, -809.82, 30.73, 69.9),
            spawn = vector4(234.36, -787.66, 30.16, 159.16),
            store = vector3(246.30, -784.35, 30.51)
        },
        size = {
            parking = vector3(10, 10, 4),
            spawn = vector3(3, 6, 4),
            store = vector3(3, 3, 4)
        },
        maxDistance = 10.0,
        allowedJobs = {}
    }
}

-- Impound Lots
Config.ImpoundLots = {
    ['davis'] = {
        label = "Davis Impound",
        type = "impound",
        zones = {
            parking = vector4(369.12, -1607.71, 29.29, 230.39),
            spawn = vector4(364.72, -1599.64, 29.29, 320.56),
            store = vector3(368.12, -1618.71, 29.29)
        },
        size = {
            parking = vector3(10, 10, 4),
            spawn = vector3(3, 6, 4),
            store = vector3(3, 3, 4)
        },
        maxDistance = 10.0,
        allowedJobs = {'police', 'mechanic'}
    }
}

-- UI Settings
Config.UI = {
    menu = {
        position = "right",
        size = "small"
    },
    markers = {
        type = 36,
        size = vector3(1.0, 1.0, 1.0),
        color = {r = 0, g = 150, b = 150, a = 155}
    }
}

-- General Settings
Config.UseTarget = true -- Use qb-target/ox_target instead of markers
Config.SpawnDistance = 3.0 -- Distance to spawn point check
Config.StoreDistance = 3.0 -- Distance to store point check
Config.DrawTextDistance = 2.0 -- Distance to show floating text
Config.VehicleSpawnTimeout = 5000 -- Time in ms before vehicle spawn times out 