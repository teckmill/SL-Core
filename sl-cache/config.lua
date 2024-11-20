Config = {}

-- Cache Settings
Config.DefaultTTL = 300 -- Default Time To Live in seconds
Config.MaxCacheSize = 10000 -- Maximum number of items in cache
Config.CleanupInterval = 60 -- Cleanup interval in seconds

-- Cache Types
Config.CacheTypes = {
    MEMORY = 'memory', -- In-memory cache
    PERSISTENT = 'persistent' -- Persistent cache (saved between server restarts)
}

-- Cache Priorities
Config.Priorities = {
    LOW = 1,
    MEDIUM = 2,
    HIGH = 3,
    CRITICAL = 4
}

-- Cache Groups
Config.Groups = {
    PLAYER = 'player',
    VEHICLE = 'vehicle',
    INVENTORY = 'inventory',
    BUSINESS = 'business',
    HOUSING = 'housing',
    SOCIAL = 'social'
}

-- Persistent Cache Settings
Config.PersistentCache = {
    Enabled = true,
    SaveInterval = 300, -- Save to disk every 5 minutes
    SavePath = 'cache/', -- Path to save persistent cache files
    LoadOnStart = true -- Load persistent cache on resource start
}

-- Memory Management
Config.MemoryLimit = 512 * 1024 * 1024 -- 512MB max memory usage
Config.EvictionPolicy = 'LRU' -- Least Recently Used
Config.EnableCompression = true -- Enable data compression for large values

-- Debug Settings
Config.Debug = false
Config.TrackStats = true -- Track cache statistics
Config.LogLevel = 'INFO' -- DEBUG, INFO, WARN, ERROR
