Config = {}

-- General Settings
Config.Debug = false
Config.DefaultLanguage = 'en'
Config.UseTarget = true -- Use qb-target for interactions

-- Job System Settings
Config.MaxJobs = 2 -- Maximum number of jobs a player can have
Config.JobChangeTimer = 30 -- Minutes required between job changes
Config.RequireManagerApproval = true -- Require manager approval for job applications
Config.AllowSelfDemotion = true -- Allow players to demote themselves
Config.PaycheckInterval = 15 -- Minutes between paychecks

-- Skill System
Config.UseSkillSystem = true
Config.SkillGainInterval = 5 -- Minutes between skill checks
Config.MaxSkillLevel = 100
Config.SkillDecayRate = 0.1 -- Skill points lost per day of inactivity

-- Job Grades
Config.DefaultGrades = {
    {level = 0, name = 'trainee', label = 'Trainee', payment = 50},
    {level = 1, name = 'employee', label = 'Employee', payment = 75},
    {level = 2, name = 'senior', label = 'Senior', payment = 100},
    {level = 3, name = 'manager', label = 'Manager', payment = 150},
    {level = 4, name = 'boss', label = 'Boss', payment = 200},
}

-- Job Categories
Config.JobCategories = {
    'emergency',
    'legal',
    'illegal',
    'civilian',
    'government'
}

-- Default Jobs (Example structure)
Config.Jobs = {
    police = {
        label = 'Police Department',
        category = 'emergency',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'cadet',
                label = 'Cadet',
                payment = 100,
                skills = {
                    required = {},
                    gainRate = {
                        shooting = 0.2,
                        driving = 0.2
                    }
                }
            },
            -- Add more grades
        },
        locations = {
            duty = {
                [1] = vector4(440.085, -974.924, 30.689, 90.654),
            },
            vehicles = {
                [1] = vector4(446.226, -991.525, 25.699, 180.654),
            }
        },
        vehicles = {
            [0] = {
                ['police'] = 'Police Car',
                ['police2'] = 'Police SUV'
            }
        },
        uniforms = {
            [0] = {
                male = {
                    ['tshirt_1'] = 59,
                    ['tshirt_2'] = 1,
                },
                female = {
                    ['tshirt_1'] = 36,
                    ['tshirt_2'] = 1,
                }
            }
        }
    }
}

-- Skills Configuration
Config.Skills = {
    ['shooting'] = {
        label = 'Shooting',
        description = 'Accuracy and weapon handling',
        xpPerLevel = 1000,
        maxLevel = 100
    },
    ['driving'] = {
        label = 'Driving',
        description = 'Vehicle control and racing',
        xpPerLevel = 1000,
        maxLevel = 100
    },
    ['crafting'] = {
        label = 'Crafting',
        description = 'Item creation and repair',
        xpPerLevel = 1000,
        maxLevel = 100
    }
}

-- Job Benefits
Config.Benefits = {
    insurance = {
        enabled = true,
        cost = 50, -- Cost per paycheck
        coverage = 0.8 -- 80% coverage
    },
    retirement = {
        enabled = true,
        matchRate = 0.05 -- 5% employer match
    }
}

-- Company Features
Config.CompanyFeatures = {
    meetings = true,
    internal_messaging = true,
    employee_tracking = true,
    performance_reviews = true,
    training_programs = true
}

-- Job Market
Config.JobMarket = {
    enabled = true,
    refreshInterval = 60, -- Minutes between job listing refreshes
    maxListings = 50,
    costToPost = 100
}

return Config
