local SLCore = exports['sl-core']:GetCoreObject()
local Accounts = {}
local Transactions = {}
local CreditScores = {}
local Investments = {}
local Loans = {}

-- Initialize cache
CreateThread(function()
    MySQL.ready(function()
        -- Create tables if they don't exist
        local sqlFile = LoadResourceFile(GetCurrentResourceName(), 'sql/banking.sql')
        if sqlFile then
            -- Split and execute SQL statements individually
            for statement in sqlFile:gmatch("([^;]+);") do
                statement = statement:gsub("^%s+", ""):gsub("%s+$", "") -- Trim whitespace
                if statement ~= "" then
                    MySQL.Sync.execute(statement)
                end
            end
        end

        LoadAccounts()
        LoadInvestments()
        LoadLoans()
    end)
end)

-- Load all accounts from database
function LoadAccounts()
    local result = MySQL.query.await('SELECT * FROM bank_accounts WHERE frozen = ?', {0})
    if result then
        for _, account in ipairs(result) do
            Accounts[account.id] = {
                id = account.id,
                type = account.type,
                identifier = account.identifier,
                balance = account.balance,
                name = account.name,
                authorized = json.decode(account.authorized or '[]')
            }
            LoadTransactions(account.id, account.id)
        end
    end
end

-- Load investments
function LoadInvestments()
    local result = MySQL.query.await([[
        SELECT i.*, a.id 
        FROM bank_investments i 
        JOIN bank_accounts a ON i.account_id = a.id 
        WHERE i.status = 'active'
    ]])
    if result then
        for _, investment in ipairs(result) do
            if not Investments[investment.id] then
                Investments[investment.id] = {}
            end
            table.insert(Investments[investment.id], {
                id = investment.id,
                type = investment.type,
                amount = investment.amount,
                returnRate = investment.return_rate,
                startDate = investment.start_date
            })
        end
    end
end

-- Load loans
function LoadLoans()
    local result = MySQL.query.await([[
        SELECT l.*, a.id 
        FROM bank_loans l 
        JOIN bank_accounts a ON l.account_id = a.id 
        WHERE l.status IN ('pending', 'active')
    ]])
    if result then
        for _, loan in ipairs(result) do
            if not Loans[loan.id] then
                Loans[loan.id] = {}
            end
            table.insert(Loans[loan.id], {
                id = loan.id,
                type = loan.type,
                amount = loan.amount,
                interestRate = loan.interest_rate,
                termMonths = loan.term_months,
                remaining = loan.remaining_amount,
                status = loan.status,
                nextPayment = loan.next_payment_date
            })
        end
    end
end

-- Account Management
function CreateAccount(citizenId, accountType, pin)
    local success, result = MySQL.query.await('CALL create_bank_account(?, ?, ?)', 
        {citizenId, accountType, pin})
    
    if success and result[1] then
        local account = result[1]
        Accounts[account.id] = {
            id = account.id,
            type = account.type,
            identifier = account.identifier,
            balance = account.balance,
            name = account.name,
            authorized = json.decode(account.authorized or '[]')
        }
        return true, account.id
    end
    return false, "Failed to create account"
end

-- Transaction Processing
function ProcessTransaction(accountId, transactionType, amount, description)
    if not Accounts[accountId] then return false, "Account not found" end
    
    local account = Accounts[accountId]
    local success, result = MySQL.query.await('CALL process_transaction(?, ?, ?, ?, ?)',
        {account.id, transactionType, amount, description, nil})
    
    if success and result[1] then
        -- Update local cache
        account.balance = result[1].balance_after
        
        -- Update transactions cache
        if not Transactions[accountId] then Transactions[accountId] = {} end
        table.insert(Transactions[accountId], 1, result[1])
        
        -- Trim transaction history
        while #Transactions[accountId] > Config.UI.maxTransactionHistory do
            table.remove(Transactions[accountId])
        end
        
        -- Update credit score based on transaction
        UpdateCreditScore(account.id, transactionType, amount)
        
        return true, "Transaction successful"
    end
    return false, "Transaction failed"
end

