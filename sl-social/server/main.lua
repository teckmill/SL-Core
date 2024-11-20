local QBCore = exports['qb-core']:GetCoreObject()
local PhoneNumbers = {}

-- Utility Functions
local function GeneratePhoneNumber()
    local number
    repeat
        number = math.random(100000, 999999)
    until not PhoneNumbers[number]
    PhoneNumbers[number] = true
    return number
end

local function IsValidImage(url)
    local extension = string.match(url, "%.(%w+)$")
    if not extension then return false end
    for _, format in ipairs(Config.Phone.AllowedImageFormats) do
        if string.lower(extension) == format then
            return true
        end
    end
    return false
end

-- Phone System
QBCore.Functions.CreateCallback('sl-social:server:getContacts', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    
    MySQL.Async.fetchAll('SELECT * FROM phone_contacts WHERE owner = ?', {citizenid}, function(results)
        cb(results)
    end)
end)

RegisterNetEvent('sl-social:server:addContact')
AddEventHandler('sl-social:server:addContact', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid

    if not data.number or not data.name then
        TriggerClientEvent('QBCore:Notify', src, 'Invalid contact information', 'error')
        return
    end

    MySQL.Async.insert('INSERT INTO phone_contacts (owner, contact_name, number) VALUES (?, ?, ?)',
        {citizenid, data.name, data.number},
        function(id)
            if id then
                TriggerClientEvent('QBCore:Notify', src, 'Contact added successfully', 'success')
                TriggerClientEvent('sl-social:client:contactAdded', src, {id = id, name = data.name, number = data.number})
            end
        end
    )
end)

-- Social Media System
QBCore.Functions.CreateCallback('sl-social:server:getSocialFeed', function(source, cb)
    local posts = MySQL.query.await('SELECT p.*, u.firstname, u.lastname, COUNT(l.post_id) as likes, ' ..
        '(SELECT COUNT(*) FROM social_comments WHERE post_id = p.id) as comments ' ..
        'FROM social_posts p ' ..
        'LEFT JOIN players u ON p.user_id = u.id ' ..
        'LEFT JOIN social_likes l ON p.id = l.post_id ' ..
        'GROUP BY p.id ' ..
        'ORDER BY p.created_at DESC LIMIT 50')
    
    if posts then
        for i, post in ipairs(posts) do
            post.time = os.date('%Y-%m-%d %H:%M:%S', post.created_at)
            post.author = post.firstname .. ' ' .. post.lastname
        end
    end
    
    cb(posts or {})
end)

RegisterNetEvent('sl-social:server:createPost')
AddEventHandler('sl-social:server:createPost', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        if not data.content or string.len(data.content) > Config.Social.MaxPostLength then
            TriggerClientEvent('QBCore:Notify', src, 'Invalid post content', 'error')
            return
        end

        if data.image and not IsValidImage(data.image) then
            TriggerClientEvent('QBCore:Notify', src, 'Invalid image format', 'error')
            return
        end

        MySQL.insert('INSERT INTO social_posts (user_id, content, image_url, created_at) VALUES (?, ?, ?, NOW())',
            {Player.PlayerData.citizenid, data.content, data.image})
        
        -- Notify all clients to refresh their feed
        TriggerClientEvent('sl-social:client:refreshFeed', -1)
    end
end)

-- Messaging Functions
QBCore.Functions.CreateCallback('sl-social:server:getMessages', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        local messages = MySQL.query.await('SELECT m.*, u.firstname, u.lastname ' ..
            'FROM phone_messages m ' ..
            'LEFT JOIN players u ON m.sender_id = u.id ' ..
            'WHERE m.receiver_id = ? OR m.sender_id = ? ' ..
            'ORDER BY m.sent_at DESC LIMIT 100',
            {Player.PlayerData.citizenid, Player.PlayerData.citizenid})
        
        if messages then
            for i, msg in ipairs(messages) do
                msg.time = os.date('%H:%M', msg.sent_at)
                msg.isSender = msg.sender_id == Player.PlayerData.citizenid
            end
        end
        
        cb(messages or {})
    else
        cb({})
    end
end)

