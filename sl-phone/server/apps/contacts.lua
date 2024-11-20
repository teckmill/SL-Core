local SLCore = exports['sl-core']:GetCoreObject()

-- Get Contacts
SLCore.Functions.CreateCallback('sl-phone:server:GetContacts', function(source, cb)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end
    
    local contacts = MySQL.Sync.fetchAll('SELECT * FROM phone_contacts WHERE identifier = ? ORDER BY name ASC',
        {Player.PlayerData.citizenid})
    cb(contacts)
end)

-- Add Contact
RegisterNetEvent('sl-phone:server:AddContact', function(data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local id = MySQL.insert.await('INSERT INTO phone_contacts (identifier, name, number) VALUES (?, ?, ?)',
        {Player.PlayerData.citizenid, data.name, data.number})
        
    if id then
        data.id = id
        TriggerClientEvent('sl-phone:client:RefreshContacts', src)
    end
end)

-- Delete Contact
RegisterNetEvent('sl-phone:server:DeleteContact', function(id)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    MySQL.Async.execute('DELETE FROM phone_contacts WHERE id = ? AND identifier = ?',
        {id, Player.PlayerData.citizenid})
    
    TriggerClientEvent('sl-phone:client:RefreshContacts', src)
end)

-- Update Contact
RegisterNetEvent('sl-phone:server:UpdateContact', function(data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    MySQL.Async.execute('UPDATE phone_contacts SET name = ?, number = ? WHERE id = ? AND identifier = ?',
        {data.name, data.number, data.id, Player.PlayerData.citizenid})
    
    TriggerClientEvent('sl-phone:client:RefreshContacts', src)
end) 