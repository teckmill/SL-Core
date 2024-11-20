Config = {}

-- General Settings
Config.Debug = false
Config.DefaultLanguage = 'en'
Config.UseTarget = true -- Use qb-target for interactions
Config.MaxProperties = 2 -- Maximum properties a player can own
Config.RentInterval = 24 -- Hours between rent payments
Config.FurnitureLimit = 150 -- Maximum furniture items per property
Config.SaveInterval = 10 -- Minutes between automatic property state saves

-- Currency Settings
Config.Currency = '$'
Config.BankAccount = 'bank' -- Account to use for transactions
Config.TaxRate = 0.08 -- 8% property tax
Config.UtilityRate = 0.05 -- 5% utility cost based on property value

-- Property Access
Config.KeySystem = {
    UseKeys = true, -- Require physical keys for access
    DuplicateCost = 100, -- Cost to duplicate keys
    MaxKeys = 5 -- Maximum keys per property
}

-- Interaction Distances
Config.Distances = {
    Doorbell = 2.0,
    Door = 2.0,
    Storage = 2.0,
    Wardrobe = 2.0,
    Furniture = 2.0
}

-- Property Types
Config.PropertyTypes = {
    apartment = {
        label = 'Apartment',
        maxStorage = 500, -- Weight limit for storage
        maxWardrobe = 50, -- Slots in wardrobe
        allowedFurniture = true,
        allowPets = true,
        shells = {'apartment1', 'apartment2', 'apartment3'}
    },
    house = {
        label = 'House',
        maxStorage = 1000,
        maxWardrobe = 100,
        allowedFurniture = true,
        allowPets = true,
        shells = {'house1', 'house2', 'house3'}
    },
    mansion = {
        label = 'Mansion',
        maxStorage = 2000,
        maxWardrobe = 200,
        allowedFurniture = true,
        allowPets = true,
        shells = {'mansion1', 'mansion2'}
    },
    office = {
        label = 'Office',
        maxStorage = 300,
        maxWardrobe = 20,
        allowedFurniture = true,
        allowPets = false,
        shells = {'office1', 'office2'}
    }
}

-- Available Shells
Config.Shells = {
    apartment1 = {
        model = `shell_apartment1`,
        offset = vector3(0.0, 0.0, 0.0),
        price = 50000
    },
    apartment2 = {
        model = `shell_apartment2`,
        offset = vector3(0.0, 0.0, 0.0),
        price = 75000
    },
    apartment3 = {
        model = `shell_apartment3`,
        offset = vector3(0.0, 0.0, 0.0),
        price = 100000
    },
    house1 = {
        model = `shell_house1`,
        offset = vector3(0.0, 0.0, 0.0),
        price = 150000
    },
    house2 = {
        model = `shell_house2`,
        offset = vector3(0.0, 0.0, 0.0),
        price = 200000
    },
    house3 = {
        model = `shell_house3`,
        offset = vector3(0.0, 0.0, 0.0),
        price = 250000
    },
    mansion1 = {
        model = `shell_mansion1`,
        offset = vector3(0.0, 0.0, 0.0),
        price = 500000
    },
    mansion2 = {
        model = `shell_mansion2`,
        offset = vector3(0.0, 0.0, 0.0),
        price = 750000
    },
    office1 = {
        model = `shell_office1`,
        offset = vector3(0.0, 0.0, 0.0),
        price = 100000
    },
    office2 = {
        model = `shell_office2`,
        offset = vector3(0.0, 0.0, 0.0),
        price = 150000
    }
}

-- Furniture Categories
Config.FurnitureCategories = {
    living = {
        label = 'Living Room',
        icon = 'fas fa-couch'
    },
    bedroom = {
        label = 'Bedroom',
        icon = 'fas fa-bed'
    },
    kitchen = {
        label = 'Kitchen',
        icon = 'fas fa-kitchen-set'
    },
    bathroom = {
        label = 'Bathroom',
        icon = 'fas fa-bath'
    },
    office = {
        label = 'Office',
        icon = 'fas fa-desk'
    },
    decoration = {
        label = 'Decoration',
        icon = 'fas fa-image'
    },
    storage = {
        label = 'Storage',
        icon = 'fas fa-box'
    },
    lighting = {
        label = 'Lighting',
        icon = 'fas fa-lightbulb'
    }
}

