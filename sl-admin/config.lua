Config = {}

-- General Settings
Config.DefaultLanguage = 'en'
Config.LogLevel = 'info' -- debug, info, warn, error
Config.EnableDiscordLogs = true
Config.DiscordWebhook = '' -- Add your Discord webhook URL here

-- Admin Ranks
Config.AdminRanks = {
    ['user'] = 0,
    ['helper'] = 1,
    ['moderator'] = 2,
    ['admin'] = 3,
    ['superadmin'] = 4,
    ['owner'] = 5
}

-- Admin Menu Settings
Config.MenuKey = 'F10' -- Key to open admin menu
Config.MenuStyle = 'modern' -- modern or classic
Config.EnableKeybinds = true
Config.ShowPlayerIDs = true
Config.ShowPlayerCoords = true

-- NoClip Settings
Config.NoclipKey = 'F3'
Config.NoclipSpeed = {
    slow = 0.1,
    normal = 0.5,
    fast = 2.0,
    veryfast = 5.0
}
Config.NoclipControlsEnabled = true
Config.NoclipShowControls = true

-- Spectate Settings
Config.SpectateControls = {
    next = 'RIGHT',
    previous = 'LEFT',
    exit = 'BACKSPACE'
}
Config.SpectateNotifyTarget = true -- Notify player when being spectated

-- Report System
Config.ReportCooldown = 300 -- seconds (5 minutes)
Config.MinReportLength = 10
Config.MaxReportLength = 1000
Config.NotifyAdminsOnReport = true
Config.AutoCloseReports = true
Config.ReportAutoCloseTime = 48 -- hours

-- Player Management
Config.DefaultGodmode = false
Config.DefaultInvisible = false
Config.EnableNameTags = true
Config.NameTagDistance = 15
Config.ShowHealthArmor = true

-- Vehicle Management
Config.VehicleCategories = {
    ['emergency'] = 'Emergency Vehicles',
    ['service'] = 'Service Vehicles',
    ['sports'] = 'Sports Cars',
    ['super'] = 'Super Cars',
    ['motorcycles'] = 'Motorcycles'
}

-- Teleport Locations
Config.SavedLocations = {
    ['police'] = vector4(442.0, -983.0, 30.0, 0.0),
    ['hospital'] = vector4(299.0, -584.0, 43.0, 0.0),
    ['garage'] = vector4(-281.0, -888.0, 31.0, 0.0)
}

-- Banned Words/Phrases
Config.BannedWords = {
    'badword1',
    'badword2',
    'badword3'
}

-- Weather/Time Control
Config.WeatherTypes = {
    'CLEAR',
    'EXTRASUNNY',
    'CLOUDS',
    'OVERCAST',
    'RAIN',
    'THUNDER',
    'CLEARING',
    'SMOG',
    'FOGGY',
    'SNOW',
    'BLIZZARD',
    'SNOWLIGHT',
    'HALLOWEEN'
}

-- Action Permissions
Config.Permissions = {
    ['menu'] = 1,
    ['kick'] = 2,
    ['ban'] = 3,
    ['unban'] = 3,
    ['spectate'] = 2,
    ['teleport'] = 2,
    ['freeze'] = 2,
    ['revive'] = 2,
    ['heal'] = 2,
    ['goto'] = 2,
    ['bring'] = 2,
    ['noclip'] = 2,
    ['godmode'] = 3,
    ['invisible'] = 3,
    ['giveitem'] = 4,
    ['vehicle'] = 2,
    ['weather'] = 3,
    ['time'] = 3,
    ['developer'] = 4,
    ['inventory'] = 3,
    ['reports'] = 2
}

-- Discord Log Channels
Config.DiscordLogChannels = {
    ['kicks'] = '', -- Add webhook URL for kick logs
    ['bans'] = '', -- Add webhook URL for ban logs
    ['admin'] = '', -- Add webhook URL for general admin actions
    ['reports'] = '' -- Add webhook URL for player reports
}

-- Log Actions
Config.LogActions = {
    ['player_kicked'] = true,
    ['player_banned'] = true,
    ['player_revived'] = true,
    ['admin_goto'] = true,
    ['admin_bring'] = true,
    ['item_given'] = true,
    ['vehicle_spawned'] = true,
    ['vehicle_deleted'] = true,
    ['weather_changed'] = true,
    ['time_changed'] = true,
    ['inventory_opened'] = true,
    ['report_submitted'] = true,
    ['report_closed'] = true
}

-- Developer Tools
Config.DevTools = {
    ['show_coords'] = true,
    ['show_heading'] = true,
    ['show_entity_info'] = true,
    ['show_vehicle_info'] = true
}

-- Vehicle Spawn Settings
Config.VehicleSpawnClean = true
Config.VehicleSpawnUpgraded = false
Config.VehicleSpawnInvincible = false

-- Player Management Settings
Config.ReviveHealthAmount = 200
Config.ReviveArmorAmount = 0
Config.HealHealthAmount = 200
Config.HealArmorAmount = 100

-- Menu Display Settings
Config.MenuAlign = 'top-right'
Config.MenuWidth = '400px'
Config.MenuMaxHeight = '70vh'
Config.MenuItemHeight = '50px'
Config.MenuItemSpacing = '2px'
Config.MenuBackgroundColor = '#1a1a1a'
Config.MenuTextColor = '#ffffff'
Config.MenuHoverColor = '#2a2a2a'
Config.MenuBorderRadius = '4px'
Config.MenuFontSize = '14px'
Config.MenuFontFamily = 'Roboto, sans-serif'

-- Menu Features
Config.MenuFeatures = {
    player = {
        enabled = true,
        features = {
            'heal',
            'armor',
            'kill',
            'freeze',
            'spectate',
            'goto',
            'bring',
            'setjob',
            'inventory',
            'kick',
            'ban'
        }
    },
    vehicle = {
        enabled = true,
        features = {
            'spawn',
            'fix',
            'clean',
            'delete',
            'mod',
            'boost'
        }
    },
    server = {
        enabled = true,
        features = {
            'weather',
            'time',
            'announce',
            'cleararea',
            'clearall'
        }
    },
    dev = {
        enabled = true,
        features = {
            'coords',
            'heading',
            'noclip',
            'names',
            'blips',
            'developer'
        }
    }
}
