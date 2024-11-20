Config = {}

-- General Settings
Config.Debug = false -- Enable debug mode for development
Config.DefaultDistance = 2.5 -- Default interaction distance
Config.MaxDistance = 10.0 -- Maximum distance for any interaction

-- Key Bindings
Config.OpenKey = 'LMENU' -- Left Alt key by default
Config.DisableInVehicle = true -- Disable targeting while in vehicle

-- Visual Settings
Config.EnableDefaultEye = true -- Show the eye icon when targeting
Config.ColorByDistance = true -- Change color based on distance
Config.Colors = {
    Available = {r = 0, g = 255, b = 0, a = 255}, -- Green when in range
    OutOfRange = {r = 255, g = 0, b = 0, a = 255}, -- Red when out of range
    PartiallyAvailable = {r = 255, g = 255, b = 0, a = 255} -- Yellow when some options are available
}

-- Performance Settings
Config.UpdateFrequency = 200 -- How often (in ms) to update targets
Config.MaxEntitiesPerFrame = 50 -- Maximum number of entities to check per frame
Config.DisableTargetingDuringPause = true -- Disable targeting when game is paused

-- Default Bone Options
Config.DefaultBones = {
    Vehicle = {
        'door_dside_f',
        'door_dside_r',
        'door_pside_f',
        'door_pside_r',
        'boot'
    },
    Ped = {
        'IK_Head',
        'SKEL_Spine2'
    }
}

-- Blacklisted Entities
Config.BlacklistedEntities = {
    -- Add entity hashes or names that should never be targetable
}

-- Default Target Groups
Config.DefaultTargets = {
    -- ATMs
    ["atm"] = {
        models = {
            'prop_atm_01',
            'prop_atm_02',
            'prop_atm_03',
            'prop_fleeca_atm'
        },
        options = {
            {
                type = "client",
                event = "sl-banking:client:openATM",
                icon = "fas fa-credit-card",
                label = "Use ATM"
            }
        },
        distance = 1.5
    },
    
    -- Garbage Bins
    ["garbage"] = {
        models = {
            'prop_dumpster_01a',
            'prop_dumpster_02a',
            'prop_dumpster_02b',
            'prop_dumpster_3a',
            'prop_dumpster_4a',
            'prop_dumpster_4b'
        },
        options = {
            {
                type = "client",
                event = "sl-garbage:client:searchBin",
                icon = "fas fa-dumpster",
                label = "Search Garbage"
            }
        },
        distance = 1.5
    }
}

-- Zones Configuration
Config.Zones = {
    -- Example zone
    ["police_duty"] = {
        name = "police_duty",
        coords = vector3(441.7989, -982.0529, 30.67834),
        length = 1.0,
        width = 1.0,
        heading = 11.0,
        debugPoly = false,
        minZ = 29.67834,
        maxZ = 31.67834,
        options = {
            {
                type = "client",
                event = "sl-policejob:client:toggleDuty",
                icon = "fas fa-sign-in-alt",
                label = "Toggle Duty",
                job = "police"
            }
        }
    }
}
