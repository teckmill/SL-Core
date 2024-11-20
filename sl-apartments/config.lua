Config = {}

-- Apartment Settings
Config.MinimumRent = 500
Config.MaximumRent = 5000
Config.DefaultInterior = 'apartment1'

-- Apartment Locations
Config.Locations = {
    ["alta"] = {
        name = "Alta Street Apartments",
        label = "Alta Street",
        coords = vector4(-271.68, -957.62, 31.22, 112.27),
        interiors = {
            ["apartment1"] = {
                label = "Modern Apartment",
                price = 1500,
                coords = vector4(-273.25, -940.63, 92.51, 166.15)
            },
            ["apartment2"] = {
                label = "Luxury Suite",
                price = 2500,
                coords = vector4(-273.25, -940.63, 92.51, 166.15)
            }
        }
    },
    ["integrity"] = {
        name = "Integrity Way",
        label = "Integrity Way",
        coords = vector4(269.73, -640.75, 42.02, 249.07),
        interiors = {
            ["apartment1"] = {
                label = "Standard Suite",
                price = 1250,
                coords = vector4(269.73, -640.75, 42.02, 249.07)
            }
        }
    },
    ["tinsel"] = {
        name = "Tinsel Towers",
        label = "Tinsel Towers",
        coords = vector4(-619.29, 37.69, 43.59, 181.03),
        interiors = {
            ["apartment1"] = {
                label = "Modern Suite",
                price = 1750,
                coords = vector4(-619.29, 37.69, 43.59, 181.03)
            }
        }
    }
}

-- Storage Settings
Config.StorageSize = {
    ["apartment1"] = 100, -- Inventory slots for standard apartments
    ["apartment2"] = 200  -- Inventory slots for luxury apartments
}

-- Interior Settings
Config.Interiors = {
    ["apartment1"] = {
        shell = "shell_v16mid", -- IPL/MLO name
        furniture = {
            {prop = "v_49_motelmp_stuff", pos = vector3(0.0, 0.0, 0.0)},
            {prop = "v_49_motelmp_bed", pos = vector3(1.0, 0.0, 0.0)},
            {prop = "v_49_motelmp_clothes", pos = vector3(2.0, 0.0, 0.0)}
        }
    },
    ["apartment2"] = {
        shell = "shell_highend",
        furniture = {
            {prop = "apa_mp_h_stn_chairarm_01", pos = vector3(0.0, 0.0, 0.0)},
            {prop = "apa_mp_h_bed_double_08", pos = vector3(1.0, 0.0, 0.0)},
            {prop = "apa_mp_h_str_shelffloorm_02", pos = vector3(2.0, 0.0, 0.0)}
        }
    }
}

-- Utility Functions
Config.DrawDistance = 10.0
Config.MarkerType = 1
Config.MarkerSize = vector3(1.5, 1.5, 1.0)
Config.MarkerColor = {r = 50, g = 50, b = 204, a = 100}

return Config
