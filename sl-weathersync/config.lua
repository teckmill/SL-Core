Config = {}

-- Time Settings
Config.TimeScale = 1 -- How fast time moves (1 = realtime, 2 = 2x speed, etc)
Config.StartHour = 8 -- Starting hour when server starts
Config.StartMinute = 0 -- Starting minute when server starts
Config.FreezeTime = false -- If true, time will not advance

-- Weather Settings
Config.DynamicWeather = true -- If false, weather will not change automatically
Config.WeatherInterval = 15 -- Minutes between weather changes (if dynamic weather is enabled)
Config.WeatherTypes = {
    'CLEAR',
    'EXTRASUNNY',
    'CLOUDS',
    'OVERCAST',
    'RAIN',
    'CLEARING',
    'THUNDER',
    'SMOG',
    'FOGGY'
}

-- Weather Pattern Settings
Config.WeatherPatterns = {
    ['CLEAR'] = {'EXTRASUNNY', 'CLOUDS'},
    ['EXTRASUNNY'] = {'CLEAR', 'CLOUDS', 'SMOG'},
    ['CLOUDS'] = {'CLEAR', 'EXTRASUNNY', 'OVERCAST', 'RAIN'},
    ['OVERCAST'] = {'CLOUDS', 'RAIN', 'FOGGY'},
    ['RAIN'] = {'OVERCAST', 'CLEARING', 'THUNDER'},
    ['CLEARING'] = {'RAIN', 'CLOUDS', 'CLEAR'},
    ['THUNDER'] = {'RAIN', 'CLEARING'},
    ['SMOG'] = {'CLEAR', 'EXTRASUNNY', 'CLOUDS'},
    ['FOGGY'] = {'OVERCAST', 'CLOUDS'}
}

-- Blackout Settings
Config.AllowBlackout = true -- If true, admins can trigger blackouts
Config.BlackoutCommand = 'blackout' -- Command to trigger blackout (admin only)

-- Sync Settings
Config.SyncDelay = 5000 -- How often to sync with clients (in ms)

return Config
