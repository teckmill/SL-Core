local SLCore = exports['sl-core']:GetCoreObject()

-- Get Tweets
SLCore.Functions.CreateCallback('sl-phone:server:GetTweets', function(source, cb)
    local tweets = MySQL.Sync.fetchAll('SELECT * FROM phone_tweets ORDER BY time DESC LIMIT 50')
    cb(tweets)
end)

-- Post Tweet
RegisterNetEvent('sl-phone:server:PostTweet', function(data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local tweet = {
        identifier = Player.PlayerData.citizenid,
        author = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
        message = data.message,
        time = os.date(),
        likes = 0
    }
    
    local id = MySQL.insert.await('INSERT INTO phone_tweets (identifier, author, message) VALUES (?, ?, ?)',
        {tweet.identifier, tweet.author, tweet.message})
    
    tweet.id = id
    TriggerClientEvent('sl-phone:client:UpdateTweets', -1, tweet)
end) 