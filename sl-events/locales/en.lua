local Translations = {
    error = {
        event_not_found = "Event not found",
        invalid_event = "Invalid event name",
        missing_handler = "Event handler not found",
        rate_limited = "Too many event calls",
    },
    success = {
        event_registered = "Event registered successfully",
        event_triggered = "Event triggered successfully",
        handler_added = "Event handler added successfully",
    },
    info = {
        event_stats = "Event statistics",
        active_handlers = "Active event handlers",
        event_queue = "Event queue status",
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
