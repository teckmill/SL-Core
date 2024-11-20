Config = {}

Config.Objects = {
    ["cone"] = {model = `prop_roadcone02a`, freeze = false},
    ["barrier"] = {model = `prop_barrier_work06a`, freeze = true},
    ["spike"] = {model = `p_ld_stinger_s`, freeze = true},
    ["tent"] = {model = `prop_gazebo_02`, freeze = true},
    ["light"] = {model = `prop_worklight_03b`, freeze = true},
}

Config.MaxSpikes = 5

Config.HandcuffTypes = {
    ["default"] = {item = "handcuffs", breakoutTime = 45, canBreakout = true},
    ["zipties"] = {item = "zipties", breakoutTime = 25, canBreakout = true},
    ["rope"] = {item = "rope", breakoutTime = 35, canBreakout = true},
}

Config.Evidence = {
    ["blood"] = {label = "Blood Sample", expire = 7},
    ["casing"] = {label = "Bullet Casing", expire = 7},
    ["fingerprint"] = {label = "Fingerprint", expire = 7},
    ["dna"] = {label = "DNA Sample", expire = 7},
}

Config.Locations = {
    ["duty"] = {
        [1] = vector4(440.085, -975.93, 30.689, 90.654),
    },
    ["evidence"] = {
        [1] = vector4(485.51, -988.72, 30.69, 175.97),
    },
    ["armory"] = {
        [1] = vector4(482.04, -995.45, 30.69, 90.654),
    },
    ["trash"] = {
        [1] = vector4(439.0907, -976.746, 30.776, 93.03),
    },
    ["fingerprint"] = {
        [1] = vector4(473.19, -1007.45, 26.27, 358.5),
    },
}

Config.Items = {
    label = "Police Armory",
    slots = 30,
    items = {
        [1] = {
            name = "weapon_pistol",
            price = 0,
            amount = 1,
            info = {},
            type = "weapon",
            slot = 1,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        },
        [2] = {
            name = "weapon_stungun",
            price = 0,
            amount = 1,
            info = {},
            type = "weapon",
            slot = 2,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        },
    }
}

Config.VehicleSettings = {
    ["car1"] = {
        ["extras"] = {
            ["1"] = true,
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
    }
} 