-- Investment Management
function CreateInvestment(accountId, investmentType, amount)
    if not Accounts[accountId] then return false, "Account not found" end
    
    local account = Accounts[accountId]
    local success, result = MySQL.query.await('CALL create_investment(?, ?, ?)',
        {account.id, investmentType, amount})
    
    if success and result[1] then
        -- Update investments cache
        if not Investments[accountId] then
            Investments[accountId] = {}
        end
        table.insert(Investments[accountId], {
            id = result[1].id,
            type = result[1].type,
            amount = result[1].amount,
            returnRate = result[1].return_rate,
            startDate = result[1].start_date
        })
        return true, result[1]
    end
    return false, "Investment creation failed"
end

-- Loan Management
function RequestLoan(accountId, loanType, amount, termMonths)
    if not Accounts[accountId] then return false, "Account not found" end
    
    local account = Accounts[accountId]
    local success, result = MySQL.query.await('CALL request_loan(?, ?, ?, ?)',
        {account.id, loanType, amount, termMonths})
    
    if success and result[1] then
        -- Update loans cache
        if not Loans[accountId] then
            Loans[accountId] = {}
        end
        table.insert(Loans[accountId], {
            id = result[1].id,
            type = result[1].type,
            amount = result[1].amount,
            interestRate = result[1].interest_rate,
            termMonths = result[1].term_months,
            remaining = result[1].remaining_amount,
            status = result[1].status,
            nextPayment = result[1].next_payment_date
        })
        return true, result[1]
    end
    return false, "Loan request failed"
end

-- Credit Score Management
function UpdateCreditScore(accountId, transactionType, amount)
    local change = 0
    local reason = ""
    
    -- Calculate score change based on transaction type
    if transactionType == 'loan_payment' then
        change = Config.CreditScore.changes.onTimeLoanPayment
        reason = "On-time loan payment"
    elseif transactionType == 'withdraw' and amount > 1000 then
        change = Config.CreditScore.changes.largeWithdrawal
        reason = "Large withdrawal"
    end
    
    if change ~= 0 then
        MySQL.query.await('CALL update_credit_score(?, ?, ?)',
            {accountId, change, reason})
    end
end

-- Event Handlers
RegisterNetEvent('sl-banking:server:createAccount', function(data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    
    if Player then
        local success, result = CreateAccount(Player.PlayerData.citizenid, data.type, data.pin)
        TriggerClientEvent('sl-banking:client:accountCreated', src, success, result)
    end
end)

RegisterNetEvent('sl-banking:server:getAccounts', function()
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    
    if Player then
        local playerAccounts = {}
        for accountId, account in pairs(Accounts) do
            if account.identifier == Player.PlayerData.citizenid then
                table.insert(playerAccounts, {
                    id = accountId,
                    type = account.type,
                    balance = account.balance,
                    name = account.name
                })
            end
        end
        TriggerClientEvent('sl-banking:client:receiveAccounts', src, playerAccounts)
    end
end)

RegisterNetEvent('sl-banking:server:getTransactions', function(accountId)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    
    if Player and Accounts[accountId] and Accounts[accountId].identifier == Player.PlayerData.citizenid then
        TriggerClientEvent('sl-banking:client:receiveTransactions', src, Transactions[accountId] or {})
    end
end)

RegisterNetEvent('sl-banking:server:processTransaction', function(data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    
    if Player and Accounts[data.account] and Accounts[data.account].identifier == Player.PlayerData.citizenid then
        local success, result = ProcessTransaction(data.account, data.type, data.amount, data.description)
        TriggerClientEvent('sl-banking:client:transactionComplete', src, success, result)
    end
end)

-- Periodic Updates
CreateThread(function()
    while true do
        -- Update investment values
        for accountId, investments in pairs(Investments) do
            for _, investment in ipairs(investments) do
                local success, result = MySQL.query.await('CALL get_account_investments(?)',
                    {Accounts[accountId].id})
                if success and result[1] then
                    investment.currentValue = result[1].current_value
                end
            end
        end
        
        -- Process loan payments
        for accountId, loans in pairs(Loans) do
            for _, loan in ipairs(loans) do
                if loan.status == 'active' and os.time() >= loan.nextPayment then
                    local account = Accounts[accountId]
                    if account and account.balance >= loan.monthlyPayment then
                        ProcessTransaction(accountId, 'loan_payment', loan.monthlyPayment,
                            string.format("Automatic loan payment - ID: %d", loan.id))
                    else
                        -- Update credit score negatively for missed payment
                        UpdateCreditScore(account.id, -Config.CreditScore.changes.missedLoanPayment,
                            "Missed loan payment")
                    end
                end
            end
        end
        
        Wait(Config.UpdateInterval)
    end
end)
