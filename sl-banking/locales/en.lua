local Translations = {
    error = {
        not_enough_money = 'Not enough money in account',
        invalid_amount = 'Invalid amount',
        invalid_account = 'Invalid account',
        bank_closed = 'Bank is currently closed',
        too_many_transactions = 'Too many recent transactions',
        transfer_error = 'Error during transfer',
        daily_limit = 'Daily transfer limit reached',
        no_access = 'No access to this account'
    },
    success = {
        withdraw_success = 'Successfully withdrew $%{value}',
        deposit_success = 'Successfully deposited $%{value}',
        transfer_success = 'Successfully transferred $%{value} to %{account}',
        account_opened = 'Successfully opened new account',
        account_closed = 'Successfully closed account'
    },
    info = {
        bank_balance = 'Bank Balance: $%{value}',
        cash_balance = 'Cash Balance: $%{value}',
        transaction_history = 'Transaction History',
        account_details = 'Account Details',
        daily_limit_info = 'Daily Transfer Limit: $%{value}'
    },
    menu = {
        withdraw = 'Withdraw',
        deposit = 'Deposit',
        transfer = 'Transfer',
        accounts = 'Accounts',
        transactions = 'Transactions',
        settings = 'Settings'
    }
}

if GetConvar('qb_locale', 'en') == 'en' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
