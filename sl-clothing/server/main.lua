local SLCore = exports['sl-core']:GetCoreObject()

-- Save Outfit
RegisterNetEvent('sl-clothing:server:SaveOutfit', function(name, outfitData)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    MySQL.Async.insert('INSERT INTO player_outfits (citizenid, name, outfitData) VALUES (?, ?, ?)',
        {Player.PlayerData.citizenid, name, json.encode(outfitData)})
end)

-- Load Outfits
SLCore.Functions.CreateCallback('sl-clothing:server:GetOutfits', function(source, cb)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end
    
    MySQL.Async.fetchAll('SELECT * FROM player_outfits WHERE citizenid = ?',
        {Player.PlayerData.citizenid}, function(result)
            cb(result)
    end)
end)

-- Delete Outfit
RegisterNetEvent('sl-clothing:server:DeleteOutfit', function(outfitId)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    MySQL.Async.execute('DELETE FROM player_outfits WHERE id = ? AND citizenid = ?',
        {outfitId, Player.PlayerData.citizenid})
end)

-- Save Tattoo
RegisterNetEvent('sl-clothing:server:SaveTattoo', function(collection, overlay, zone)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    MySQL.Async.insert('INSERT INTO player_tattoos (citizenid, collection, overlay, zone) VALUES (?, ?, ?, ?)',
        {Player.PlayerData.citizenid, collection, overlay, zone})
end) 