Config = {}

Config.CraftingLocations = {
    ['mechanic'] = {
        label = 'Mechanic Workshop',
        coords = vector3(-323.5, -129.84, 39.01),
        radius = 3.0,
        job = 'mechanic',
        blip = {
            sprite = 566,
            color = 5,
            scale = 0.7
        }
    },
    ['blacksmith'] = {
        label = 'Blacksmith',
        coords = vector3(1108.45, -2007.2, 30.95),
        radius = 3.0,
        job = nil,
        blip = {
            sprite = 566,
            color = 21,
            scale = 0.7
        }
    }
}

Config.Recipes = {
    ['mechanic'] = {
        ['repairkit'] = {
            label = 'Repair Kit',
            time = 15000,
            ingredients = {
                ['metalscrap'] = 5,
                ['rubber'] = 3,
                ['electronics'] = 2
            }
        },
        ['lockpick'] = {
            label = 'Lockpick',
            time = 10000,
            ingredients = {
                ['metalscrap'] = 3,
                ['plastic'] = 2
            }
        },
        ['advancedrepairkit'] = {
            label = 'Advanced Repair Kit',
            time = 25000,
            ingredients = {
                ['metalscrap'] = 8,
                ['rubber'] = 5,
                ['electronics'] = 4,
                ['plastic'] = 3
            }
        }
    },
    ['blacksmith'] = {
        ['weapon_dagger'] = {
            label = 'Dagger',
            time = 30000,
            ingredients = {
                ['steel'] = 10,
                ['leather'] = 2
            }
        },
        ['armor'] = {
            label = 'Body Armor',
            time = 45000,
            ingredients = {
                ['steel'] = 15,
                ['leather'] = 5,
                ['fabric'] = 3
            }
        }
    }
}

Config.RequiredItems = {
    ['mechanic'] = {
        ['hammer'] = 1,
        ['screwdriver'] = 1
    },
    ['blacksmith'] = {
        ['hammer'] = 1,
        ['anvil'] = 1
    }
}

Config.CraftingTime = {
    min = 5000,  -- Minimum crafting time in ms
    max = 60000  -- Maximum crafting time in ms
}

Config.SkillCheck = {
    enabled = true,
    difficulty = {
        easy = 'easy',
        medium = 'medium',
        hard = 'hard'
    }
}

Config.Experience = {
    enabled = true,
    gainPerCraft = 5,
    levels = {
        [0] = {
            label = 'Novice',
            failChance = 0.4
        },
        [50] = {
            label = 'Apprentice',
            failChance = 0.3
        },
        [150] = {
            label = 'Journeyman',
            failChance = 0.2
        },
        [300] = {
            label = 'Expert',
            failChance = 0.1
        },
        [600] = {
            label = 'Master',
            failChance = 0.05
        }
    }
}

Config.Animations = {
    dict = 'mini@repair',
    anim = 'fixing_a_ped'
}
