local Translations = {
    error = {
        not_online = 'Player is not online',
        wrong_format = 'Incorrect format',
        missing_args = 'Not every argument has been entered (x, y, z)',
        missing_args2 = 'All arguments must be filled out!',
        no_access = 'No access to this command',
        company_too_poor = 'Your employer is broke',
        item_not_exist = 'Item does not exist',
        too_heavy = 'Inventory is too full',
        duplicate_license = 'Duplicate Rockstar License Found',
        no_valid_license = 'No Valid Rockstar License Found',
        not_whitelisted = 'You\'re not whitelisted for this server'
    },
    success = {
        received_paycheck = 'You received your paycheck of $%{value}',
        job_new = 'New job: %{value}!',
        joined_society = 'You joined %{value}!',
        left_society = 'You left %{value}!',
        created_society = 'You created %{value}!',
        deleted_society = 'You deleted %{value}!'
    },
    info = {
        received_salary = 'You have received your salary of: $%{value}',
        society_exists = 'A society with this name already exists',
        society_doesnt_exist = 'This society does not exist',
        society_not_enough_money = 'Your society doesn\'t have enough money for this action',
        society_name_too_short = 'Society name is too short',
        society_name_too_long = 'Society name is too long'
    },
    command = {
        society = {
            help = 'Create or manage societies',
            params = {
                action = { name = 'action', help = 'The action to perform (create/delete/join/leave)' },
                name = { name = 'name', help = 'The name of the society' }
            }
        }
    }
}

if GetConvar('qb_locale', 'en') == 'en' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
