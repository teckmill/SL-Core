local Translations = {
    error = {
        not_enough_money = 'Not enough money in society account',
        no_access = 'You do not have access to this',
        invalid_amount = 'Invalid amount',
        invalid_id = 'Invalid ID',
        already_claimed = 'You have already claimed your paycheck',
        no_paycheck = 'No paycheck available',
    },
    success = {
        paycheck_received = 'You received your paycheck of $%{amount}',
        bonus_received = 'You received a bonus of $%{amount}',
        salary_set = 'Salary set to $%{amount} for grade %{grade}',
        bonus_set = 'Bonus set to $%{amount} for %{target}',
    },
    info = {
        paycheck_available = 'Your paycheck of $%{amount} is available',
        next_paycheck = 'Next paycheck in %{time}',
        society_balance = 'Society Balance: $%{amount}',
        employee_list = 'Employee List',
        salary_management = 'Salary Management',
        bonus_management = 'Bonus Management',
    },
    menu = {
        payroll = 'Payroll',
        collect_paycheck = 'Collect Paycheck',
        view_salary = 'View Salary',
        manage_salaries = 'Manage Salaries',
        manage_bonuses = 'Manage Bonuses',
        set_salary = 'Set Salary',
        give_bonus = 'Give Bonus',
        confirm = 'Confirm',
        cancel = 'Cancel',
        amount = 'Amount',
        grade = 'Grade',
        target = 'Target',
    },
    commands = {
        payroll = 'Open payroll menu',
        set_salary = 'Set salary for a job grade',
        give_bonus = 'Give bonus to a player',
    },
}

if GetConvar('sl_locale', 'en') == 'en' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = en
    })
end
