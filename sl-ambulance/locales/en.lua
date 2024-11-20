local Translations = {
    error = {
        not_enough_money = 'Not enough money',
        canceled = 'Canceled',
        ems_unavailable = 'EMS is currently unavailable',
        not_ems = 'You are not EMS',
        no_player = 'Player not found',
        no_firstaid = 'You need a first aid kit',
        cant_heal = 'You cannot heal yourself',
        already_helping = 'You are already helping someone',
        not_dead = 'Player is not dead',
        already_dead = 'Player is already dead'
    },
    success = {
        revived = 'You revived a person',
        healed = 'You healed a person',
        received_treatment = 'You received treatment'
    },
    info = {
        revive_player = 'Revive Player',
        heal_player = 'Heal Player',
        call_ems = 'Call EMS',
        ems_alert = 'EMS Alert',
        ems_message = 'Medical assistance required at',
        checking_player = 'Checking Player',
        being_helped = 'You are being helped',
        player_dead = 'You are dead',
        respawn_available = 'You can now respawn',
        death_notice = 'You died',
        respawn_notice = 'Press [E] to respawn at the hospital for $%{cost}',
        distress_send = 'Press [G] to send a distress signal',
        distress_signal = 'Distress signal received from',
        injury_message = 'Due to the injuries you\'ve sustained, you feel',
        wake_up_message = 'You\'re starting to feel better..',
        wounds_healed = 'Your wounds have been healed!',
        bleeding_stopped = 'The bleeding has been stopped',
        received_help = 'You are receiving help!',
        helped_player = 'You helped a player',
        doctor_required = 'A doctor is required at',
        ems_notif = 'EMS Notification',
        mr = 'Mr.',
        mrs = 'Mrs.',
        dr_needed = 'Doctor needed at Pillbox Hospital'
    },
    menu = {
        check_health = 'Check Health',
        revive = 'Revive',
        heal = 'Heal',
        status = 'Health Status'
    }
}

Lang = Lang or {}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
