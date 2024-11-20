Config = {}

-- General Settings
Config.MinimalDoctors = 2                        -- Minimum doctors needed for hospital to be "fully staffed"
Config.WipeInventoryOnRespawn = true            -- Should inventory be wiped on death
Config.RemoveWeaponsOnRespawn = true            -- Should weapons be removed on death
Config.RemoveCashOnRespawn = false              -- Should cash be removed on death
Config.ReviveReward = 500                       -- Reward for reviving a player
Config.MinimumHealth = 5                        -- Minimum health when damaged
Config.WaitingTime = 300                        -- Time to wait before respawning (seconds)
Config.PainkillerInterval = 60                  -- Time between painkiller effects (seconds)
Config.HealthDamage = 5                         -- Damage done when health is < 50%
Config.ArmorDamage = 5                          -- Damage done to armor when armor is present
Config.ForceDown = true                         -- Force player to enter downed state when health is < MinimumHealth
Config.DownTimer = 300                          -- Time player stays down before being able to respawn (seconds)
Config.BleedoutTimer = 600                      -- Time player has before bleeding out (seconds)
Config.EnableSounds = true                      -- Enable sounds when injured
Config.NotifyOnDeath = true                     -- Notify admins when a player dies
Config.AllowNearbyRespawn = true               -- Allow respawning at nearest hospital
Config.RespawnCommand = 'respawn'               -- Command to force respawn
Config.EarlyRespawnPermission = 'admin'         -- Permission needed for early respawn
Config.EarlyRespawnTimer = 60                   -- Time before early respawn is allowed (seconds)
Config.ReviveDistance = 1.5                     -- Distance for revive checks
Config.AutoRespawn = false                      -- Should players auto-respawn when down
Config.AutoRespawnTimer = 600                   -- Time before auto-respawn (seconds)

Config.Hospitals = {
    ["pillbox"] = {
        label = "Pillbox Hospital",
        type = "main",
        coords = vector4(304.27, -600.33, 43.28, 70.0),
        blip = {
            coords = vector3(304.27, -600.33, 43.28),
            sprite = 61,
            color = 2,
            scale = 0.8,
            display = 4,
            shortRange = true
        },
        beds = {
            {coords = vector4(309.55, -577.34, 43.84, 340.0), taken = false, model = 1631638868},
            {coords = vector4(311.06, -582.96, 43.84, 340.0), taken = false, model = 1631638868},
            {coords = vector4(314.91, -584.37, 43.84, 340.0), taken = false, model = 1631638868},
            {coords = vector4(317.71, -585.33, 43.84, 340.0), taken = false, model = 1631638868},
            {coords = vector4(319.41, -581.04, 43.84, 340.0), taken = false, model = 1631638868},
            {coords = vector4(313.93, -579.39, 43.84, 340.0), taken = false, model = 1631638868}
        },
        stations = {
            ["duty"] = {
                [1] = vector4(307.46, -595.32, 43.28, 70.0),
                [2] = vector4(335.46, -594.52, 43.28, 70.0)
            },
            ["armory"] = {
                [1] = vector4(306.89, -601.82, 43.28, 70.0)
            },
            ["pharmacy"] = {
                [1] = vector4(309.84, -568.99, 43.28, 70.0)
            },
            ["chief"] = {
                [1] = vector4(334.29, -593.84, 43.28, 70.0)
            },
            ["vehicle"] = {
                [1] = vector4(294.578, -574.761, 43.179, 35.79),
                [2] = vector4(297.461, -579.811, 43.179, 35.79),
                [3] = vector4(285.178, -599.661, 43.179, 35.79)
            },
            ["helicopter"] = {
                [1] = vector4(351.58, -587.45, 74.16, 160.5)
            }
        }
    },
    ["paleto"] = {
        label = "Paleto Bay Medical Center",
        type = "clinic",
        coords = vector4(-252.43, 6335.57, 32.42, 223.5),
        blip = {
            coords = vector3(-252.43, 6335.57, 32.42),
            sprite = 61,
            color = 2,
            scale = 0.8,
            display = 4,
            shortRange = true
        },
        beds = {
            {coords = vector4(-252.43, 6335.57, 32.42, 223.5), taken = false, model = 1631638868},
            {coords = vector4(-247.04, 6317.95, 32.42, 223.5), taken = false, model = 1631638868}
        },
        stations = {
            ["duty"] = {
                [1] = vector4(-243.28, 6324.56, 32.42, 223.5)
            },
            ["armory"] = {
                [1] = vector4(-245.13, 6315.71, 32.42, 223.5)
            },
            ["pharmacy"] = {
                [1] = vector4(-253.76, 6338.9, 32.42, 223.5)
            },
            ["vehicle"] = {
                [1] = vector4(-234.28, 6329.16, 32.15, 223.5)
            }
        }
    }
}

Config.Vehicles = {
    ["ambulance"] = "Ambulance",
    ["doctor"] = "Doctor's Vehicle",
    ["emscar"] = "EMS Cruiser",
    ["wheelchair"] = "Wheelchair"
}

Config.Helicopter = "polmav"