-- Available Furniture
Config.Furniture = {
    -- Living Room
    sofa = {
        label = 'Sofa',
        model = `v_res_mp_sofa`,
        price = 1000,
        category = 'living',
        offset = vector3(0.0, 0.0, 0.0),
        rotation = vector3(0.0, 0.0, 0.0)
    },
    tv = {
        label = 'Television',
        model = `prop_tv_flat_01`,
        price = 2000,
        category = 'living',
        offset = vector3(0.0, 0.0, 1.0),
        rotation = vector3(0.0, 0.0, 0.0),
        isElectric = true
    },

    -- Bedroom
    bed = {
        label = 'Bed',
        model = `v_res_msonbed`,
        price = 1500,
        category = 'bedroom',
        offset = vector3(0.0, 0.0, 0.0),
        rotation = vector3(0.0, 0.0, 0.0)
    },
    wardrobe = {
        label = 'Wardrobe',
        model = `v_res_mcupboard`,
        price = 800,
        category = 'bedroom',
        offset = vector3(0.0, 0.0, 0.0),
        rotation = vector3(0.0, 0.0, 0.0),
        isStorage = true
    },

    -- Kitchen
    fridge = {
        label = 'Refrigerator',
        model = `v_res_fridgemodsml`,
        price = 2500,
        category = 'kitchen',
        offset = vector3(0.0, 0.0, 0.0),
        rotation = vector3(0.0, 0.0, 0.0),
        isStorage = true,
        isElectric = true
    },
    stove = {
        label = 'Stove',
        model = `prop_cooker_03`,
        price = 1800,
        category = 'kitchen',
        offset = vector3(0.0, 0.0, 0.0),
        rotation = vector3(0.0, 0.0, 0.0),
        isElectric = true
    }
}

-- Property Locations
Config.Properties = {
    -- Eclipse Towers
    ['eclipse_1'] = {
        label = 'Eclipse Towers Apt 1',
        type = 'apartment',
        shell = 'apartment1',
        entrance = vector4(-773.9, 312.12, 85.7, 0.0),
        price = 80000,
        isMLO = false
    },
    ['eclipse_2'] = {
        label = 'Eclipse Towers Apt 2',
        type = 'apartment',
        shell = 'apartment2',
        entrance = vector4(-775.9, 312.12, 85.7, 0.0),
        price = 100000,
        isMLO = false
    },

    -- Vinewood Hills
    ['vinewood_1'] = {
        label = 'Vinewood Hills Mansion 1',
        type = 'mansion',
        shell = 'mansion1',
        entrance = vector4(-784.9, 312.12, 85.7, 0.0),
        price = 1000000,
        isMLO = false
    }
}

-- Blip Settings
Config.Blips = {
    forSale = {
        sprite = 374,
        color = 2,
        scale = 0.6
    },
    owned = {
        sprite = 374,
        color = 3,
        scale = 0.6
    },
    rented = {
        sprite = 374,
        color = 4,
        scale = 0.6
    }
}

-- Commands
Config.Commands = {
    createProperty = 'createproperty', -- Admin command to create new properties
    deleteProperty = 'deleteproperty', -- Admin command to delete properties
    setPropertyPrice = 'setpropertyprice', -- Admin command to set property prices
    giveKeys = 'givekeys', -- Give keys to another player
    removeKeys = 'removekeys', -- Remove keys from a player
    lockProperty = 'lockproperty', -- Lock/unlock property
    furniture = 'furniture', -- Open furniture menu
    propertyList = 'properties' -- List owned properties
}

-- Default Property Settings
Config.DefaultSettings = {
    lockOnExit = true, -- Automatically lock property when exiting
    allowVisitors = true, -- Allow visitors to ring doorbell
    announceVisitors = true, -- Announce visitors in chat
    furnitureLimit = 150, -- Default furniture limit
    storageAccess = {}, -- Default storage access list
    wardrobeAccess = {} -- Default wardrobe access list
}

-- Utility Costs
Config.UtilityCosts = {
    electricity = {
        base = 50, -- Base cost per day
        perFurniture = 1 -- Additional cost per electric furniture item
    },
    water = {
        base = 30, -- Base cost per day
        perFurniture = 0.5 -- Additional cost per water-using furniture item
    }
}

-- Rental Settings
Config.Rental = {
    enabled = true,
    depositMultiplier = 2, -- Deposit is 2x the rent price
    maxRentPeriod = 30, -- Maximum days to rent
    minRentPeriod = 7, -- Minimum days to rent
    lateFee = 0.1 -- 10% late fee on missed payments
}

-- Door Lock Types
Config.DoorLockTypes = {
    key = {
        label = 'Key Lock',
        price = 0,
        lockpickDifficulty = 1
    },
    padlock = {
        label = 'Padlock',
        price = 100,
        lockpickDifficulty = 2
    },
    electronic = {
        label = 'Electronic Lock',
        price = 500,
        lockpickDifficulty = 3,
        requiresPower = true
    },
    biometric = {
        label = 'Biometric Lock',
        price = 1000,
        lockpickDifficulty = 4,
        requiresPower = true
    }
}

-- Security Systems
Config.SecuritySystems = {
    basic = {
        label = 'Basic Alarm',
        price = 1000,
        effectiveness = 0.6,
        police_response = true
    },
    advanced = {
        label = 'Advanced Alarm',
        price = 2500,
        effectiveness = 0.8,
        police_response = true,
        camera_access = true
    },
    premium = {
        label = 'Premium Security',
        price = 5000,
        effectiveness = 0.95,
        police_response = true,
        camera_access = true,
        motion_sensors = true
    }
}

return Config