RegisterNetEvent('sl-social:server:sendMessage')
AddEventHandler('sl-social:server:sendMessage', function(receiverId, content)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(receiverId)
    
    if Player and Target then
        MySQL.insert('INSERT INTO phone_messages (sender_id, receiver_id, content, sent_at) VALUES (?, ?, ?, NOW())',
            {Player.PlayerData.citizenid, Target.PlayerData.citizenid, content})
        
        -- Notify receiver
        TriggerClientEvent('sl-social:client:messageReceived', Target.PlayerData.source)
    end
end)

-- Dating Functions
QBCore.Functions.CreateCallback('sl-social:server:getDatingProfiles', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        local profiles = MySQL.query.await('SELECT d.*, u.firstname, u.lastname ' ..
            'FROM dating_profiles d ' ..
            'LEFT JOIN players u ON d.user_id = u.id ' ..
            'WHERE d.user_id != ? ' ..
            'AND d.user_id NOT IN (SELECT profile_id FROM dating_matches WHERE user_id = ?) ' ..
            'ORDER BY RAND() LIMIT 10',
            {Player.PlayerData.citizenid, Player.PlayerData.citizenid})
        
        if profiles then
            for i, profile in ipairs(profiles) do
                profile.name = profile.firstname
                profile.photos = json.decode(profile.photos)
            end
        end
        
        cb(profiles or {})
    else
        cb({})
    end
end)

RegisterNetEvent('sl-social:server:likeDatingProfile')
AddEventHandler('sl-social:server:likeDatingProfile', function(profileId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        MySQL.insert('INSERT INTO dating_matches (user_id, profile_id, created_at) VALUES (?, ?, NOW())',
            {Player.PlayerData.citizenid, profileId})
        
        -- Check for mutual match
        local mutualMatch = MySQL.scalar.await('SELECT COUNT(*) FROM dating_matches ' ..
            'WHERE user_id = ? AND profile_id = ?',
            {profileId, Player.PlayerData.citizenid})
        
        if mutualMatch > 0 then
            -- Notify both users of the match
            local Target = QBCore.Functions.GetPlayerByCitizenId(profileId)
            if Target then
                TriggerClientEvent('sl-social:client:datingMatch', Target.PlayerData.source)
                TriggerClientEvent('sl-social:client:datingMatch', src)
            end
        end
    end
end)

-- Reputation Functions
QBCore.Functions.CreateCallback('sl-social:server:getReputation', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        local stats = MySQL.query.await('SELECT category, ROUND(AVG(rating)) as average ' ..
            'FROM reputation_ratings ' ..
            'WHERE user_id = ? ' ..
            'GROUP BY category',
            {Player.PlayerData.citizenid})
        
        local reputation = {}
        if stats then
            for i, stat in ipairs(stats) do
                reputation[stat.category] = stat.average
            end
        end
        
        cb(reputation)
    else
        cb({})
    end
end)

RegisterNetEvent('sl-social:server:ratePlayer')
AddEventHandler('sl-social:server:ratePlayer', function(targetId, category, rating)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(targetId)
    
    if Player and Target then
        if not category or not rating then
            TriggerClientEvent('QBCore:Notify', src, 'Invalid rating data', 'error')
            return
        end

        if rating < Config.Reputation.MinRating or rating > Config.Reputation.MaxRating then
            TriggerClientEvent('QBCore:Notify', src, 'Invalid rating value', 'error')
            return
        end

        MySQL.insert('INSERT INTO reputation_ratings (user_id, rater_id, category, rating, created_at) VALUES (?, ?, ?, ?, NOW())',
            {Target.PlayerData.citizenid, Player.PlayerData.citizenid, category, rating})
        
        -- Notify target of new rating
        TriggerClientEvent('sl-social:client:reputationUpdated', Target.PlayerData.source)
    end
end)

-- Utility Functions
function GetPlayerIdentifier(src)
    local Player = QBCore.Functions.GetPlayer(src)
    return Player and Player.PlayerData.citizenid or nil
end

-- Event handler for resource start
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        print('^2[sl-social] Resource started successfully^0')
        
        -- Load existing phone numbers
        MySQL.Async.fetchAll('SELECT number FROM phone_contacts', {}, function(results)
            for _, row in ipairs(results) do
                PhoneNumbers[tonumber(row.number)] = true
            end
        end)
    end
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    PhoneNumbers = {}
end)
