local SLCore = exports['sl-core']:GetCoreObject()

-- Save outfit to database
RegisterNetEvent('sl-clothing:server:saveOutfit')
AddEventHandler('sl-clothing:server:saveOutfit', function(outfitData)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local citizenid = Player.PlayerData.citizenid
    local outfitName = outfitData.outfitName
    
    MySQL.Async.insert('INSERT INTO player_outfits (citizenid, outfitname, model, outfit) VALUES (?, ?, ?, ?)',
        {citizenid, outfitName, outfitData.model, json.encode(outfitData.components)},
        function(id)
            if id then
                TriggerClientEvent('SLCore:Notify', src, 'Outfit saved!', 'success')
            end
        end
    )
end)

-- Load outfits from database
SLCore.Functions.CreateCallback('sl-clothing:server:getOutfits', function(source, cb)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    
    if not Player then return cb({}) end
    
    local citizenid = Player.PlayerData.citizenid
    
    MySQL.Async.fetchAll('SELECT * FROM player_outfits WHERE citizenid = ?',
        {citizenid},
        function(result)
            if result[1] then
                cb(result)
            else
                cb({})
            end
        end
    )
end)
