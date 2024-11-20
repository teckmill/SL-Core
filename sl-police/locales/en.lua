local Translations = {
    error = {
        not_enough_money = 'Not enough money',
        canceled = 'Canceled',
        no_player = 'Player not found',
        not_police = 'You are not police',
        no_permission = 'You do not have permission for this',
        already_cuffed = 'Player is already cuffed',
        not_cuffed = 'Player is not cuffed',
        no_weapon = 'No weapon to remove',
        no_evidence = 'No evidence found',
        no_tracker = 'No tracker found',
        already_tracked = 'Person is already being tracked'
    },
    success = {
        uncuffed = 'You have been uncuffed',
        cuffed = 'You have been cuffed',
        weapon_removed = 'Weapon has been removed',
        evidence_taken = 'Evidence has been collected',
        tracker_placed = 'Tracker has been placed',
        fingerprint_taken = 'Fingerprints have been taken'
    },
    info = {
        mr = 'Mr.',
        mrs = 'Mrs.',
        duty = 'On/Off Duty',
        onduty = 'You are now on duty!',
        offduty = 'You are now off duty!',
        taking_fingerprint = 'Taking fingerprints...',
        placing_tracker = 'Placing tracker...',
        removing_tracker = 'Removing tracker...',
        checking_evidence = 'Checking evidence...',
        searching_person = 'Searching person...',
        removing_weapon = 'Removing weapon...',
        cuffing = 'Cuffing suspect...',
        uncuffing = 'Uncuffing suspect...',
        police_notification = 'Police Notification',
        police_message = 'Assistance required at',
        evidence_seized = 'Evidence seized',
        tracker_active = 'Tracker active',
        suspect_custody = 'Suspect in custody',
        vehicle_impounded = 'Vehicle impounded',
        fine_issued = 'Fine issued'
    },
    menu = {
        police_interactions = 'Police Interactions',
        citizen_interactions = 'Citizen Interactions',
        vehicle_interactions = 'Vehicle Interactions',
        object_interactions = 'Object Interactions',
        cuff_uncuff = 'Cuff/Uncuff',
        escort = 'Escort',
        search = 'Search',
        put_in_vehicle = 'Put in Vehicle',
        out_vehicle = 'Take out of Vehicle',
        impound = 'Impound Vehicle',
        check_vehicle = 'Check Vehicle',
        check_status = 'Check Status',
        check_records = 'Check Records',
        take_fingerprint = 'Take Fingerprint',
        place_object = 'Place Object',
        remove_object = 'Remove Object',
        place_tracker = 'Place Tracker',
        remove_tracker = 'Remove Tracker'
    }
}

Lang = Lang or {}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
