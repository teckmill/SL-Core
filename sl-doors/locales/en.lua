local Translations = {
    error = {
        no_access = 'You do not have access to this door',
        already_locked = 'Door is already locked',
        already_unlocked = 'Door is already unlocked',
        no_keys = 'You do not have keys to this door',
        no_lockpick = 'You need a lockpick',
        lockpick_failed = 'Lockpicking failed',
        lockpick_broke = 'Your lockpick broke',
        too_far = 'You are too far from the door',
        door_not_found = 'Door not found',
        invalid_door_id = 'Invalid door ID',
        invalid_door_state = 'Invalid door state',
        max_keys = 'Maximum number of keys reached'
    },
    success = {
        door_locked = 'Door locked',
        door_unlocked = 'Door unlocked',
        lockpick_success = 'Successfully lockpicked',
        key_copied = 'Key copied successfully',
        key_given = 'Key given successfully',
        key_taken = 'Key taken successfully'
    },
    info = {
        checking_lock = 'Checking lock...',
        lockpicking = 'Lockpicking...',
        unlocking = 'Unlocking...',
        locking = 'Locking...',
        door_locked = 'Door is locked',
        door_unlocked = 'Door is unlocked',
        copying_key = 'Copying key...',
        giving_key = 'Giving key...',
        taking_key = 'Taking key...'
    },
    menu = {
        door_management = 'Door Management',
        manage_keys = 'Manage Keys',
        give_key = 'Give Key',
        take_key = 'Take Key',
        copy_key = 'Copy Key',
        change_lock = 'Change Lock',
        door_settings = 'Door Settings',
        confirm = 'Confirm',
        cancel = 'Cancel'
    }
}

if GetConvar('sl_locale', 'en') == 'en' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = 'en'
    })
end
