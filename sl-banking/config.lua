Config = {}

-- General Settings
Config.Debug = false
Config.DefaultLanguage = 'en'
Config.UseTarget = true -- Use qb-target for interactions

-- Currency Settings
Config.Currency = '$'
Config.CurrencySymbolOnLeft = true -- $100 vs 100$

-- Account Types
Config.AccountTypes = {
    personal = {
        name = 'Personal',
        maxBalance = 999999999,
        minBalance = -1000,
        dailyLimit = 50000,
        transferFee = 0,
        monthlyFee = 0
    },
    business = {
        name = 'Business',
        maxBalance = 99999999999,
        minBalance = -10000,
        dailyLimit = 500000,
        transferFee = 0.001, -- 0.1%
        monthlyFee = 99
    },
    savings = {
        name = 'Savings',
        maxBalance = 999999999,
        minBalance = 0,
        dailyLimit = 10000,
        transferFee = 0,
        monthlyFee = 0,
        interestRate = 0.02 -- 2% APY
    },
    credit = {
        name = 'Credit',
        maxBalance = 0,
        minBalance = -10000,
        dailyLimit = 10000,
        transferFee = 0,
        monthlyFee = 25,
        interestRate = 0.1599 -- 15.99% APR
    }
}

-- ATM Settings
Config.ATMModels = {
    `prop_atm_01`,
    `prop_atm_02`,
    `prop_atm_03`,
    `prop_fleeca_atm`
}

Config.ATMLocations = {
    vector4(147.8, -1036.12, 29.34, 340.0),
    vector4(-1205.02, -326.28, 37.83, 394.23),
    -- Add more ATM locations
}

Config.ATMLimits = {
    maxWithdrawal = 5000,
    maxDeposit = 10000,
    fee = 0 -- ATM usage fee
}

-- Bank Locations
Config.Banks = {
    ['pacific'] = {
        label = 'Pacific Standard',
        coords = vector4(248.89, 230.79, 106.29, 160.54),
        blip = {
            sprite = 108,
            color = 2,
            scale = 0.8
        }
    },
    ['legion'] = {
        label = 'Legion Square',
        coords = vector4(149.46, -1042.09, 29.37, 340.0),
        blip = {
            sprite = 108,
            color = 2,
            scale = 0.8
        }
    }
    -- Add more bank locations
}

-- Transaction Settings
Config.TransactionTypes = {
    deposit = {
        label = 'Deposit',
        color = '#4CAF50'
    },
    withdraw = {
        label = 'Withdraw',
        color = '#F44336'
    },
    transfer = {
        label = 'Transfer',
        color = '#2196F3'
    },
    payment = {
        label = 'Payment',
        color = '#9C27B0'
    },
    fee = {
        label = 'Fee',
        color = '#FF9800'
    },
    interest = {
        label = 'Interest',
        color = '#4CAF50'
    },
    loan = {
        label = 'Loan',
        color = '#607D8B'
    }
}

-- Loan Settings
Config.Loans = {
    personal = {
        name = 'Personal Loan',
        maxAmount = 50000,
        interestRate = 0.0899, -- 8.99% APR
        maxTerm = 24, -- months
        minCreditScore = 600
    },
    business = {
        name = 'Business Loan',
        maxAmount = 500000,
        interestRate = 0.0599, -- 5.99% APR
        maxTerm = 60, -- months
        minCreditScore = 700
    },
    mortgage = {
        name = 'Mortgage',
        maxAmount = 1000000,
        interestRate = 0.0399, -- 3.99% APR
        maxTerm = 360, -- months
        minCreditScore = 680
    }
}

-- Credit Score Settings
Config.CreditScore = {
    min = 300,
    max = 850,
    defaultScore = 650,
    factors = {
        paymentHistory = 0.35,
        creditUtilization = 0.30,
        creditAge = 0.15,
        newCredit = 0.10,
        creditMix = 0.10
    }
}

-- Investment Settings
Config.Investments = {
    enabled = true,
    types = {
        stocks = {
            name = 'Stocks',
            minInvestment = 100,
            maxInvestment = 1000000,
            volatility = 0.2, -- 20% price volatility
            fee = 0.001 -- 0.1% transaction fee
        },
        crypto = {
            name = 'Cryptocurrency',
            minInvestment = 10,
            maxInvestment = 500000,
            volatility = 0.5, -- 50% price volatility
            fee = 0.002 -- 0.2% transaction fee
        },
        bonds = {
            name = 'Government Bonds',
            minInvestment = 1000,
            maxInvestment = 2000000,
            interestRate = 0.04, -- 4% annual return
            term = 12 -- months
        }
    }
}

-- Security Settings
Config.Security = {
    maxLoginAttempts = 3,
    lockoutTime = 300, -- seconds
    requirePIN = true,
    pinLength = 4,
    sessionTimeout = 300, -- seconds
    requireTwoFactor = false
}

-- UI Settings
Config.UI = {
    showBalance = true,
    showTransactions = true,
    maxTransactionHistory = 50,
    refreshRate = 30, -- seconds
    themes = {
        'default',
        'dark',
        'light'
    }
}

return Config
