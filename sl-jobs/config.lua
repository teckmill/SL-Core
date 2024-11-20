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

-- Job Settings
Config.Jobs = {
    police = {
        label = "Police Department",
        defaultDuty = false,
        offDutyPay = false,
        grades = {
            ['0'] = {
                name = "Cadet",
                payment = 1500,
                rankUp = {
                    hoursRequired = 20,
                    rankTest = true
                }
            },
            ['1'] = {
                name = "Officer",
                payment = 2000,
                rankUp = {
                    hoursRequired = 40,
                    rankTest = true
                }
            },
            ['2'] = {
                name = "Senior Officer",
                payment = 2500,
                rankUp = {
                    hoursRequired = 80,
                    rankTest = true
                }
            },
            ['3'] = {
                name = "Sergeant",
                payment = 3000,
                rankUp = {
                    hoursRequired = 120,
                    rankTest = true
                }
            },
            ['4'] = {
                name = "Lieutenant",
                payment = 3500,
                canManage = true
            },
            ['5'] = {
                name = "Chief",
                payment = 4000,
                isBoss = true
            }
        },
        locations = {
            ["mrpd"] = {
                duty = {
                    coords = vector4(441.7989, -982.0529, 30.67834, 11.0),
                    radius = 1.5,
                    label = "Duty Station"
                },
                armory = {
                    coords = vector4(481.4974, -995.7716, 30.68959, 28.0),
                    radius = 1.5,
                    label = "Armory"
                },
                garage = {
                    coords = vector4(454.6, -1017.4, 28.4, 90.0),
                    radius = 4.0,
                    label = "Garage",
                    vehicles = {
                        ["police"] = "Police Cruiser",
                        ["police2"] = "Police SUV",
                        ["police3"] = "Police Van"
                    }
                }
            }
        }
    },
    ambulance = {
        label = "Emergency Medical Services",
        defaultDuty = false,
        offDutyPay = false,
        grades = {
            ['0'] = {
                name = "EMT Trainee",
                payment = 1500,
                rankUp = {
                    hoursRequired = 20,
                    rankTest = true
                }
            },
            ['1'] = {
                name = "EMT",
                payment = 2000,
                rankUp = {
                    hoursRequired = 40,
                    rankTest = true
                }
            },
            ['2'] = {
                name = "Senior EMT",
                payment = 2500,
                rankUp = {
                    hoursRequired = 80,
                    rankTest = true
                }
            },
            ['3'] = {
                name = "Paramedic",
                payment = 3000,
                rankUp = {
                    hoursRequired = 120,
                    rankTest = true
                }
            },
            ['4'] = {
                name = "Senior Paramedic",
                payment = 3500,
                canManage = true
            },
            ['5'] = {
                name = "Chief of EMS",
                payment = 4000,
                isBoss = true
            }
        },
        locations = {
            ["pillbox"] = {
                duty = {
                    coords = vector4(311.2454, -592.9298, 43.28405, 341.0),
                    radius = 1.5,
                    label = "Duty Station"
                },
                garage = {
                    coords = vector4(294.578, -574.7617, 43.1849, 35.0),
                    radius = 4.0,
                    label = "Garage",
                    vehicles = {
                        ["ambulance"] = "Ambulance",
                        ["emscar"] = "Response Vehicle"
                    }
                }
            }
        }
    }
}

-- Duty Settings
Config.Duty = {
    useTarget = true, -- Use target system instead of key press
    dutyKey = 'E', -- Key to toggle duty if not using target
    notifyType = 'sl-core', -- Notification system to use
    blips = {
        police = {
            onDuty = {sprite = 60, color = 29},
            offDuty = {sprite = 60, color = 3}
        },
        ambulance = {
            onDuty = {sprite = 61, color = 1},
            offDuty = {sprite = 61, color = 3}
        }
    }
}

-- Rank Settings
Config.RankUp = {
    enabled = true,
    notifyBeforeTest = true, -- Notify when eligible for rank test
    testCooldown = 7, -- Days between test attempts
    minimumScore = 75 -- Minimum score to pass rank test (%)
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
