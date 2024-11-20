local Translations = {
    error = {
        no_phone = 'You don\'t have a phone',
        phone_off = 'Your phone is turned off',
        no_signal = 'No signal',
        number_invalid = 'Invalid phone number',
        contact_exists = 'Contact already exists',
        contact_not_found = 'Contact not found',
        message_too_long = 'Message is too long',
        invalid_app = 'This app is not installed',
        no_access = 'You don\'t have access to this',
        battery_low = 'Phone battery is too low'
    },
    success = {
        phone_on = 'Phone turned on',
        phone_off = 'Phone turned off',
        contact_added = 'Contact added',
        contact_removed = 'Contact removed',
        message_sent = 'Message sent',
        app_installed = 'App installed',
        app_uninstalled = 'App uninstalled'
    },
    info = {
        phone_notification = 'Phone Notification',
        new_message = 'New Message',
        missed_call = 'Missed Call',
        battery_level = 'Battery Level: %{value}%',
        signal_strength = 'Signal Strength: %{value}%'
    }
}

if GetConvar('qb_locale', 'en') == 'en' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
