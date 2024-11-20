Config = {}

Config.Debug = false
Config.Commission = 0.10 -- Sales commission for dealers (10%)
Config.FinanceCommission = 0.05 -- Finance commission for dealers (5%)

Config.PaymentType = {
    cash = 'cash',
    bank = 'bank',
    finance = 'finance'
}

Config.FinanceOptions = {
    downPaymentMin = 10, -- Minimum down payment percentage
    maxPayments = 24,    -- Maximum number of payments
    interestRate = 0.1   -- 10% interest rate
}

Config.Shops = {
    ['pdm'] = {
        label = 'Premium Deluxe Motorsport',
        type = 'car',
        job = nil, -- No job requirement (public shop)
        testDrive = {
            enabled = true,
            duration = 60, -- seconds
            price = 100,
            radius = 300.0
        },
        location = vector4(-33.7, -1102.0, 26.4, 75.0),
        showRoom = {
            coords = vector4(-45.67, -1098.34, 26.42, 29.5),
            radius = 30.0
        },
        categories = {
            ['compacts'] = 'Compacts',
            ['sedans'] = 'Sedans',
            ['suvs'] = 'SUVs',
            ['coupes'] = 'Coupes',
            ['muscle'] = 'Muscle',
            ['sports'] = 'Sports',
            ['super'] = 'Super'
        }
    },
    ['luxury'] = {
        label = 'Luxury Autos',
        type = 'car',
        job = 'cardealer', -- Requires car dealer job
        testDrive = {
            enabled = true,
            duration = 60,
            price = 500,
            radius = 300.0
        },
        location = vector4(-795.91, -220.46, 37.07, 71.5),
        showRoom = {
            coords = vector4(-789.62, -227.95, 37.07, 83.5),
            radius = 25.0
        },
        categories = {
            ['sports'] = 'Sports',
            ['super'] = 'Super',
            ['luxury'] = 'Luxury'
        }
    }
}

Config.Vehicles = {
    ['compacts'] = {
        ['asbo'] = {
            price = 8000,
            stock = 50
        },
        ['brioso'] = {
            price = 12000,
            stock = 50
        },
        ['issi2'] = {
            price = 10000,
            stock = 50
        }
    },
    ['sedans'] = {
        ['asea'] = {
            price = 15000,
            stock = 50
        },
        ['asterope'] = {
            price = 18000,
            stock = 50
        },
        ['fugitive'] = {
            price = 22000,
            stock = 50
        }
    },
    ['suvs'] = {
        ['baller'] = {
            price = 35000,
            stock = 50
        },
        ['cavalcade'] = {
            price = 32000,
            stock = 50
        },
        ['granger'] = {
            price = 38000,
            stock = 50
        }
    },
    ['coupes'] = {
        ['cogcabrio'] = {
            price = 42000,
            stock = 50
        },
        ['exemplar'] = {
            price = 45000,
            stock = 50
        },
        ['f620'] = {
            price = 48000,
            stock = 50
        }
    },
    ['muscle'] = {
        ['blade'] = {
            price = 52000,
            stock = 50
        },
        ['buccaneer'] = {
            price = 55000,
            stock = 50
        },
        ['dominator'] = {
            price = 58000,
            stock = 50
        }
    },
    ['sports'] = {
        ['alpha'] = {
            price = 75000,
            stock = 50
        },
        ['banshee'] = {
            price = 85000,
            stock = 50
        },
        ['carbonizzare'] = {
            price = 95000,
            stock = 50
        }
    },
    ['super'] = {
        ['adder'] = {
            price = 250000,
            stock = 10
        },
        ['bullet'] = {
            price = 225000,
            stock = 10
        },
        ['cheetah'] = {
            price = 275000,
            stock = 10
        }
    },
    ['luxury'] = {
        ['cognoscenti'] = {
            price = 150000,
            stock = 25
        },
        ['schafter3'] = {
            price = 175000,
            stock = 25
        },
        ['superd'] = {
            price = 200000,
            stock = 25
        }
    }
}

Config.DefaultVehicle = 'asea' -- Default display vehicle
Config.HideMenu = 25.0 -- Distance to hide menu

Config.ShowroomVehicles = {
    [1] = {
        coords = vector4(-45.65, -1093.66, 25.44, 69.5),
        defaultVehicle = 'adder',
        chosenVehicle = 'adder',
        inUse = false
    },
    [2] = {
        coords = vector4(-48.27, -1101.86, 25.44, 294.5),
        defaultVehicle = 'schafter3',
        chosenVehicle = 'schafter3',
        inUse = false
    },
    [3] = {
        coords = vector4(-39.6, -1096.01, 25.44, 66.5),
        defaultVehicle = 'comet2',
        chosenVehicle = 'comet2',
        inUse = false
    }
}
