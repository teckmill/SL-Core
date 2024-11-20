local SLCore = exports['sl-core']:GetCoreObject()

-- MDT Data
SLCore.Functions.CreateCallback('sl-police:server:GetMDTData', function(source, cb)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end
    
    local reports = MySQL.Sync.fetchAll('SELECT * FROM mdt_reports ORDER BY time DESC LIMIT 50')
    local warrants = MySQL.Sync.fetchAll('SELECT * FROM mdt_warrants WHERE status = ? ORDER BY time DESC', {'active'})
    
    cb({
        reports = reports,
        warrants = warrants
    })
end)

-- Search Functions
SLCore.Functions.CreateCallback('sl-police:server:SearchCitizen', function(source, cb, search)
    local searchResults = MySQL.Sync.fetchAll([[
        SELECT p.*, CONCAT(c.firstname, ' ', c.lastname) as name 
        FROM players p 
        LEFT JOIN characters c ON p.citizenid = c.citizenid 
        WHERE c.firstname LIKE ? OR c.lastname LIKE ? OR p.citizenid LIKE ?
    ]], {
        '%'..search..'%',
        '%'..search..'%',
        '%'..search..'%'
    })
    
    cb(searchResults)
end)

-- Report/Warrant Creation
RegisterNetEvent('sl-police:server:NewWarrant', function(data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    MySQL.Async.insert('INSERT INTO mdt_warrants (citizenid, description, author) VALUES (?, ?, ?)',
        {data.citizenid, data.description, Player.PlayerData.citizenid})
end)

RegisterNetEvent('sl-police:server:NewReport', function(data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    MySQL.Async.insert('INSERT INTO mdt_reports (citizenid, title, incident, evidence, officers, author) VALUES (?, ?, ?, ?, ?, ?)',
        {data.citizenid, data.title, data.incident, json.encode(data.evidence), json.encode(data.officers), Player.PlayerData.citizenid})
end) 