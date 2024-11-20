local SLCore = exports['sl-core']:GetCoreObject()
local Accounts = {}
local Transactions = {}
local CreditScores = {}
local Investments = {}
local Loans = {}

-- Database initialization
CreateThread(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS sl_bank_accounts (
            id INT AUTO_INCREMENT PRIMARY KEY,
            account_number VARCHAR(20) NOT NULL UNIQUE,
            account_type VARCHAR(50) NOT NULL,
            owner VARCHAR(50) NOT NULL,
            balance DECIMAL(15,2) DEFAULT 0,
            pin VARCHAR(255),
            daily_limit DECIMAL(15,2),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            status VARCHAR(20) DEFAULT 'active'
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS sl_bank_transactions (
            id INT AUTO_INCREMENT PRIMARY KEY,
            account_id INT NOT NULL,
            type VARCHAR(50) NOT NULL,
            amount DECIMAL(15,2) NOT NULL,
            balance DECIMAL(15,2) NOT NULL,
            description TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (account_id) REFERENCES sl_bank_accounts(id)
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS sl_credit_scores (
            id INT AUTO_INCREMENT PRIMARY KEY,
            citizen_id VARCHAR(50) NOT NULL UNIQUE,
            score INT DEFAULT 650,
            payment_history DECIMAL(5,2) DEFAULT 100,
            credit_usage DECIMAL(5,2) DEFAULT 0,
            credit_age INT DEFAULT 0,
            last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS sl_loans (
            id INT AUTO_INCREMENT PRIMARY KEY,
            account_id INT NOT NULL,
            type VARCHAR(50) NOT NULL,
            amount DECIMAL(15,2) NOT NULL,
            interest_rate DECIMAL(5,4) NOT NULL,
            term INT NOT NULL,
            remaining_payments INT NOT NULL,
            monthly_payment DECIMAL(15,2) NOT NULL,
            status VARCHAR(20) DEFAULT 'active',
            next_payment TIMESTAMP,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (account_id) REFERENCES sl_bank_accounts(id)
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS sl_investments (
            id INT AUTO_INCREMENT PRIMARY KEY,
            account_id INT NOT NULL,
            type VARCHAR(50) NOT NULL,
            amount DECIMAL(15,2) NOT NULL,
            shares DECIMAL(15,6) NOT NULL,
            purchase_price DECIMAL(15,2) NOT NULL,
            current_price DECIMAL(15,2) NOT NULL,
            status VARCHAR(20) DEFAULT 'active',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (account_id) REFERENCES sl_bank_accounts(id)
        )
    ]])

    LoadAccounts()
end)

-- Load all accounts from database
function LoadAccounts()
    local result = MySQL.query.await('SELECT * FROM sl_bank_accounts WHERE status = ?', {'active'})
    if result then
        for _, account in ipairs(result) do
            Accounts[account.account_number] = {
                id = account.id,
                type = account.account_type,
                owner = account.owner,
                balance = account.balance,
                pin = account.pin,
                dailyLimit = account.daily_limit,
                status = account.status
            }
            LoadTransactions(account.id, account.account_number)
        end
    end
end

-- Load transactions for an account
function LoadTransactions(accountId, accountNumber)
    local result = MySQL.query.await('SELECT * FROM sl_bank_transactions WHERE account_id = ? ORDER BY created_at DESC LIMIT ?',
        {accountId, Config.UI.maxTransactionHistory})
    if result then
        Transactions[accountNumber] = result
    end
end

-- Account Management Functions
function CreateAccount(citizenId, accountType, pin)
    if not Config.AccountTypes[accountType] then return false, "Invalid account type" end
    
    local accountNumber = GenerateAccountNumber()
    local accountConfig = Config.AccountTypes[accountType]
    
    local success = MySQL.insert.await('INSERT INTO sl_bank_accounts (account_number, account_type, owner, pin, daily_limit) VALUES (?, ?, ?, ?, ?)',
        {accountNumber, accountType, citizenId, pin, accountConfig.dailyLimit})
    
    if success then
        Accounts[accountNumber] = {
            id = success,
            type = accountType,
            owner = citizenId,
            balance = 0,
            pin = pin,
            dailyLimit = accountConfig.dailyLimit,
            status = 'active'
        }
        return true, accountNumber
    end
    return false, "Failed to create account"
end

-- Transaction Functions
function AddTransaction(accountNumber, transactionType, amount, description)
    if not Accounts[accountNumber] then return false, "Account not found" end
    
    local account = Accounts[accountNumber]
    local newBalance = account.balance + amount
    
    -- Check balance limits
    local accountConfig = Config.AccountTypes[account.type]
    if newBalance > accountConfig.maxBalance or newBalance < accountConfig.minBalance then
        return false, "Balance limit exceeded"
    end
    
    local success = MySQL.insert.await('INSERT INTO sl_bank_transactions (account_id, type, amount, balance, description) VALUES (?, ?, ?, ?, ?)',
        {account.id, transactionType, amount, newBalance, description})
    
    if success then
        -- Update account balance
        account.balance = newBalance
        MySQL.update('UPDATE sl_bank_accounts SET balance = ? WHERE id = ?', {newBalance, account.id})
        
        -- Update transactions cache
        if not Transactions[accountNumber] then Transactions[accountNumber] = {} end
        table.insert(Transactions[accountNumber], 1, {
            id = success,
            type = transactionType,
            amount = amount,
            balance = newBalance,
            description = description,
            created_at = os.date()
        })
        
        -- Trim transaction history if needed
        while #Transactions[accountNumber] > Config.UI.maxTransactionHistory do
            table.remove(Transactions[accountNumber])
        end
        
        return true, "Transaction successful"
    end
    return false, "Transaction failed"
end

-- Credit Score Functions
function UpdateCreditScore(citizenId, factors)
    local currentScore = CreditScores[citizenId] or Config.CreditScore.defaultScore
    local newScore = currentScore
    
    -- Calculate new score based on factors
    if factors.paymentHistory then
        newScore = newScore + (factors.paymentHistory * Config.CreditScore.factors.paymentHistory)
    end
    if factors.creditUtilization then
        newScore = newScore + (factors.creditUtilization * Config.CreditScore.factors.creditUtilization)
    end
    
    -- Ensure score stays within limits
    newScore = math.max(Config.CreditScore.min, math.min(Config.CreditScore.max, newScore))
    
    MySQL.update('INSERT INTO sl_credit_scores (citizen_id, score) VALUES (?, ?) ON DUPLICATE KEY UPDATE score = ?',
        {citizenId, newScore, newScore})
    
    CreditScores[citizenId] = newScore
    return newScore
end

-- Loan Functions
function CreateLoan(accountNumber, loanType, amount, term)
    if not Accounts[accountNumber] then return false, "Account not found" end
    if not Config.Loans[loanType] then return false, "Invalid loan type" end
    
    local account = Accounts[accountNumber]
    local loanConfig = Config.Loans[loanType]
    
    -- Check credit score
    local creditScore = CreditScores[account.owner] or Config.CreditScore.defaultScore
    if creditScore < loanConfig.minCreditScore then
        return false, "Credit score too low"
    end
    
    -- Calculate monthly payment
    local monthlyInterest = loanConfig.interestRate / 12
    local monthlyPayment = amount * (monthlyInterest * (1 + monthlyInterest)^term) / ((1 + monthlyInterest)^term - 1)
    
    local success = MySQL.insert.await('INSERT INTO sl_loans (account_id, type, amount, interest_rate, term, remaining_payments, monthly_payment) VALUES (?, ?, ?, ?, ?, ?, ?)',
        {account.id, loanType, amount, loanConfig.interestRate, term, term, monthlyPayment})
    
    if success then
        -- Add loan amount to account
        AddTransaction(accountNumber, 'loan', amount, 'Loan disbursement - ' .. loanConfig.name)
        
        Loans[success] = {
            accountId = account.id,
            type = loanType,
            amount = amount,
            interestRate = loanConfig.interestRate,
            term = term,
            remainingPayments = term,
            monthlyPayment = monthlyPayment,
            status = 'active',
            nextPayment = os.time() + (30 * 24 * 60 * 60) -- 30 days
        }
        
        return true, "Loan approved"
    end
    return false, "Loan creation failed"
end

-- Investment Functions
function CreateInvestment(accountNumber, investmentType, amount)
    if not Accounts[accountNumber] then return false, "Account not found" end
    if not Config.Investments.types[investmentType] then return false, "Invalid investment type" end
    
    local account = Accounts[accountNumber]
    local investConfig = Config.Investments.types[investmentType]
    
    -- Check investment limits
    if amount < investConfig.minInvestment or amount > investConfig.maxInvestment then
        return false, "Investment amount outside limits"
    end
    
    -- Calculate shares and fees
    local fee = amount * investConfig.fee
    local investmentAmount = amount - fee
    local currentPrice = GetCurrentPrice(investmentType)
    local shares = investmentAmount / currentPrice
    
    -- Deduct investment amount from account
    local deductSuccess = AddTransaction(accountNumber, 'investment', -amount, 'Investment in ' .. investConfig.name)
    if not deductSuccess then return false, "Insufficient funds" end
    
    local success = MySQL.insert.await('INSERT INTO sl_investments (account_id, type, amount, shares, purchase_price, current_price) VALUES (?, ?, ?, ?, ?, ?)',
        {account.id, investmentType, investmentAmount, shares, currentPrice, currentPrice})
    
    if success then
        Investments[success] = {
            accountId = account.id,
            type = investmentType,
            amount = investmentAmount,
            shares = shares,
            purchasePrice = currentPrice,
            currentPrice = currentPrice,
            status = 'active'
        }
        
        return true, "Investment created"
    end
    return false, "Investment creation failed"
end

-- Helper Functions
function GenerateAccountNumber()
    while true do
        local number = tostring(math.random(100000000, 999999999))
        if not Accounts[number] then
            return number
        end
    end
end

function GetCurrentPrice(investmentType)
    -- Simulate market prices (replace with real market data integration)
    local basePrice = 100
    local volatility = Config.Investments.types[investmentType].volatility
    return basePrice * (1 + (math.random() - 0.5) * volatility)
end

-- Events
RegisterNetEvent('sl-banking:server:CreateAccount', function(accountType, pin)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if Player then
        local success, result = CreateAccount(Player.PlayerData.citizenid, accountType, pin)
        TriggerClientEvent('sl-banking:client:AccountCreated', src, success, result)
    end
end)

RegisterNetEvent('sl-banking:server:GetAccounts', function()
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if Player then
        local playerAccounts = {}
        for number, account in pairs(Accounts) do
            if account.owner == Player.PlayerData.citizenid then
                playerAccounts[number] = account
            end
        end
        TriggerClientEvent('sl-banking:client:ReceiveAccounts', src, playerAccounts)
    end
end)

RegisterNetEvent('sl-banking:server:GetTransactions', function(accountNumber)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if Player and Accounts[accountNumber] and Accounts[accountNumber].owner == Player.PlayerData.citizenid then
        TriggerClientEvent('sl-banking:client:ReceiveTransactions', src, Transactions[accountNumber] or {})
    end
end)

-- Exports
exports('GetAccount', function(accountNumber)
    return Accounts[accountNumber]
end)

exports('GetTransactions', function(accountNumber)
    return Transactions[accountNumber]
end)

exports('CreateAccount', CreateAccount)
exports('AddTransaction', AddTransaction)
exports('UpdateCreditScore', UpdateCreditScore)
exports('CreateLoan', CreateLoan)
exports('CreateInvestment', CreateInvestment)

-- Background Tasks
CreateThread(function()
    while true do
        ProcessInterest()
        ProcessLoanPayments()
        UpdateInvestmentPrices()
        Wait(60000) -- Check every minute
    end
end)

function ProcessInterest()
    for accountNumber, account in pairs(Accounts) do
        if account.type == 'savings' and account.balance > 0 then
            local config = Config.AccountTypes[account.type]
            local dailyInterest = (config.interestRate / 365) * account.balance
            if dailyInterest > 0 then
                AddTransaction(accountNumber, 'interest', dailyInterest, 'Daily interest')
            end
        end
    end
end

function ProcessLoanPayments()
    for id, loan in pairs(Loans) do
        if loan.status == 'active' and os.time() >= loan.nextPayment then
            local account = GetAccountById(loan.accountId)
            if account then
                local success = AddTransaction(account.number, 'loan_payment', -loan.monthlyPayment, 'Loan payment')
                if success then
                    loan.remainingPayments = loan.remainingPayments - 1
                    loan.nextPayment = loan.nextPayment + (30 * 24 * 60 * 60)
                    
                    MySQL.update('UPDATE sl_loans SET remaining_payments = ?, next_payment = ? WHERE id = ?',
                        {loan.remainingPayments, loan.nextPayment, id})
                    
                    if loan.remainingPayments <= 0 then
                        loan.status = 'paid'
                        MySQL.update('UPDATE sl_loans SET status = ? WHERE id = ?', {'paid', id})
                    end
                else
                    -- Handle missed payment
                    UpdateCreditScore(account.owner, {paymentHistory = -10})
                end
            end
        end
    end
end

function UpdateInvestmentPrices()
    for id, investment in pairs(Investments) do
        if investment.status == 'active' then
            local newPrice = GetCurrentPrice(investment.type)
            investment.currentPrice = newPrice
            
            MySQL.update('UPDATE sl_investments SET current_price = ? WHERE id = ?', {newPrice, id})
        end
    end
end

function GetAccountById(id)
    for number, account in pairs(Accounts) do
        if account.id == id then
            account.number = number
            return account
        end
    end
    return nil
end
