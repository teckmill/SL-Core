local SLCore = exports['sl-core']:GetCoreObject()

-- Format character data for UI
local function formatCharacterData(character)
    local charinfo = json.decode(character.charinfo)
    local job = json.decode(character.job)
    local money = json.decode(character.money)
    local metadata = json.decode(character.metadata)
    
    return {
        citizenid = character.citizenid,
        name = ('%s %s'):format(charinfo.firstname, charinfo.lastname),
        birthdate = charinfo.birthdate,
        gender = charinfo.gender,
        nationality = charinfo.nationality,
        job = {
            label = job.label,
            grade = job.grade and job.grade.name or '',
            onDuty = job.onduty
        },
        money = {
            cash = money.cash,
            bank = money.bank
        },
        charinfo = charinfo,
        position = json.decode(character.position),
        metadata = metadata
    }
end

-- Callbacks
SLCore.Functions.CreateCallback('sl-multicharacter:server:GetCharacters', function(source, cb)
    local license = SLCore.Functions.GetIdentifier(source, 'license')
    
    MySQL.query('SELECT * FROM players WHERE license = ?', {license}, function(result)
        if result then
            local characters = {}
            for _, char in ipairs(result) do
                table.insert(characters, formatCharacterData(char))
            end
            cb(characters)
        else
            cb({})
        end
    end)
end)

-- Setup characters for a player
RegisterNetEvent('sl-multicharacter:server:setupCharacters', function()
    local src = source
    local license = SLCore.Functions.GetIdentifier(src, 'license')
    
    -- Fetch characters from database
    MySQL.query('SELECT * FROM players WHERE license = ?', {license}, function(result)
        if result then
            local characters = {}
            for _, char in ipairs(result) do
                table.insert(characters, formatCharacterData(char))
            end
            
            -- Send formatted characters to client
            TriggerClientEvent('sl-multicharacter:client:showUI', src, characters)
        else
            -- Send empty character list
            TriggerClientEvent('sl-multicharacter:client:showUI', src, {})
        end
    end)
end)

-- Load a character
RegisterNetEvent('sl-multicharacter:server:loadCharacter', function(character)
    local src = source
    if not character then return end
    
    local license = SLCore.Functions.GetIdentifier(src, 'license')
    MySQL.single('SELECT * FROM players WHERE license = ? AND citizenid = ?', {license, character.citizenid}, function(result)
        if result then
            local charData = formatCharacterData(result)
            SLCore.Player.Login(src, charData)
            TriggerClientEvent('SLCore:Client:OnPlayerLoaded', src)
            TriggerEvent('SLCore:Server:OnPlayerLoaded', src, charData)
        end
    end)
end)

-- Create a new character
RegisterNetEvent('sl-multicharacter:server:createCharacter', function(data)
    local src = source
    if not data then return end
    
    local license = SLCore.Functions.GetIdentifier(src, 'license')
    local citizenid = SLCore.Functions.CreateCitizenId()
    
    -- Create character data
    local charinfo = {
        firstname = data.firstname,
        lastname = data.lastname,
        birthdate = data.birthdate,
        gender = data.gender,
        nationality = data.nationality
    }
    
    -- Default metadata
    local metadata = {
        hunger = 100,
        thirst = 100,
        stress = 0,
        phone = SLCore.Functions.CreatePhoneNumber(),
        crafting = { experience = 0, level = 0 },
        dealerrep = 0,
        craftingrep = 0,
        attachmentcraftingrep = 0,
        currentapartment = nil,
        jobRep = {
            tow = 0,
            trucker = 0,
            taxi = 0,
            hotdog = 0
        },
        callsign = 'NO CALLSIGN',
        bloodtype = SLCore.Functions.GetRandomBloodType()
    }
    
    -- Default money
    local money = {
        cash = 500,
        bank = 5000,
        crypto = 0
    }
    
    -- Default job
    local job = {
        name = "unemployed",
        label = "Civilian",
        payment = 10,
        onduty = true,
        grade = {
            name = "Freelancer",
            level = 0
        }
    }
    
    -- Default gang
    local gang = {
        name = "none",
        label = "No Gang Affiliation",
        grade = {
            name = "none",
            level = 0
        }
    }
    
    -- Default spawn position
    local position = {
        x = -1035.71,
        y = -2731.87,
        z = 12.86,
        a = 0.0
    }
    
    -- Insert character into database
    MySQL.insert('INSERT INTO players (citizenid, license, name, money, charinfo, job, gang, metadata, position) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
    {
        citizenid,
        license,
        ('%s %s'):format(charinfo.firstname, charinfo.lastname),
        json.encode(money),
        json.encode(charinfo),
        json.encode(job),
        json.encode(gang),
        json.encode(metadata),
        json.encode(position)
    }, function()
        -- Refresh character list
        TriggerEvent('sl-multicharacter:server:setupCharacters', src)
    end)
end)

-- Delete a character
RegisterNetEvent('sl-multicharacter:server:deleteCharacter', function(citizenid)
    local src = source
    local license = SLCore.Functions.GetIdentifier(src, 'license')
    
    MySQL.query('DELETE FROM players WHERE citizenid = ? AND license = ?', {citizenid, license}, function()
        -- Refresh character list
        TriggerEvent('sl-multicharacter:server:setupCharacters', src)
    end)
end)

-- Events
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
