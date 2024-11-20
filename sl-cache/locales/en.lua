local Translations = {
    error = {
        cache_miss = "Cache miss: Item not found",
        cache_full = "Cache is full",
        invalid_key = "Invalid cache key provided",
        expired = "Cache item has expired",
    },
    success = {
        cache_hit = "Cache hit: Item found",
        cache_set = "Item successfully cached",
        cache_clear = "Cache cleared successfully",
    },
    info = {
        cache_size = "Current cache size",
        cache_stats = "Cache statistics",
        ttl_remaining = "Time remaining until expiration",
    }
}

CreateThread(function()
    while GetResourceState('sl-core') ~= 'started' do
        Wait(100)
    end
    
    local Core = exports['sl-core']:GetCoreObject()
    if Core.Shared.Locale then
        Core.Shared.Locale('en', Translations)
    end
end)
