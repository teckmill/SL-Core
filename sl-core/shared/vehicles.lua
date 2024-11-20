SLShared = SLShared or {}

-- Vehicle Classes
SLShared.VehicleClasses = {
    [0] = 'Compacts',
    [1] = 'Sedans',
    [2] = 'SUVs',
    [3] = 'Coupes',
    [4] = 'Muscle',
    [5] = 'Sports Classics',
    [6] = 'Sports',
    [7] = 'Super',
    [8] = 'Motorcycles',
    [9] = 'Off-road',
    [10] = 'Industrial',
    [11] = 'Utility',
    [12] = 'Vans',
    [13] = 'Cycles',
    [14] = 'Boats',
    [15] = 'Helicopters',
    [16] = 'Planes',
    [17] = 'Service',
    [18] = 'Emergency',
    [19] = 'Military',
    [20] = 'Commercial',
    [21] = 'Trains',
}

-- Vehicle Fuel Usage Per Class
SLShared.FuelUsage = {
    [0] = 0.8, -- Compacts
    [1] = 1.0, -- Sedans
    [2] = 1.2, -- SUVs
    [3] = 1.0, -- Coupes
    [4] = 1.3, -- Muscle
    [5] = 1.2, -- Sports Classics
    [6] = 1.3, -- Sports
    [7] = 1.4, -- Super
    [8] = 0.6, -- Motorcycles
    [9] = 1.4, -- Off-road
    [10] = 1.5, -- Industrial
    [11] = 1.3, -- Utility
    [12] = 1.2, -- Vans
    [13] = 0.0, -- Cycles
    [14] = 1.0, -- Boats
    [15] = 1.5, -- Helicopters
    [16] = 1.8, -- Planes
    [17] = 1.1, -- Service
    [18] = 1.1, -- Emergency
    [19] = 1.6, -- Military
    [20] = 1.5, -- Commercial
    [21] = 0.0, -- Trains
}

-- Vehicle Shops
SLShared.VehicleShops = {
    ['pdm'] = {
        ['label'] = 'Premium Deluxe Motorsport',
        ['type'] = 'free-use',
        ['categories'] = {
            ['sedans'] = true,
            ['coupes'] = true,
            ['suvs'] = true,
            ['offroad'] = true,
            ['muscle'] = true,
            ['compacts'] = true,
            ['motorcycles'] = true,
            ['vans'] = true,
        },
        ['testDrive'] = {
            ['enabled'] = true,
            ['duration'] = 60, -- seconds
            ['price'] = 500,
        },
        ['location'] = vector4(-33.7, -1102.0, 26.4, 340.0),
        ['showroom'] = {
            [1] = vector4(-45.6, -1093.8, 26.4, 250.0),
            [2] = vector4(-48.6, -1101.8, 26.4, 250.0),
            [3] = vector4(-51.6, -1109.8, 26.4, 250.0),
        }
    },
    ['luxury'] = {
        ['label'] = 'Luxury Autos',
        ['type'] = 'managed',
        ['categories'] = {
            ['super'] = true,
            ['sports'] = true,
        },
        ['testDrive'] = {
            ['enabled'] = true,
            ['duration'] = 60,
            ['price'] = 2500,
        },
        ['location'] = vector4(-795.9, -220.5, 37.1, 131.0),
        ['showroom'] = {
            [1] = vector4(-789.9, -226.5, 37.1, 131.0),
            [2] = vector4(-787.9, -229.5, 37.1, 131.0),
            [3] = vector4(-785.9, -232.5, 37.1, 131.0),
        }
    },
    ['police'] = {
        ['label'] = 'Police Vehicle Shop',
        ['type'] = 'job',
        ['job'] = 'police',
        ['categories'] = {
            ['emergency'] = true,
        },
        ['testDrive'] = {
            ['enabled'] = false,
        },
        ['location'] = vector4(454.6, -1017.4, 28.4, 90.0),
    },
}

