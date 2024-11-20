Config = {}

-- General Settings
Config.Debug = false
Config.DefaultCurrency = '$'
Config.PayPeriod = 'weekly' -- 'daily', 'weekly', 'biweekly', 'monthly'
Config.MaxHoursPerWeek = 40
Config.OvertimeMultiplier = 1.5
Config.PaymentMethod = 'bank' -- 'bank', 'cash', 'both'

-- Tax Settings
Config.Taxes = {
    enabled = true,
    brackets = {
        { threshold = 0, rate = 0.10 },     -- 10% up to first threshold
        { threshold = 1000, rate = 0.15 },  -- 15% from 1,000 to 5,000
        { threshold = 5000, rate = 0.20 },  -- 20% from 5,000 to 10,000
        { threshold = 10000, rate = 0.25 }, -- 25% above 10,000
    },
    deductions = {
        healthcare = 0.02,  -- 2% healthcare deduction
        retirement = 0.03,  -- 3% retirement contribution
        insurance = 0.015   -- 1.5% insurance premium
    }
}

-- Benefits Settings
Config.Benefits = {
    healthcare = {
        enabled = true,
        plans = {
            basic = {
                cost = 100,
                coverage = 0.70,
                description = "Basic healthcare plan with 70% coverage"
            },
            standard = {
                cost = 200,
                coverage = 0.85,
                description = "Standard healthcare plan with 85% coverage"
            },
            premium = {
                cost = 300,
                coverage = 0.95,
                description = "Premium healthcare plan with 95% coverage"
            }
        }
    },
    retirement = {
        enabled = true,
        employerMatch = 0.50, -- 50% employer match
        maxMatchPercent = 0.06 -- Up to 6% of salary
    },
    paidTimeOff = {
        enabled = true,
        accrualRate = 0.0385, -- ~10 days per year (based on 260 working days)
        maxBalance = 80, -- Maximum 80 hours can be accrued
        carryOver = 40 -- Maximum 40 hours can be carried over to next year
    }
}

-- Position Settings
Config.Positions = {
    trainee = {
        baseRate = 15,
        overtimeEligible = true,
        benefits = {
            healthcare = true,
            retirement = false,
            paidTimeOff = true
        }
    },
    employee = {
        baseRate = 20,
        overtimeEligible = true,
        benefits = {
            healthcare = true,
            retirement = true,
            paidTimeOff = true
        }
    },
    supervisor = {
        baseRate = 25,
        overtimeEligible = true,
        benefits = {
            healthcare = true,
            retirement = true,
            paidTimeOff = true
        }
    },
    manager = {
        baseRate = 30,
        overtimeEligible = false,
        benefits = {
            healthcare = true,
            retirement = true,
            paidTimeOff = true
        }
    },
    executive = {
        baseRate = 40,
        overtimeEligible = false,
        benefits = {
            healthcare = true,
            retirement = true,
            paidTimeOff = true
        }
    }
}

-- Bonus Settings
Config.Bonuses = {
    performance = {
        exceptional = 0.10, -- 10% bonus
        outstanding = 0.07, -- 7% bonus
        satisfactory = 0.05 -- 5% bonus
    },
    attendance = {
        perfect = 100, -- $100 bonus for perfect attendance
        good = 50     -- $50 bonus for good attendance
    },
    holiday = {
        multiplier = 2.0 -- Double pay for holiday work
    }
}

-- Notification Settings
Config.Notifications = {
    paycheck = {
        enabled = true,
        type = 'success',
        duration = 5000
    },
    bonus = {
        enabled = true,
        type = 'success',
        duration = 5000
    },
    error = {
        enabled = true,
        type = 'error',
        duration = 5000
    }
}

-- UI Settings
Config.UI = {
    showPaystub = true,
    showYTDEarnings = true,
    showDeductions = true,
    showBenefits = true,
    theme = {
        primary = '#007bff',
        secondary = '#6c757d',
        success = '#28a745',
        danger = '#dc3545',
        warning = '#ffc107',
        info = '#17a2b8'
    }
}

-- Admin Settings
Config.Admin = {
    allowManualPayroll = true,
    requireApprovalAbove = 5000, -- Requires admin approval for amounts above $5000
    auditLog = true,
    maxBackpay = 30 -- Maximum days for backpay calculations
}

-- Integration Settings
Config.Integrations = {
    banking = true,  -- Integration with sl-banking
    business = true, -- Integration with sl-business
    jobs = true     -- Integration with sl-jobs
}

return Config
