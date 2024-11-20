SLConfig = {}

-- General Settings
SLConfig.MaxPlayers = GetConvarInt('sv_maxclients', 48) -- Gets max players from config
SLConfig.DefaultSpawn = vector4(-1035.71, -2731.87, 12.86, 0.0)
SLConfig.UpdateInterval = 5 -- How often to update player data in minutes

-- Money Settings
SLConfig.Money = {
    MoneyTypes = { cash = 500, bank = 5000, crypto = 0 }, -- Starting money
    DontAllowMinus = { 'cash', 'crypto' }, -- Money types that can't go below 0
}

-- Player Related
SLConfig.Player = {
    MaxWeight = 120000, -- Max weight a player can carry (grams)
    MaxInvSlots = 41, -- Max inventory slots
    HungerRate = 4.2, -- Rate at which hunger goes down
    ThirstRate = 3.8, -- Rate at which thirst goes down
}

-- Job Settings
SLConfig.Jobs = {
    DefaultJob = 'unemployed',
    DefaultJobGrade = '0',
}

-- Gang Settings
SLConfig.Gangs = {
    DefaultGang = 'none',
    DefaultGangGrade = '0',
}

-- Item Degradation
SLConfig.Degradation = {
    Enabled = true,
    Items = {
        ['water'] = 24, -- Hours until degradation
        ['sandwich'] = 48,
    }
}

-- Discord Settings
SLConfig.Discord = {
    Enabled = false,
    GuildId = '',
    Roles = {},
}

-- Debug Settings
SLConfig.Debug = false -- Enable debug mode
SLConfig.CommandPrefix = '/' -- Prefix for commands

-- Database Settings
SLConfig.Database = {
    UseConnector = 'oxmysql', -- Database connector to use
    SaveInterval = 10, -- How often to save all player data (minutes)
}

-- Notification Settings
SLConfig.Notify = {
    NotificationStyling = {
        group = false, -- Allow notifications to stack with a badge instead of repeating
        position = "right", -- top-left | top-right | bottom-left | bottom-right | top | bottom | left | right | center
        progress = true -- Display Progress Bar
    },
    VariantDefinitions = {
        success = {
            classes = 'success',
            icon = 'task_alt'
        },
        primary = {
            classes = 'primary',
            icon = 'notifications'
        },
        error = {
            classes = 'error',
            icon = 'warning'
        },
        police = {
            classes = 'police',
            icon = 'local_police'
        },
        ambulance = {
            classes = 'ambulance',
            icon = 'fas fa-ambulance'
        }
    }
}
