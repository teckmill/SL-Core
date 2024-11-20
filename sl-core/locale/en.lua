local Translations = {
    error = {
        not_online = 'Player not online',
        wrong_format = 'Incorrect format',
        missing_args = 'Not every argument has been entered (x, y, z)',
        missing_args2 = 'All arguments must be filled out!',
        no_access = 'No access to this command',
        company_too_poor = 'Your employer is broke',
        item_not_exist = 'Item does not exist',
        too_heavy = 'Inventory too full',
        duplicate_license = 'Duplicate Rockstar License Found',
        no_valid_license  = 'No Valid Rockstar License Found',
        not_whitelisted = 'You\'re not whitelisted for this server'
    },
    success = {
        spawned_car = 'Spawned a car',
        job_paid = 'You got paid $%{value}',
        item_added = '%{value} added to inventory',
        money_added = '$%{value} added to %{type}',
        money_removed = '$%{value} removed from %{type}'
    },
    info = {
        received_paycheck = 'You received your paycheck of $%{value}',
        job_info = 'Job: %{value} | Grade: %{value2} | Duty: %{value3}',
        gang_info = 'Gang: %{value} | Grade: %{value2}',
        on_duty = 'You are now on duty!',
        off_duty = 'You are now off duty!',
        checking_ban = 'Hello %s. We are checking if you are banned.',
        join_server = 'Welcome %s to {Server Name}.',
        checking_whitelisted = 'Hello %s. We are checking your allowance.',
        exploit_banned = 'You have been banned for cheating. Check our Discord for more information: %{discord}',
        exploit_dropped = 'You have been kicked for exploitation'
    },
    command = {
        tp = 'TP To Player or Coords (Admin Only)',
        car = 'Spawn Vehicle (Admin Only)',
        dv = 'Delete Vehicle (Admin Only)',
        givemoney = 'Give Money To A Player (Admin Only)',
        setjob = 'Set A Players Job (Admin Only)',
        setgang = 'Set A Players Gang (Admin Only)',
        addpermission = 'Give Player Permissions (God Only)',
        removepermission = 'Remove Player Permissions (God Only)',
        kill = 'Kill A Player (Admin Only)',
        revive = 'Revive A Player (Admin Only)',
        setmodel = 'Set Player Model (Admin Only)',
        noclip = 'Toggle Noclip (Admin Only)'
    }
}

if GetConvar('sl_locale', 'en') == 'en' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
