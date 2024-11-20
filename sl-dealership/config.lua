Config = {}

-- Dealership Locations
Config.Dealerships = {
    ['pdm'] = {
        label = "Premium Deluxe Motorsport",
        type = "car",
        location = vector4(-33.7, -1102.0, 26.4, 340.0),
        blip = {
            sprite = 326,
            color = 3,
            scale = 0.8
        },
        displayAreas = {
            {coords = vector4(-43.9, -1097.0, 26.4, 120.0)},
            {coords = vector4(-47.5, -1092.0, 26.4, 120.0)},
            {coords = vector4(-51.1, -1087.0, 26.4, 120.0)},
        },
        testDrive = {
            enabled = true,
            duration = 60, -- seconds
            returnLocation = vector4(-44.0, -1082.0, 26.4, 70.0),
            deposit = 2500
        }
    },
    ['luxury'] = {
        label = "Luxury Autos",
        type = "car",
        location = vector4(-795.9, -220.5, 37.1, 329.0),
        blip = {
            sprite = 326,
            color = 0,
            scale = 0.8
        },
        displayAreas = {
            {coords = vector4(-798.9, -229.9, 37.1, 30.0)},
            {coords = vector4(-792.9, -233.9, 37.1, 30.0)},
        },
        testDrive = {
            enabled = true,
            duration = 60,
            returnLocation = vector4(-785.9, -226.9, 37.1, 30.0),
            deposit = 5000
        }
    }
}

-- Vehicle Categories
Config.Categories = {
    compacts = {
        label = "Compacts",
        vehicles = {
            {model = "asbo", name = "Asbo", price = 12500},
            {model = "blista", name = "Blista", price = 15000},
            {model = "brioso", name = "Brioso R/A", price = 18000},
            {model = "club", name = "Club", price = 20000},
            {model = "dilettante", name = "Dilettante", price = 13500},
            {model = "issi2", name = "Issi", price = 16000},
            {model = "panto", name = "Panto", price = 11000},
            {model = "prairie", name = "Prairie", price = 14500},
            {model = "rhapsody", name = "Rhapsody", price = 13000},
        }
    },
    sedans = {
        label = "Sedans",
        vehicles = {
            {model = "asea", name = "Asea", price = 18000},
            {model = "asterope", name = "Asterope", price = 22000},
            {model = "cognoscenti", name = "Cognoscenti", price = 55000},
            {model = "emperor", name = "Emperor", price = 16000},
            {model = "fugitive", name = "Fugitive", price = 24000},
            {model = "glendale", name = "Glendale", price = 20000},
            {model = "intruder", name = "Intruder", price = 19000},
            {model = "premier", name = "Premier", price = 21000},
            {model = "primo", name = "Primo", price = 19500},
            {model = "regina", name = "Regina", price = 17000},
            {model = "stafford", name = "Stafford", price = 45000},
        }
    },
    sports = {
        label = "Sports",
        vehicles = {
            {model = "alpha", name = "Alpha", price = 85000},
            {model = "banshee", name = "Banshee", price = 95000},
            {model = "bestiagts", name = "Bestia GTS", price = 105000},
            {model = "buffalo", name = "Buffalo", price = 75000},
            {model = "carbonizzare", name = "Carbonizzare", price = 125000},
            {model = "comet2", name = "Comet", price = 115000},
            {model = "coquette", name = "Coquette", price = 138000},
            {model = "elegy2", name = "Elegy RH8", price = 95000},
            {model = "feltzer2", name = "Feltzer", price = 130000},
            {model = "furoregt", name = "Furore GT", price = 108000},
        }
    }
}

-- Finance Settings
Config.Finance = {
    enabled = true,
    minDownPayment = 20, -- Minimum down payment percentage
    maxMonths = 24, -- Maximum finance period in months
    interestRate = 5, -- Annual interest rate percentage
    minCreditScore = 500, -- Minimum credit score required
    jobRequirements = {
        minimumPaycheck = 1500, -- Minimum paycheck required
        minimumJobTime = 7 -- Minimum days at current job
    }
}

-- Test Drive Settings
Config.TestDrive = {
    maxSpeed = 100.0, -- Maximum speed during test drive
    maxDistance = 500.0, -- Maximum distance from dealership
    damageLimit = 100.0, -- Maximum allowed damage before penalty
    penaltyMultiplier = 2.0 -- Penalty multiplier for deposit if damaged/late
}

-- Commission Settings
Config.Commission = {
    enabled = true,
    percentage = 10, -- Commission percentage for salespeople
    jobName = "cardealer" -- Required job to earn commission
} 