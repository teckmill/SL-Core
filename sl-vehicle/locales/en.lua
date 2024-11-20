local Translations = {
    error = {
        not_owner = 'You do not own this vehicle',
        no_vehicle = 'No vehicle nearby',
        not_in_vehicle = 'You are not in a vehicle',
        vehicle_locked = 'Vehicle is locked',
        vehicle_not_exist = 'Vehicle does not exist',
        no_permission = 'You do not have permission to do this'
    },
    success = {
        vehicle_locked = 'Vehicle locked',
        vehicle_unlocked = 'Vehicle unlocked',
        engine_started = 'Engine started',
        engine_stopped = 'Engine stopped',
        vehicle_stored = 'Vehicle stored',
        vehicle_retrieved = 'Vehicle retrieved'
    },
    info = {
        checking_vehicle = 'Checking vehicle...',
        storing_vehicle = 'Storing vehicle...',
        retrieving_vehicle = 'Retrieving vehicle...'
    },
    menu = {
        vehicle_options = 'Vehicle Options',
        toggle_engine = 'Toggle Engine',
        toggle_lock = 'Toggle Lock',
        check_status = 'Check Status',
        repair_vehicle = 'Repair Vehicle',
        clean_vehicle = 'Clean Vehicle',
        store_vehicle = 'Store Vehicle'
    }
}

Lang = Lang or {}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