Config.Items = {
    label = "EMS Armory",
    slots = 30,
    items = {
        [1] = {
            name = "radio",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 1,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        },
        [2] = {
            name = "bandage",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 2,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        },
        [3] = {
            name = "medkit",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 3,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        },
        [4] = {
            name = "painkillers",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 4,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        },
        [5] = {
            name = "firstaid",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 5,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        },
        [6] = {
            name = "wheelchair",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 6,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        }
    }
}

Config.WeaponClasses = {                        -- Define which weapons cause what type of damage
    ['SMALL_CALIBER'] = 1,                     -- Small caliber weapon damage
    ['MEDIUM_CALIBER'] = 2,                    -- Medium caliber weapon damage
    ['HIGH_CALIBER'] = 3,                      -- High caliber weapon damage
    ['SHOTGUN'] = 3,                           -- Shotgun damage
    ['CUTTING'] = 1,                           -- Cutting weapon damage
    ['LIGHT_IMPACT'] = 1,                      -- Light impact damage
    ['HEAVY_IMPACT'] = 2,                      -- Heavy impact damage
    ['EXPLOSIVE'] = 3,                         -- Explosive damage
    ['FIRE'] = 2,                              -- Fire damage
    ['SUFFOCATING'] = 1,                       -- Suffocating damage
    ['OTHER'] = 1,                             -- Other damage
    ['WILDLIFE'] = 1,                          -- Wildlife damage
    ['NOTHING'] = 0                            -- No damage
}

Config.WoundStates = {
    'pain',
    'irritated',
    'painful',
    'really painful',
    'extremely painful'
}

Config.BleedingStates = {
    'scratched',
    'cut',
    'lightly bleeding',
    'bleeding',
    'heavily bleeding'
}

Config.MovementRate = {                         -- Set movement rate for limb damage
    0.98,
    0.96,
    0.94,
    0.92,
}

Config.Bones = {                                -- Correspond bone hash numbers to their label
    [11816] = 'Pelvis',
    [58271] = 'Femur L',
    [63931] = 'Femur R',
    [14201] = 'Tibia L',
    [52301] = 'Tibia R',
    [18905] = 'Foot L',
    [57717] = 'Foot R',
    [24816] = 'Spine',
    [24817] = 'Spine',
    [24818] = 'Spine',
    [64729] = 'Clavicle L',
    [10706] = 'Clavicle R',
    [45509] = 'Humerus L',
    [40269] = 'Humerus R',
    [28252] = 'Hand L',
    [57005] = 'Hand R',
    [31086] = 'Head'
}

Config.BoneIndexes = {                          -- Correspond bone labels to their hash number
    ['SPINE'] = 24816,
    ['UPPER_BODY'] = 10706,
    ['LOWER_BODY'] = 11816,
    ['HEAD'] = 31086,
    ['LEFT_ARM'] = 45509,
    ['RIGHT_ARM'] = 40269,
    ['LEFT_LEG'] = 58271,
    ['RIGHT_LEG'] = 63931,
    ['LEFT_HAND'] = 28252,
    ['RIGHT_HAND'] = 57005,
    ['LEFT_FOOT'] = 18905,
    ['RIGHT_FOOT'] = 57717
}

Config.Weapons = {                              -- Correspond weapon names to their class
    [`WEAPON_STUNGUN`] = Config.WeaponClasses['NONE'],
    [`WEAPON_STUNGUN_MP`] = Config.WeaponClasses['NONE'],
    
    [`WEAPON_PISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_PISTOL_MK2`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_COMBATPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    
    [`WEAPON_CARBINERIFLE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_CARBINERIFLE_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_ASSAULTRIFLE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    
    [`WEAPON_PUMPSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_PUMPSHOTGUN_MK2`] = Config.WeaponClasses['SHOTGUN'],
    
    [`WEAPON_KNIFE`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_BOTTLE`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_SWITCHBLADE`] = Config.WeaponClasses['CUTTING'],
    
    [`WEAPON_NIGHTSTICK`] = Config.WeaponClasses['LIGHT_IMPACT'],
    
    [`WEAPON_GRENADE`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_STICKYBOMB`] = Config.WeaponClasses['EXPLOSIVE']
}

Config.VehicleSettings = {
    ["ambulance"] = {                          -- Vehicle model name
        ["extras"] = {
            ["1"] = true,                      -- Enable/disable specific vehicle extras
            ["2"] = true,
            ["3"] = true,
            ["4"] = true,
            ["5"] = true,
            ["6"] = true,
            ["7"] = true,
            ["8"] = true,
            ["9"] = true,
            ["10"] = true,
            ["11"] = true,
            ["12"] = true,
        }
    },
    ["doctor"] = {
        ["extras"] = {
            ["1"] = true,
            ["2"] = true,
            ["3"] = true,
            ["4"] = true,
            ["5"] = true,
        }
    }
}

Config.AuthorizedVehicles = {                   -- Grade-based vehicle permissions
	[0] = {
		["ambulance"] = "Ambulance",
	},
	[1] = {
		["ambulance"] = "Ambulance",
		["doctor"] = "Doctor's Vehicle"
	},
	[2] = {
		["ambulance"] = "Ambulance",
		["doctor"] = "Doctor's Vehicle",
		["emscar"] = "EMS Cruiser"
	}
}