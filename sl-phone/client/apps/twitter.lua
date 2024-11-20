local SLCore = exports['sl-core']:GetCoreObject()

-- NUI Callbacks
RegisterNUICallback('GetTweets', function(data, cb)
    SLCore.Functions.TriggerCallback('sl-phone:server:GetTweets', function(tweets)
        cb(tweets)
    end)
end)

RegisterNUICallback('PostTweet', function(data, cb)
    if not data.message then return end
    TriggerServerEvent('sl-phone:server:PostTweet', data)
    cb('ok')
end)

RegisterNUICallback('DeleteTweet', function(data, cb)
    if not data.id then return end
    TriggerServerEvent('sl-phone:server:DeleteTweet', data.id)
    cb('ok')
end)

RegisterNUICallback('LikeTweet', function(data, cb)
    if not data.id then return end
    TriggerServerEvent('sl-phone:server:LikeTweet', data.id)
    cb('ok')
end)

-- Events
RegisterNetEvent('sl-phone:client:UpdateTweets', function(tweets)
    SendNUIMessage({
        action = "UpdateTweets",
        tweets = tweets
    })
end)

RegisterNetEvent('sl-phone:client:TweetLiked', function(tweetId, likes)
    SendNUIMessage({
        action = "UpdateTweetLikes",
        id = tweetId,
        likes = likes
    })
end)

-- Functions
local function ExtractHashtags(message)
    local hashtags = {}
    for tag in message:gmatch("#(%w+)") do
        table.insert(hashtags, tag:lower())
    end
    return hashtags
end

local function ExtractMentions(message)
    local mentions = {}
    for mention in message:gmatch("@(%w+)") do
        table.insert(mentions, mention:lower())
    end
    return mentions
end
