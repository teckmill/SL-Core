Config = {}

-- General Settings
Config.Debug = false
Config.DefaultLanguage = 'en'
Config.UseTarget = true -- Use sl-target for interactions
Config.MaxBusinessesPerPlayer = 3
Config.BusinessLicenseCost = 25000
Config.BusinessTaxRate = 0.15 -- 15% tax rate

-- Business Types
Config.BusinessTypes = {
    restaurant = {
        label = 'Restaurant',
        requiredLicense = 'business.food',
        basePrice = 150000,
        maxEmployees = 15,
        maxStorage = 1000,
        upgrades = {
            kitchen = {
                levels = 3,
                basePrice = 25000,
                benefits = {
                    productionSpeed = {0.1, 0.2, 0.3},
                    quality = {0.1, 0.2, 0.3}
                }
            },
            seating = {
                levels = 3,
                basePrice = 15000,
                benefits = {
                    capacity = {10, 20, 30}
                }
            },
            storage = {
                levels = 3,
                basePrice = 20000,
                benefits = {
                    capacity = {250, 500, 1000}
                }
            }
        }
    },
    shop = {
        label = 'Retail Shop',
        requiredLicense = 'business.retail',
        basePrice = 100000,
        maxEmployees = 10,
        maxStorage = 2000,
        upgrades = {
            display = {
                levels = 3,
                basePrice = 10000,
                benefits = {
                    salesBonus = {0.05, 0.1, 0.15}
                }
            },
            security = {
                levels = 3,
                basePrice = 15000,
                benefits = {
                    theftReduction = {0.2, 0.4, 0.6}
                }
            },
            storage = {
                levels = 3,
                basePrice = 20000,
                benefits = {
                    capacity = {500, 1000, 2000}
                }
            }
        }
    },
    mechanic = {
        label = 'Auto Repair Shop',
        requiredLicense = 'business.mechanic',
        basePrice = 200000,
        maxEmployees = 8,
        maxStorage = 1500,
        upgrades = {
            lift = {
                levels = 3,
                basePrice = 30000,
                benefits = {
                    repairSpeed = {0.1, 0.2, 0.3}
                }
            },
            tools = {
                levels = 3,
                basePrice = 25000,
                benefits = {
                    quality = {0.1, 0.2, 0.3}
                }
            },
            storage = {
                levels = 3,
                basePrice = 20000,
                benefits = {
                    capacity = {300, 600, 1500}
                }
            }
        }
    }
}

-- Employee Management
Config.EmployeeSettings = {
    minWage = 50,
    maxWage = 500,
    payInterval = 60, -- minutes
    maxShiftLength = 8, -- hours
    breakTime = 30, -- minutes
    overtimeMultiplier = 1.5
}

-- Financial Settings
Config.Finance = {
    startingBalance = 10000,
    minCashBalance = 1000,
    maxLoanAmount = 500000,
    interestRates = {
        loan = 0.05, -- 5% interest on loans
        savings = 0.02 -- 2% interest on savings
    },
    insurancePlans = {
        basic = {
            cost = 500,
            coverage = 0.5
        },
        premium = {
            cost = 1000,
            coverage = 0.8
        }
    }
}

-- Inventory Settings
Config.Inventory = {
    defaultSlots = 50,
    maxSlots = 200,
    slotUpgradeCost = 1000,
    maxItemStack = 100,
    degradationRate = 0.01 -- 1% per day
}

-- Business Zones
Config.BusinessZones = {
    downtown = {
        multiplier = 1.5, -- Higher costs but more customers
        crimerate = 0.1,
        competition = 'high'
    },
    suburban = {
        multiplier = 1.0,
        crimerate = 0.2,
        competition = 'medium'
    },
    industrial = {
        multiplier = 0.8,
        crimerate = 0.3,
        competition = 'low'
    }
}

-- Customer AI Settings
Config.CustomerAI = {
    enabled = true,
    spawnDistance = 100.0,
    maxCustomers = 20,
    behaviorTypes = {
        browser = 0.4,
        buyer = 0.3,
        window_shopper = 0.3
    }
}

-- Business Reputation System
Config.Reputation = {
    startingRep = 50,
    maxRep = 100,
    minRep = 0,
    impacts = {
        goodService = 1,
        badService = -2,
        complaint = -5,
        promotion = 3
    }
}

-- Business Events
Config.Events = {
    enabled = true,
    types = {
        sale = {
            duration = 24, -- hours
            maxDiscount = 0.5,
            advertisingCost = 1000
        },
        grandOpening = {
            duration = 48,
            boostMultiplier = 2.0,
            cost = 5000
        }
    }
}

return Config
