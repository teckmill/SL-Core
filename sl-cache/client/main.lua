local SLCore = exports['sl-core']:GetCoreObject()
local Cache = {}

-- Initialize client-side cache
CreateThread(function()
    while not SLCore do
        Wait(100)
        SLCore = exports['sl-core']:GetCoreObject()
    end
end)

-- Cache Functions
function Cache.Set(key, value, ttl)
    if not key then return false end
    
    local cacheItem = {
        value = value,
        timestamp = GetGameTimer(),
        ttl = ttl or 300000 -- Default 5 minutes
    }
    
    Cache[key] = cacheItem
    return true
end

function Cache.Get(key)
    if not key or not Cache[key] then return nil end
    
    local item = Cache[key]
    local currentTime = GetGameTimer()
    
    -- Check if item has expired
    if currentTime - item.timestamp > item.ttl then
        Cache[key] = nil
        return nil
    end
    
    return item.value
end

function Cache.Clear(key)
    if key then
        Cache[key] = nil
        return true
    end
    
    -- Clear all cache if no key specified
    Cache = {}
    return true
end

-- Export cache functions
exports('SetCache', Cache.Set)
exports('GetCache', Cache.Get)
exports('ClearCache', Cache.Clear)
