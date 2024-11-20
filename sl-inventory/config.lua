Config = {}

-- General Settings
Config.Debug = false
Config.MaxWeight = 120000 -- Maximum weight a player can carry (in grams)
Config.MaxSlots = 41 -- Maximum inventory slots (1-41)
Config.HotbarSlots = 5 -- Number of hotbar slots (1-5)

-- Inventory Types and Their Settings
Config.InventoryTypes = {
    player = {
        maxWeight = Config.MaxWeight,
        maxSlots = Config.MaxSlots
    },
    trunk = {
        maxWeight = 100000,
        maxSlots = 25
    },
    glovebox = {
        maxWeight = 10000,
        maxSlots = 5
    },
    shop = {
        maxWeight = 0,
        maxSlots = 0
    },
    drop = {
        maxWeight = 100000,
        maxSlots = 20
    },
    crafting = {
        maxWeight = 0,
        maxSlots = 0
    }
}

-- Item Categories
Config.ItemCategories = {
    ['weapons'] = {
        label = 'Weapons',
        slots = {1, 2, 3, 4, 5} -- Preferred slots for this category
    },
    ['ammo'] = {
        label = 'Ammunition',
        slots = {6, 7, 8, 9, 10}
    },
    ['food'] = {
        label = 'Food',
        slots = {11, 12, 13, 14, 15}
    },
    ['drinks'] = {
        label = 'Drinks',
        slots = {16, 17, 18, 19, 20}
    },
    ['medical'] = {
        label = 'Medical',
        slots = {21, 22, 23, 24, 25}
    }
}

-- Crafting Recipes
Config.Recipes = {
    ['bandage'] = {
        label = 'Craft Bandage',
        items = {
            ['cloth'] = 2,
            ['alcohol'] = 1
        },
        time = 5000,
        skill = 'medical',
        skillRequired = 0
    }
}

-- Shops Configuration
Config.Shops = {
    ['general'] = {
        label = '24/7 Shop',
        coords = {
            vector3(25.7, -1347.3, 29.49),
            vector3(-3038.71, 585.9, 7.9)
        },
        items = {
            ['bread'] = {
                price = 5,
                currency = 'money'
            },
            ['water'] = {
                price = 3,
                currency = 'money'
            }
        }
    },
    ['ammunition'] = {
        label = 'Ammu-Nation',
        coords = {
            vector3(-662.1, -935.3, 21.8)
        },
        items = {
            ['ammo-9'] = {
                price = 5,
                currency = 'money',
                license = 'weapon'
            }
        }
    }
}

-- Drop Settings
Config.Drops = {
    defaultDespawnTime = 600, -- 10 minutes
    maxDrops = 50, -- Maximum number of drops in the world
    showDistance = 10.0, -- Distance to show drop markers
    marker = {
        type = 2,
        scale = vector3(0.3, 0.3, 0.3),
        color = vector3(0, 255, 0),
        bob = true,
        rotate = true
    }
}

-- Hotbar Settings
Config.Hotbar = {
    enabled = true,
    showKeys = true,
    keys = {
        [1] = 157, -- 1
        [2] = 158, -- 2
        [3] = 160, -- 3
        [4] = 164, -- 4
        [5] = 165  -- 5
    }
}

-- UI Settings
Config.UI = {
    blur = true,
    closeKeys = {177, 322}, -- BACKSPACE, ESC
    sounds = true,
    showWeight = true,
    showItemInfo = true,
    themes = {
        default = {
            primary = '#3498db',
            secondary = '#2ecc71',
            background = '#2c3e50',
            text = '#ffffff'
        },
        dark = {
            primary = '#34495e',
            secondary = '#2c3e50',
            background = '#1a1a1a',
            text = '#ecf0f1'
        }
    }
}

-- Item Use Animations
Config.UseAnimations = {
    ['food'] = {
        dict = 'mp_player_inteat@burger',
        anim = 'mp_player_int_eat_burger',
        time = 3000
    },
    ['drink'] = {
        dict = 'mp_player_intdrink',
        anim = 'loop_bottle',
        time = 3000
    }
}

-- Restricted Areas (where inventory cannot be opened)
Config.RestrictedAreas = {
    vector3(0, 0, 0), -- Example coordinates
}

-- Default Item Images
Config.DefaultItemImage = 'nui://sl-inventory/html/assets/default.png'

-- Item Durability
Config.Durability = {
    enabled = true,
    decayRate = {
        ['weapon'] = 0.1, -- Decay per use
        ['food'] = 0.0, -- No decay
        ['drink'] = 0.0 -- No decay
    }
}

-- Inventory Saving
Config.SaveInterval = 5 * 60 * 1000 -- Save every 5 minutes
