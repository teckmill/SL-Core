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
    ['noclip'] = 2, -- moderator and above
    ['godmode'] = 3, -- admin and above
    ['spawnvehicle'] = 2,
    ['fixvehicle'] = 1,
    ['heal'] = 1,
    ['revive'] = 1,
    ['kick'] = 2,
    ['ban'] = 3,
    ['unban'] = 3,
    ['teleport'] = 1,
    ['setjob'] = 3,
    ['give_money'] = 4,
    ['give_item'] = 3,
    ['weather'] = 2,
    ['time'] = 2,
    ['announce'] = 2,
    ['freeze'] = 2,
    ['spectate'] = 2,
    ['reports'] = 1,
    ['warn'] = 1,
    ['viewwarnings'] = 1,
    ['clearwarnings'] = 3
}

-- Logging Settings
Config.LogActions = {
    ['player_banned'] = true,
    ['player_kicked'] = true,
    ['item_spawned'] = true,
    ['money_given'] = true,
    ['vehicle_spawned'] = true,
    ['noclip_used'] = true,
    ['godmode_used'] = true,
    ['teleport_used'] = true,
    ['weather_changed'] = true,
    ['time_changed'] = true,
    ['report_handled'] = true
}

-- Discord Integration
Config.DiscordLogChannels = {
    ['bans'] = '', -- Add Discord webhook for ban logs
    ['kicks'] = '', -- Add Discord webhook for kick logs
    ['spawns'] = '', -- Add Discord webhook for item/vehicle spawns
    ['reports'] = '', -- Add Discord webhook for player reports
    ['actions'] = '' -- Add Discord webhook for general admin actions
}

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
