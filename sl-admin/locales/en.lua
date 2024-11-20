local Translations = {
    error = {
        not_online = 'Player is not online',
        no_permission = 'You do not have permission for this action',
        invalid_id = 'Invalid player ID',
        invalid_amount = 'Invalid amount specified',
        player_not_found = 'Player not found',
        cant_target_self = 'You cannot target yourself',
        cooldown = 'Please wait before doing this again',
        report_too_short = 'Report message is too short',
        report_too_long = 'Report message is too long',
        already_spectating = 'You are already spectating someone',
        not_spectating = 'You are not spectating anyone',
        target_in_noclip = 'Target player is in noclip',
        invalid_vehicle = 'Invalid vehicle model',
        invalid_weather = 'Invalid weather type',
        invalid_time = 'Invalid time format',
        invalid_coords = 'Invalid coordinates',
        no_reports = 'No active reports',
        report_closed = 'Report has been closed',
        already_banned = 'Player is already banned',
        not_banned = 'Player is not banned',
        ban_exempt = 'Cannot ban this player',
        invalid_item = 'Invalid item specified',
        inventory_error = 'Could not open inventory',
        dev_mode_error = 'Developer mode error',
    },
    success = {
        player_banned = 'Player has been banned',
        player_kicked = 'Player has been kicked',
        player_healed = 'Player has been healed',
        player_revived = 'Player has been revived',
        teleported = 'Successfully teleported',
        vehicle_spawned = 'Vehicle has been spawned',
        vehicle_fixed = 'Vehicle has been fixed',
        vehicle_deleted = 'Vehicle has been deleted',
        weather_updated = 'Weather has been updated',
        time_updated = 'Time has been updated',
        announcement_sent = 'Announcement has been sent',
        report_submitted = 'Report has been submitted',
        report_claimed = 'Report has been claimed',
        report_resolved = 'Report has been resolved',
        player_warned = 'Player has been warned',
        warnings_cleared = 'Warnings have been cleared',
        noclip_enabled = 'Noclip enabled',
        noclip_disabled = 'Noclip disabled',
        godmode_enabled = 'God mode enabled',
        godmode_disabled = 'God mode disabled',
        invisible_enabled = 'Invisibility enabled',
        invisible_disabled = 'Invisibility disabled',
        item_given = 'Item has been given',
        inventory_opened = 'Inventory opened',
        dev_mode_enabled = 'Developer mode enabled',
        dev_mode_disabled = 'Developer mode disabled',
    },
    info = {
        received_report = 'New report received from %s: %s',
        spectating = 'Spectating %s',
        stopped_spectating = 'Stopped spectating %s',
        coords_copied = 'Coordinates copied to clipboard',
        spawning_vehicle = 'Spawning vehicle: %s',
        god_mode = 'God Mode: %s',
        noclip = 'Noclip: %s',
        current_speed = 'Current Speed: %s',
        teleporting = 'Teleporting to location...',
        teleporting_player = 'Teleporting to player...',
        teleporting_to_coords = 'Teleporting to coordinates...',
        player_frozen = 'Player has been frozen',
        player_unfrozen = 'Player has been unfrozen',
        being_spectated = 'An admin is spectating you',
        dev_mode = 'Developer Mode: %s',
        coords_info = 'X: %s, Y: %s, Z: %s, H: %s',
        entity_info = 'Entity: %s, Model: %s, Type: %s',
        vehicle_info = 'Vehicle: %s, Speed: %s, Health: %s',
    },
    menu = {
        admin_menu = 'Admin Menu',
        admin_options = 'Admin Options',
        player_management = 'Player Management',
        vehicle_spawner = 'Vehicle Spawner',
        server_management = 'Server Management',
        developer_tools = 'Developer Tools',
        online_players = 'Online Players',
        weather_options = 'Weather Options',
        time_options = 'Time Options',
        reports = 'Player Reports',
        teleport_menu = 'Teleport Menu',
        settings = 'Admin Settings',
        player_options = 'Options for %s',
        noclip = 'Toggle Noclip',
        godmode = 'Toggle God Mode',
        invisible = 'Toggle Invisibility',
        names = 'Toggle Names',
        blips = 'Toggle Blips',
        coords = 'Toggle Coords',
        dev_mode = 'Toggle Dev Mode',
        kill = 'Kill Player',
        revive = 'Revive Player',
        freeze = 'Freeze Player',
        spectate = 'Spectate Player',
        goto = 'Go to Player',
        bring = 'Bring Player',
        sit_vehicle = 'Sit in Vehicle',
        open_inv = 'Open Inventory',
    },
    commands = {
        noclip = 'Toggle noclip mode',
        fix = 'Fix vehicle',
        car = 'Spawn a vehicle',
        dv = 'Delete vehicle',
        tp = 'Teleport to player or coords',
        bring = 'Bring player to you',
        gotoplayer = 'Go to player',
        freeze = 'Freeze/unfreeze player',
        ban = 'Ban a player',
        unban = 'Unban a player',
        kick = 'Kick a player',
        warn = 'Warn a player',
        clearwarns = 'Clear player warnings',
        setjob = 'Set player job',
        report = 'Submit a report',
        reports = 'View active reports',
        admin = 'Open admin menu',
        givemoney = 'Give money to player',
        giveitem = 'Give item to player',
        weather = 'Set weather',
        time = 'Set time',
    },
    progress = {
        checking_ban = 'Checking ban status...',
        saving_ban = 'Saving ban data...',
        updating_weather = 'Updating weather...',
        spawning_vehicle = 'Spawning vehicle...',
        teleporting = 'Teleporting...',
        loading_inventory = 'Loading inventory...',
    },
    logs = {
        player_banned = '**Admin Action:** Ban\n**Admin:** %s\n**Player:** %s\n**Reason:** %s\n**Duration:** %s',
        player_kicked = '**Admin Action:** Kick\n**Admin:** %s\n**Player:** %s\n**Reason:** %s',
        player_revived = '**Admin Action:** Revive\n**Admin:** %s\n**Player:** %s',
        admin_goto = '**Admin Action:** Goto\n**Admin:** %s\n**Player:** %s',
        admin_bring = '**Admin Action:** Bring\n**Admin:** %s\n**Player:** %s',
        item_given = '**Admin Action:** Give Item\n**Admin:** %s\n**Player:** %s\n**Item:** %s\n**Amount:** %s',
        vehicle_spawned = '**Admin Action:** Vehicle Spawn\n**Admin:** %s\n**Vehicle:** %s',
        vehicle_deleted = '**Admin Action:** Vehicle Delete\n**Admin:** %s',
        weather_changed = '**Admin Action:** Weather Change\n**Admin:** %s\n**Weather:** %s',
        time_changed = '**Admin Action:** Time Change\n**Admin:** %s\n**Time:** %s',
        inventory_opened = '**Admin Action:** Open Inventory\n**Admin:** %s\n**Player:** %s',
        report_submitted = '**Report:** New\n**Player:** %s\n**Message:** %s',
        report_closed = '**Report:** Closed\n**Admin:** %s\n**Player:** %s',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
