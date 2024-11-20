local SL = exports['sl-core']:GetCoreObject()
local Cache = {
    data = {},
    stats = {
        hits = 0,
        misses = 0,
        evictions = 0
    }
}

-- Cache Item Class
local CacheItem = {}
CacheItem.__index = CacheItem

function CacheItem.new(key, value, ttl, priority, group)
    local self = setmetatable({}, CacheItem)
    self.key = key
    self.value = value
    self.ttl = ttl or Config.DefaultTTL
    self.priority = priority or Config.Priorities.MEDIUM
    self.group = group
    self.created = os.time()
    self.lastAccessed = os.time()
    self.accessCount = 0
    return self
end

function CacheItem:isExpired()
    return os.time() - self.created > self.ttl
end

function CacheItem:access()
    self.lastAccessed = os.time()
    self.accessCount = self.accessCount + 1
end

-- Cache Management Functions
local function GetCacheSize()
    local size = 0
    for _ in pairs(Cache.data) do
        size = size + 1
    end
    return size
end

local function CompressValue(value)
    if not Config.EnableCompression then return value end
    -- Implement compression logic here
    return value
end

local function DecompressValue(value)
    if not Config.EnableCompression then return value end
    -- Implement decompression logic here
    return value
end

local function EvictItems()
    if GetCacheSize() < Config.MaxCacheSize then return end
    
    local items = {}
    for key, item in pairs(Cache.data) do
        table.insert(items, {key = key, item = item})
    end
    
    -- Sort by priority (lowest first) and last accessed time
    table.sort(items, function(a, b)
        if a.item.priority == b.item.priority then
            return a.item.lastAccessed < b.item.lastAccessed
        end
        return a.item.priority < b.item.priority
    end)
    
    -- Remove lowest priority items
    local removed = 0
    while GetCacheSize() >= Config.MaxCacheSize and removed < #items do
        removed = removed + 1
        Cache.data[items[removed].key] = nil
        Cache.stats.evictions = Cache.stats.evictions + 1
    end
end

-- Public Cache API
function Cache.Set(key, value, ttl, priority, group)
    EvictItems()
    
    local item = CacheItem.new(key, CompressValue(value), ttl, priority, group)
    Cache.data[key] = item
    
    if Config.Debug then
        print(string.format('^2[CACHE] Set: %s (TTL: %d, Priority: %d, Group: %s)^0',
            key, ttl or Config.DefaultTTL, priority or Config.Priorities.MEDIUM, group or 'none'))
    end
end

function Cache.Get(key)
    local item = Cache.data[key]
    
    if not item then
        Cache.stats.misses = Cache.stats.misses + 1
        if Config.Debug then
            print(string.format('^3[CACHE] Miss: %s^0', key))
        end
        return nil
    end
    
    if item:isExpired() then
        Cache.data[key] = nil
        Cache.stats.misses = Cache.stats.misses + 1
        if Config.Debug then
            print(string.format('^3[CACHE] Expired: %s^0', key))
        end
        return nil
    end
    
    item:access()
    Cache.stats.hits = Cache.stats.hits + 1
    
    if Config.Debug then
        print(string.format('^2[CACHE] Hit: %s^0', key))
    end
    
    return DecompressValue(item.value)
end

function Cache.Remove(key)
    if Cache.data[key] then
        Cache.data[key] = nil
        if Config.Debug then
            print(string.format('^2[CACHE] Removed: %s^0', key))
        end
        return true
    end
    return false
end

function Cache.Clear(group)
    if group then
        for key, item in pairs(Cache.data) do
            if item.group == group then
                Cache.data[key] = nil
            end
        end
    else
        Cache.data = {}
    end
    
    if Config.Debug then
        print(string.format('^2[CACHE] Cleared%s^0', group and ': '..group or ''))
    end
end

function Cache.GetStats()
    local size = GetCacheSize()
    local hitRate = Cache.stats.hits / (Cache.stats.hits + Cache.stats.misses) * 100
    
    return {
        size = size,
        maxSize = Config.MaxCacheSize,
        hits = Cache.stats.hits,
        misses = Cache.stats.misses,
        evictions = Cache.stats.evictions,
        hitRate = hitRate
    }
end

-- Persistent Cache Management
local function SavePersistentCache()
    if not Config.PersistentCache.Enabled then return end
    
    local data = {}
    for key, item in pairs(Cache.data) do
        if item.priority >= Config.Priorities.HIGH then
            data[key] = {
                value = item.value,
                ttl = item.ttl,
                priority = item.priority,
                group = item.group
            }
        end
    end
    
    -- Save to file
    local file = io.open(Config.PersistentCache.SavePath..'cache.json', 'w')
    if file then
        file:write(json.encode(data))
        file:close()
    end
end

local function LoadPersistentCache()
    if not Config.PersistentCache.Enabled or not Config.PersistentCache.LoadOnStart then return end
    
    local file = io.open(Config.PersistentCache.SavePath..'cache.json', 'r')
    if file then
        local content = file:read('*all')
        file:close()
        
        local data = json.decode(content)
        for key, item in pairs(data) do
            Cache.Set(key, item.value, item.ttl, item.priority, item.group)
        end
    end
end

-- Cleanup Thread
CreateThread(function()
    while true do
        -- Remove expired items
        for key, item in pairs(Cache.data) do
            if item:isExpired() then
                Cache.data[key] = nil
            end
        end
        
        -- Save persistent cache
        if Config.PersistentCache.Enabled then
            SavePersistentCache()
        end
        
        Wait(Config.CleanupInterval * 1000)
    end
end)

-- Initialize
LoadPersistentCache()

-- Exports
exports('SetCache', Cache.Set)
exports('GetCache', Cache.Get)
exports('RemoveCache', Cache.Remove)
exports('ClearCache', Cache.Clear)
exports('GetCacheStats', Cache.GetStats)
