local Translations = {
    error = {
        spawn_not_found = "Spawn location not found",
        invalid_spawn = "Invalid spawn point selected",
        spawn_blocked = "This spawn point is currently blocked",
        no_permissions = "You don't have permission to spawn here",
        loading_character = "Error loading character data",
        spawn_limit = "Too many players at this spawn point",
    },
    success = {
        spawned_at = "You have spawned at %{location}",
        character_loaded = "Character loaded successfully",
    },
    info = {
        selecting_spawn = "Selecting spawn location...",
        loading_character = "Loading character...",
        welcome_back = "Welcome back, %{name}!",
        choose_spawn = "Choose where to begin your journey",
        last_location = "Last Location",
        new_character = "New Character",
        spawn_loading = "Loading spawn location...",
    },
    menu = {
        spawn_selection = "Spawn Selection",
        last_location = "Last Location",
        apartments = "Apartments",
        hotels = "Hotels",
        locations = "Locations",
        confirm_spawn = "Confirm Spawn",
        cancel = "Cancel",
        back = "Back",
    },
    ui = {
        weather = "Weather: %{weather}",
        time = "Time: %{time}",
        population = "Population: %{count}",
        distance = "Distance: %{distance}m",
    }
}

if GetConvar('qb_locale', 'en') == 'en' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
