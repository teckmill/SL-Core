Config = {}

Config.Debug = false

-- Reputation Levels
Config.Levels = {
    [0] = {name = "Newcomer", minPoints = 0},
    [1] = {name = "Known", minPoints = 100},
    [2] = {name = "Respected", minPoints = 500},
    [3] = {name = "Trusted", minPoints = 1000},
    [4] = {name = "Elite", minPoints = 2500},
    [5] = {name = "Legendary", minPoints = 5000}
}

-- Reputation Categories
Config.Categories = {
    ["general"] = {
        label = "General Reputation",
        description = "Overall standing in the community",
        defaultValue = 0
    },
    ["police"] = {
        label = "Police Reputation",
        description = "Standing with law enforcement",
        defaultValue = 0
    },
    ["ambulance"] = {
        label = "Medical Reputation",
        description = "Standing with medical services",
        defaultValue = 0
    },
    ["mechanic"] = {
        label = "Mechanic Reputation",
        description = "Standing with mechanics",
        defaultValue = 0
    },
    ["business"] = {
        label = "Business Reputation",
        description = "Standing in the business community",
        defaultValue = 0
    }
}

-- Points Configuration
Config.Points = {
    -- General Actions
    COMPLETE_JOB = 10,
    HELP_PLAYER = 5,
    CRIMINAL_ACTIVITY = -10,
    
    -- Police Actions
    ASSIST_POLICE = 15,
    RESIST_ARREST = -20,
    
    -- Medical Actions
    ASSIST_EMS = 15,
    DONATE_MEDICAL = 10,
    
    -- Mechanic Actions
    REPAIR_VEHICLE = 10,
    ASSIST_MECHANIC = 5,
    
    -- Business Actions
    COMPLETE_DELIVERY = 10,
    SUCCESSFUL_SALE = 5
}

-- UI Configuration
Config.UI = {
    showNotifications = true,
    showLevelUp = true,
    showPointsGain = true
}

-- Time Settings
Config.TimeSettings = {
    saveInterval = 5, -- minutes
    decayInterval = 1440, -- minutes (24 hours)
    decayAmount = 1 -- points
}
