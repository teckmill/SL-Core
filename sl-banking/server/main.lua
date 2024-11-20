local SLCore = exports['sl-core']:GetCoreObject()
local Accounts = {}
local Transactions = {}
local CreditScores = {}
local Investments = {}
local Loans = {}

-- Database initialization
CreateThread(function()
    -- Load SQL schema and functions
    local schema = LoadResourceFile(GetCurrentResourceName(), 'sql/schema.sql')
    local functions = LoadResourceFile(GetCurrentResourceName(), 'sql/functions.sql')
    
    -- Execute schema and functions
    MySQL.query(schema)
    MySQL.query(functions)
    
    -- Initialize cache
    LoadAccounts()
    LoadInvestments()
    LoadLoans()
end)

-- Load all accounts from database
function LoadAccounts()
    local result = MySQL.query.await('SELECT * FROM sl_bank_accounts WHERE status = ?', {'active'})
    if result then
        for _, account in ipairs(result) do
            Accounts[account.account_number] = {
                id = account.id,
                type = account.type,
                owner = account.owner_identifier,
                balance = account.balance,
                pin = account.pin,
                creditScore = account.credit_score,
                status = account.status
            }
            LoadTransactions(account.id, account.account_number)
        end
    end
end

-- Load investments
function LoadInvestments()
    local result = MySQL.query.await([[
        SELECT i.*, a.account_number 
        FROM sl_bank_investments i 
        JOIN sl_bank_accounts a ON i.account_id = a.id 
        WHERE i.status = 'active'
    ]])
    if result then
        for _, investment in ipairs(result) do
            if not Investments[investment.account_number] then
                Investments[investment.account_number] = {}
            end
            table.insert(Investments[investment.account_number], {
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
        SELECT l.*, a.account_number 
        FROM sl_bank_loans l 
        JOIN sl_bank_accounts a ON l.account_id = a.id 
        WHERE l.status IN ('pending', 'active')
    ]])
    if result then
        for _, loan in ipairs(result) do
            if not Loans[loan.account_number] then
                Loans[loan.account_number] = {}
            end
            table.insert(Loans[loan.account_number], {
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
        Accounts[account.account_number] = {
            id = account.id,
            type = account.type,
            owner = account.owner_identifier,
            balance = account.balance,
            pin = account.pin,
            creditScore = account.credit_score,
            status = account.status
        }
        return true, account.account_number
    end
    return false, "Failed to create account"
end

-- Transaction Processing
function ProcessTransaction(accountNumber, transactionType, amount, description)
    if not Accounts[accountNumber] then return false, "Account not found" end
    
    local account = Accounts[accountNumber]
    local success, result = MySQL.query.await('CALL process_transaction(?, ?, ?, ?, ?)',
        {account.id, transactionType, amount, description, nil})
    
    if success and result[1] then
        -- Update local cache
        account.balance = result[1].balance_after
        
        -- Update transactions cache
        if not Transactions[accountNumber] then Transactions[accountNumber] = {} end
        table.insert(Transactions[accountNumber], 1, result[1])
        
        -- Trim transaction history
        while #Transactions[accountNumber] > Config.UI.maxTransactionHistory do
            table.remove(Transactions[accountNumber])
        end
        
        -- Update credit score based on transaction
        UpdateCreditScore(account.id, transactionType, amount)
        
        return true, "Transaction successful"
    end
    return false, "Transaction failed"
end

-- Investment Management
function CreateInvestment(accountNumber, investmentType, amount)
    if not Accounts[accountNumber] then return false, "Account not found" end
    
    local account = Accounts[accountNumber]
    local success, result = MySQL.query.await('CALL create_investment(?, ?, ?)',
        {account.id, investmentType, amount})
    
    if success and result[1] then
        -- Update investments cache
        if not Investments[accountNumber] then
            Investments[accountNumber] = {}
        end
        table.insert(Investments[accountNumber], {
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
function RequestLoan(accountNumber, loanType, amount, termMonths)
    if not Accounts[accountNumber] then return false, "Account not found" end
    
    local account = Accounts[accountNumber]
    local success, result = MySQL.query.await('CALL request_loan(?, ?, ?, ?)',
        {account.id, loanType, amount, termMonths})
    
    if success and result[1] then
        -- Update loans cache
        if not Loans[accountNumber] then
            Loans[accountNumber] = {}
        end
        table.insert(Loans[accountNumber], {
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
        for accountNumber, account in pairs(Accounts) do
            if account.owner == Player.PlayerData.citizenid then
                table.insert(playerAccounts, {
                    number = accountNumber,
                    type = account.type,
                    balance = account.balance,
                    status = account.status
                })
            end
        end
        TriggerClientEvent('sl-banking:client:receiveAccounts', src, playerAccounts)
    end
end)

RegisterNetEvent('sl-banking:server:getTransactions', function(accountNumber)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    
    if Player and Accounts[accountNumber] and Accounts[accountNumber].owner == Player.PlayerData.citizenid then
        TriggerClientEvent('sl-banking:client:receiveTransactions', src, Transactions[accountNumber] or {})
    end
end)

RegisterNetEvent('sl-banking:server:processTransaction', function(data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    
    if Player and Accounts[data.account] and Accounts[data.account].owner == Player.PlayerData.citizenid then
        local success, result = ProcessTransaction(data.account, data.type, data.amount, data.description)
        TriggerClientEvent('sl-banking:client:transactionComplete', src, success, result)
    end
end)

-- Periodic Updates
CreateThread(function()
    while true do
        -- Update investment values
        for accountNumber, investments in pairs(Investments) do
            for _, investment in ipairs(investments) do
                local success, result = MySQL.query.await('CALL get_account_investments(?)',
                    {Accounts[accountNumber].id})
                if success and result[1] then
                    investment.currentValue = result[1].current_value
                end
            end
        end
        
        -- Process loan payments
        for accountNumber, loans in pairs(Loans) do
            for _, loan in ipairs(loans) do
                if loan.status == 'active' and os.time() >= loan.nextPayment then
                    local account = Accounts[accountNumber]
                    if account and account.balance >= loan.monthlyPayment then
                        ProcessTransaction(accountNumber, 'loan_payment', loan.monthlyPayment,
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
