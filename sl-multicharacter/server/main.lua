local SLCore = exports['sl-core']:GetCoreObject()

-- Callbacks
SLCore.Functions.CreateCallback('sl-multicharacter:server:GetCharacters', function(source, cb)
    local license = SLCore.Functions.GetIdentifier(source, 'license')
    local plyChars = {}
    
    MySQL.query('SELECT * FROM players WHERE license = ?', {license}, function(result)
        for i = 1, (#result), 1 do
            result[i].charinfo = json.decode(result[i].charinfo)
            result[i].money = json.decode(result[i].money)
            result[i].job = json.decode(result[i].job)
            plyChars[#plyChars + 1] = result[i]
        end
        cb(plyChars)
    end)
end)

-- Events
RegisterNetEvent('sl-multicharacter:server:createCharacter', function(data)
    local src = source
    local newData = {}
    newData.cid = SLCore.Functions.CreateCitizenId()
    newData.charinfo = data
    newData.money = {
        cash = Config.StartingCash or 500,
        bank = Config.StartingBank or 5000,
    }
    newData.job = {
        name = "unemployed",
        label = "Civilian",
        payment = 10,
        onduty = true
    }
    
    local license = SLCore.Functions.GetIdentifier(src, 'license')
    MySQL.insert('INSERT INTO players (citizenid, license, charinfo, money, job) VALUES (?, ?, ?, ?, ?)',
        {
            newData.cid,
            license,
            json.encode(newData.charinfo),
            json.encode(newData.money),
            json.encode(newData.job)
        }, function()
        if Config.StartingApartment then
            -- Handle apartment assignment if enabled
            -- This would typically involve creating an apartment record and assigning it to the player
        end
        
        TriggerClientEvent('sl-multicharacter:client:spawnPlayer', src, {spawn = data.spawn})
    end)
end)

RegisterNetEvent('sl-multicharacter:server:deleteCharacter', function(citizenid)
    local src = source
    MySQL.query('DELETE FROM players WHERE citizenid = ?', {citizenid}, function()
        TriggerClientEvent('SLCore:Notify', src, 'Character deleted!', 'success')
    end)
end)

RegisterNetEvent('sl-multicharacter:server:loadUserData', function(cData)
    local src = source
    if cData then
        MySQL.single('SELECT * FROM players WHERE citizenid = ?', {cData.citizenid}, function(result)
            if result then
                -- Decode JSON data
                result.charinfo = json.decode(result.charinfo)
                result.money = json.decode(result.money)
                result.job = json.decode(result.job)
                
                -- Set player data in core
                SLCore.Player.LoadPlayer(src, result)
                
                -- Trigger spawn event
                TriggerClientEvent('sl-multicharacter:client:spawnPlayer', src, {spawn = result.charinfo.spawn or 'default'})
            else
                TriggerClientEvent('SLCore:Notify', src, 'Error loading character!', 'error')
            end
        end)
    end
end)

-- Commands
SLCore.Commands.Add('deletechar', 'Delete a character (Admin Only)', {{name = 'citizenid', help = 'Citizen ID of character to delete'}}, true, function(source, args)
    if args[1] then
        MySQL.query('DELETE FROM players WHERE citizenid = ?', {args[1]}, function()
            TriggerClientEvent('SLCore:Notify', source, 'Character ' .. args[1] .. ' has been deleted', 'success')
        end)
    else
        TriggerClientEvent('SLCore:Notify', source, 'Please provide a citizen id', 'error')
    end
end, 'admin')
