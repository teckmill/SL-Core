Config = {}

Config.Hospitals = {
    ["pillbox"] = {
        label = "Pillbox Hospital",
        blip = {
            coords = vector3(304.27, -600.33, 43.28),
            sprite = 61,
            color = 2,
            scale = 0.8
        },
        beds = {
            {coords = vector4(309.55, -577.34, 43.84, 340.0), taken = false},
            {coords = vector4(311.06, -582.96, 43.84, 340.0), taken = false},
            {coords = vector4(314.91, -584.37, 43.84, 340.0), taken = false},
            {coords = vector4(317.71, -585.33, 43.84, 340.0), taken = false}
        },
        stations = {
            ["duty"] = vector4(307.46, -595.32, 43.28, 70.0),
            ["armory"] = vector4(306.89, -601.82, 43.28, 70.0),
            ["pharmacy"] = vector4(309.84, -568.99, 43.28, 70.0)
        }
    }
}

Config.WoundTypes = {
    ["bruise"] = {
        label = "Bruise",
        time = 60, -- seconds to heal
        item = "bandage",
        anim = "mini_games@story@mud5@tend_wounds@base"
    },
    ["cut"] = {
        label = "Cut",
        time = 120,
        item = "bandage",
        anim = "mini_games@story@mud5@tend_wounds@base"
    },
    ["bullet"] = {
        label = "Bullet Wound",
        time = 300,
        item = "medkit",
        anim = "mini_games@story@mud5@tend_wounds@base"
    }
}

Config.Items = {
    label = "EMS Armory",
    slots = 30,
    items = {
        [1] = {
            name = "bandage",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 1,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        },
        [2] = {
            name = "medkit",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 2,
            authorizedJobGrades = {0, 1, 2, 3, 4}
        }
    }
}

Config.ReviveReward = 500
Config.MinimumHealth = 5
Config.WaitingTime = 300 -- seconds 