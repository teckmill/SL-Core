local SLCore = exports['sl-core']:GetCoreObject()

-- Get Bank Data
SLCore.Functions.CreateCallback('sl-phone:server:GetBankData', function(source, cb)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb(nil) end
    
    local bankData = {
        balance = Player.PlayerData.money.bank,
        transactions = MySQL.Sync.fetchAll('SELECT * FROM phone_bank_transactions WHERE identifier = ? ORDER BY time DESC LIMIT 50',
            {Player.PlayerData.citizenid})
    }
    
    cb(bankData)
end)

-- Transfer Money
RegisterNetEvent('sl-phone:server:TransferMoney', function(data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local Target = SLCore.Functions.GetPlayerByPhone(data.recipient)
    if not Target then return end
    
    local amount = tonumber(data.amount)
    if not amount or amount <= 0 then return end
    
    if Player.PlayerData.money.bank >= amount then
        Player.Functions.RemoveMoney('bank', amount, 'phone-transfer-sent')
        Target.Functions.AddMoney('bank', amount, 'phone-transfer-received')
        
        -- Log transaction
        MySQL.insert('INSERT INTO phone_bank_transactions (identifier, type, amount, description) VALUES (?, ?, ?, ?)',
            {Player.PlayerData.citizenid, 'transfer', -amount, 'Transfer to ' .. data.recipient})
        
        MySQL.insert('INSERT INTO phone_bank_transactions (identifier, type, amount, description) VALUES (?, ?, ?, ?)',
            {Target.PlayerData.citizenid, 'transfer', amount, 'Transfer from ' .. Player.PlayerData.charinfo.phone})
            
        -- Update both players
        TriggerClientEvent('sl-phone:client:UpdateBankData', src, {balance = Player.PlayerData.money.bank})
        TriggerClientEvent('sl-phone:client:UpdateBankData', Target.PlayerData.source, {balance = Target.PlayerData.money.bank})
    end
end) 