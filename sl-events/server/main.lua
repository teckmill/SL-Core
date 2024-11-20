local SL = exports['sl-core']:GetCoreObject()
local EventManager = {
    events = {},
    handlers = {},
    stats = {
        total = 0,
        handled = 0,
        dropped = 0,
        errors = 0
    }
}

-- Event Handler Class
local EventHandler = {}
EventHandler.__index = EventHandler

function EventHandler.new(name, callback, priority, group)
    local self = setmetatable({}, EventHandler)
    self.name = name
    self.callback = callback
    self.priority = priority or Config.Priorities.MEDIUM
    self.group = group
    self.created = os.time()
    self.lastCalled = 0
    self.callCount = 0
    return self
end

function EventHandler:call(...)
    self.lastCalled = os.time()
    self.callCount = self.callCount + 1
    return self.callback(...)
end

-- Event Management Functions
local function ValidateEvent(name, data)
    if not name or type(name) ~= 'string' then
        return false, 'Invalid event name'
    end
    
    if Config.Filtering.Enabled then
        for _, blacklisted in ipairs(Config.Filtering.BlacklistedEvents) do
            if name == blacklisted then
                return false, 'Event is blacklisted'
            end
        end
    end
    
    return true
end

local function LogEvent(name, data, result)
    if not Config.Logging.Enabled then return end
    
    local logEntry = {
        timestamp = os.time(),
        name = name,
        data = data,
        result = result
    }
    
    if Config.Logging.LogToFile then
        -- Implement file logging
    end
    
    if Config.Logging.LogToConsole then
        print(string.format('[EVENT] %s: %s', name, json.encode(logEntry)))
    end
end

-- Event Batching
local BatchQueue = {
    events = {},
    timer = nil
}

local function ProcessBatch()
    if #BatchQueue.events == 0 then return end
    
    for _, event in ipairs(BatchQueue.events) do
        local handlers = EventManager.handlers[event.name] or {}
        
        -- Sort handlers by priority
        table.sort(handlers, function(a, b)
            return a.priority > b.priority
        end)
        
        -- Call handlers
        for _, handler in ipairs(handlers) do
            local success, result = pcall(handler.call, handler, table.unpack(event.args))
            if not success then
                EventManager.stats.errors = EventManager.stats.errors + 1
                print(string.format('^1[ERROR] Event handler error for %s: %s^0', event.name, result))
            end
        end
        
        EventManager.stats.handled = EventManager.stats.handled + 1
    end
    
    BatchQueue.events = {}
    BatchQueue.timer = nil
end

-- Public Event API
function EventManager.On(name, callback, priority, group)
    if not EventManager.handlers[name] then
        EventManager.handlers[name] = {}
    end
    
    if #EventManager.handlers[name] >= Config.MaxEventHandlers then
        return false, 'Maximum handlers reached for event'
    end
    
    local handler = EventHandler.new(name, callback, priority, group)
    table.insert(EventManager.handlers[name], handler)
    
    return true
end

function EventManager.Off(name, callback)
    if not EventManager.handlers[name] then return false end
    
    for i, handler in ipairs(EventManager.handlers[name]) do
        if handler.callback == callback then
            table.remove(EventManager.handlers[name], i)
            return true
        end
    end
    
    return false
end

function EventManager.Emit(name, ...)
    EventManager.stats.total = EventManager.stats.total + 1
    
    local valid, error = ValidateEvent(name)
    if not valid then
        EventManager.stats.dropped = EventManager.stats.dropped + 1
        return false, error
    end
    
    if Config.Batching.Enabled then
        table.insert(BatchQueue.events, {
            name = name,
            args = {...},
            timestamp = os.time()
        })
        
        if #BatchQueue.events >= Config.Batching.BatchSize or not BatchQueue.timer then
            if BatchQueue.timer then
                KillTimer(BatchQueue.timer)
            end
            BatchQueue.timer = SetTimeout(Config.Batching.BatchTimeout, ProcessBatch)
        end
        
        return true
    else
        local handlers = EventManager.handlers[name] or {}
        
        -- Sort handlers by priority
        table.sort(handlers, function(a, b)
            return a.priority > b.priority
        end)
        
        -- Call handlers
        for _, handler in ipairs(handlers) do
            local success, result = pcall(handler.call, handler, ...)
            if not success then
                EventManager.stats.errors = EventManager.stats.errors + 1
                print(string.format('^1[ERROR] Event handler error for %s: %s^0', name, result))
            end
        end
        
        EventManager.stats.handled = EventManager.stats.handled + 1
        return true
    end
end

function EventManager.GetStats()
    return {
        total = EventManager.stats.total,
        handled = EventManager.stats.handled,
        dropped = EventManager.stats.dropped,
        errors = EventManager.stats.errors,
        handlers = #EventManager.handlers
    }
end

-- Rate Limiting
local RateLimiter = {
    events = {},
    window = Config.RateLimit.TimeWindow
}

function RateLimiter.Check(name)
    if not Config.RateLimit.Enabled then return true end
    
    local now = os.time()
    RateLimiter.events[name] = RateLimiter.events[name] or {}
    
    -- Clean old events
    local count = 0
    for i = #RateLimiter.events[name], 1, -1 do
        if now - RateLimiter.events[name][i] > RateLimiter.window then
            table.remove(RateLimiter.events[name], i)
        else
            count = count + 1
        end
    end
    
    if count >= Config.RateLimit.MaxEventsPerSecond then
        return false
    end
    
    table.insert(RateLimiter.events[name], now)
    return true
end

-- Exports
exports('On', EventManager.On)
exports('Off', EventManager.Off)
exports('Emit', EventManager.Emit)
exports('GetStats', EventManager.GetStats)