-- Vehicle Categories
SLShared.VehicleCategories = {
    ['super'] = 'Super Cars',
    ['sports'] = 'Sports Cars',
    ['sedans'] = 'Sedans',
    ['coupes'] = 'Coupes',
    ['suvs'] = 'SUVs',
    ['offroad'] = 'Off-Road',
    ['muscle'] = 'Muscle Cars',
    ['compacts'] = 'Compacts',
    ['motorcycles'] = 'Motorcycles',
    ['vans'] = 'Vans',
    ['emergency'] = 'Emergency Vehicles',
}

-- Vehicles
SLShared.Vehicles = {
    ['adder'] = {
        ['name'] = 'Adder',
        ['brand'] = 'Truffade',
        ['model'] = 'adder',
        ['price'] = 250000,
        ['category'] = 'super',
        ['hash'] = `adder`,
        ['shop'] = 'luxury',
        ['defaultFinancing'] = 20, -- Default financing percentage available
    },
    ['sultan'] = {
        ['name'] = 'Sultan',
        ['brand'] = 'Karin',
        ['model'] = 'sultan',
        ['price'] = 15000,
        ['category'] = 'sedans',
        ['hash'] = `sultan`,
        ['shop'] = 'pdm',
        ['defaultFinancing'] = 10,
    },
    ['police'] = {
        ['name'] = 'Police Cruiser',
        ['brand'] = 'Vapid',
        ['model'] = 'police',
        ['price'] = 0,
        ['category'] = 'emergency',
        ['hash'] = `police`,
        ['shop'] = 'police',
    },
    ['t20'] = {
        ['name'] = 'T20',
        ['brand'] = 'Progen',
        ['model'] = 't20',
        ['price'] = 300000,
        ['category'] = 'super',
        ['hash'] = `t20`,
        ['shop'] = 'luxury',
        ['defaultFinancing'] = 20,
    },
    ['zentorno'] = {
        ['name'] = 'Zentorno',
        ['brand'] = 'Pegassi',
        ['model'] = 'zentorno',
        ['price'] = 275000,
        ['category'] = 'super',
        ['hash'] = `zentorno`,
        ['shop'] = 'luxury',
        ['defaultFinancing'] = 20,
    },
    ['kuruma'] = {
        ['name'] = 'Kuruma',
        ['brand'] = 'Karin',
        ['model'] = 'kuruma',
        ['price'] = 30000,
        ['category'] = 'sports',
        ['hash'] = `kuruma`,
        ['shop'] = 'pdm',
        ['defaultFinancing'] = 10,
    },
    ['ambulance'] = {
        ['name'] = 'Ambulance',
        ['brand'] = 'Brute',
        ['model'] = 'ambulance',
        ['price'] = 0,
        ['category'] = 'emergency',
        ['hash'] = `ambulance`,
        ['shop'] = 'ambulance',
    },
}

