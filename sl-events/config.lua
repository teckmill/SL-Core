Config = {}

-- Event System Settings
Config.MaxEvents = 100 -- Maximum number of concurrent events
Config.EventTimeout = 300 -- Event timeout in seconds
Config.MaxEventHandlers = 50 -- Maximum handlers per event

-- Event Types
Config.EventTypes = {
    PLAYER = 'player',
    VEHICLE = 'vehicle',
    RESOURCE = 'resource',
    SYSTEM = 'system',
    CUSTOM = 'custom'
}

-- Event Priorities
Config.Priorities = {
    LOW = 1,
    MEDIUM = 2,
    HIGH = 3,
    CRITICAL = 4
}

-- Event Groups
Config.Groups = {
    CORE = 'core',
    PLAYER = 'player',
    VEHICLE = 'vehicle',
    INVENTORY = 'inventory',
    BUSINESS = 'business',
    HOUSING = 'housing',
    SOCIAL = 'social'
}

-- Event Logging
Config.Logging = {
    Enabled = true,
    LogLevel = 'INFO', -- DEBUG, INFO, WARN, ERROR
    LogToFile = true,
    LogToConsole = true,
    LogPath = 'logs/',
    MaxLogSize = 10 * 1024 * 1024, -- 10MB
    MaxLogFiles = 10
}

-- Event Batching
Config.Batching = {
    Enabled = true,
    BatchSize = 100,
    BatchTimeout = 1000, -- milliseconds
    MaxBatchSize = 1000
}

-- Event Filtering
Config.Filtering = {
    Enabled = true,
    BlacklistedEvents = {
        'playerLoaded', -- Example of blacklisted event
        'resourceStart'
    },
    WhitelistedResources = {
        'sl-core',
        'sl-events'
    }
}

-- Event Rate Limiting
Config.RateLimit = {
    Enabled = true,
    MaxEventsPerSecond = 100,
    BurstSize = 200,
    TimeWindow = 60 -- seconds
}

-- Debug Settings
Config.Debug = false
Config.TraceEvents = false -- Enable detailed event tracing
Config.ProfileEvents = false -- Enable event performance profiling
