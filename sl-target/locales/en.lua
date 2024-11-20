local Translations = {
    error = {
        no_target = "No target available",
        too_far = "Target is too far away",
        invalid_type = "Invalid target type",
        missing_parameter = "Missing required parameter",
        not_authorized = "You are not authorized to do this"
    },
    success = {
        target_added = "Target added successfully",
        target_removed = "Target removed successfully",
        zone_created = "Zone created successfully"
    },
    info = {
        checking_target = "Checking target...",
        target_found = "Target found",
        no_options = "No options available"
    },
    menu = {
        close = "Close",
        select_option = "Select an option"
    }
}

if GetConvar('sl_locale', 'en') == 'en' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = 'en'
    })
end