-- Vehicle Mods
SLShared.VehicleMods = {
    ['colors'] = {
        ['metallic'] = {
            [0] = 'Metallic Black',
            [1] = 'Metallic Graphite Black',
            [2] = 'Metallic Black Steel',
            [3] = 'Metallic Dark Silver',
            [4] = 'Metallic Silver',
            [5] = 'Metallic Blue Silver',
            [6] = 'Metallic Steel Gray',
            [7] = 'Metallic Shadow Silver',
            [8] = 'Metallic Stone Silver',
            [9] = 'Metallic Midnight Silver',
            [10] = 'Metallic Gun Metal',
        },
        ['matte'] = {
            [0] = 'Matte Black',
            [1] = 'Matte Gray',
            [2] = 'Matte Light Gray',
            [3] = 'Matte Ice White',
            [4] = 'Matte Blue',
            [5] = 'Matte Dark Blue',
            [6] = 'Matte Midnight Blue',
            [7] = 'Matte Midnight Purple',
            [8] = 'Matte Red',
            [9] = 'Matte Dark Red',
            [10] = 'Matte Orange',
        },
    },
    ['prices'] = {
        ['cosmetics'] = {
            ['respray'] = 500,
            ['pearl'] = 750,
            ['wheels'] = 400,
            ['windowtint'] = 300,
            ['neons'] = 1000,
            ['xenons'] = 500,
            ['horn'] = 200,
            ['plate'] = 150,
        },
        ['performance'] = {
            ['engine'] = {
                [0] = 1500,
                [1] = 3000,
                [2] = 5500,
                [3] = 8000,
            },
            ['brakes'] = {
                [0] = 1000,
                [1] = 2000,
                [2] = 3500,
            },
            ['transmission'] = {
                [0] = 1500,
                [1] = 3000,
                [2] = 4500,
            },
            ['suspension'] = {
                [0] = 1000,
                [1] = 2000,
                [2] = 3500,
                [3] = 5000,
            },
            ['turbo'] = 7500,
            ['armor'] = {
                [0] = 2000,
                [1] = 4000,
                [2] = 6000,
                [3] = 8000,
                [4] = 10000,
            },
        },
    },
    ['upgrades'] = {
        ['engine'] = {
            [-1] = 'Stock Engine',
            [0] = 'Engine Upgrade Level 1',
            [1] = 'Engine Upgrade Level 2',
            [2] = 'Engine Upgrade Level 3',
            [3] = 'Engine Upgrade Level 4',
        },
        ['brakes'] = {
            [-1] = 'Stock Brakes',
            [0] = 'Brake Upgrade Level 1',
            [1] = 'Brake Upgrade Level 2',
            [2] = 'Brake Upgrade Level 3',
        },
        ['transmission'] = {
            [-1] = 'Stock Transmission',
            [0] = 'Transmission Upgrade Level 1',
            [1] = 'Transmission Upgrade Level 2',
            [2] = 'Transmission Upgrade Level 3',
        },
        ['suspension'] = {
            [-1] = 'Stock Suspension',
            [0] = 'Lowered Suspension',
            [1] = 'Street Suspension',
            [2] = 'Sport Suspension',
            [3] = 'Competition Suspension',
        },
        ['armor'] = {
            [-1] = 'No Armor',
            [0] = 'Armor Upgrade 20%',
            [1] = 'Armor Upgrade 40%',
            [2] = 'Armor Upgrade 60%',
            [3] = 'Armor Upgrade 80%',
            [4] = 'Armor Upgrade 100%',
        },
        ['turbo'] = {
            [-1] = 'None',
            [0] = 'Turbo Upgrade',
        },
    },
}

-- Vehicle Status Effects
SLShared.VehicleStatus = {
    ['engine'] = {
        label = 'Engine',
        defaultValue = 1000.0,
        degration = {
            minimum = 100.0,
            highSpeed = 3.0,
            normalSpeed = 1.5,
            idling = 0.3,
        },
    },
    ['body'] = {
        label = 'Body',
        defaultValue = 1000.0,
        degration = {
            minimum = 100.0,
            crash = 50.0,
            scratching = 10.0,
        },
    },
    ['fuel'] = {
        label = 'Fuel Tank',
        defaultValue = 100.0,
        degration = {
            minimum = 0.0,
            running = 1.0,
            idling = 0.2,
        },
    },
    ['clutch'] = {
        label = 'Clutch',
        defaultValue = 100.0,
        degration = {
            minimum = 0.0,
            badShift = 5.0,
            normalUse = 0.5,
        },
    },
    ['brakes'] = {
        label = 'Brakes',
        defaultValue = 100.0,
        degration = {
            minimum = 20.0,
            hardBraking = 3.0,
            normalBraking = 1.0,
        },
    },
    ['axle'] = {
        label = 'Axle',
        defaultValue = 100.0,
        degration = {
            minimum = 20.0,
            roughTerrain = 5.0,
            normalUse = 1.0,
        },
    },
}
