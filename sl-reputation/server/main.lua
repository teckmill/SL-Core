local SLCore = exports['sl-core']:GetCoreObject()

-- Initialize database tables
CreateThread(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS player_reputation (
            id INT AUTO_INCREMENT PRIMARY KEY,
            citizenid VARCHAR(50) NOT NULL,
            category VARCHAR(50) NOT NULL,
            points INT DEFAULT 0,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            UNIQUE KEY unique_player_category (citizenid, category)
        )
    ]])
    
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS reputation_history (
            id INT AUTO_INCREMENT PRIMARY KEY,
            citizenid VARCHAR(50) NOT NULL,
            category VARCHAR(50) NOT NULL,
            points INT NOT NULL,
            reason VARCHAR(255),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ]])
end)

-- Functions
local function InitializePlayerReputation(citizenid)
    for category, data in pairs(Config.Categories) do
        MySQL.insert('INSERT IGNORE INTO player_reputation (citizenid, category, points) VALUES (?, ?, ?)',
            {citizenid, category, data.defaultValue})
    end
end

local function LoadPlayerReputation(citizenid)
    local reputation = {}
    local result = MySQL.query.await('SELECT category, points FROM player_reputation WHERE citizenid = ?',
        {citizenid})
    
    for _, data in ipairs(result) do
        reputation[data.category] = {
            points = data.points
        }
    end
    
    return reputation
end

local function UpdateReputation(citizenid, category, points, reason)
    if not Config.Categories[category] then return false end
    
    -- Update points
    MySQL.update('UPDATE player_reputation SET points = points + ? WHERE citizenid = ? AND category = ?',
        {points, citizenid, category})
    
    -- Add to history
    MySQL.insert('INSERT INTO reputation_history (citizenid, category, points, reason) VALUES (?, ?, ?, ?)',
        {citizenid, category, points, reason})
    
    -- Get player and notify them
    local Player = SLCore.Functions.GetPlayerByCitizenId(citizenid)
    if Player then
        TriggerClientEvent('sl-reputation:client:UpdateReputation', Player.PlayerData.source,
            category, points, reason)
    end
    
    return true
end

-- Callbacks
SLCore.Functions.CreateCallback('sl-reputation:server:GetReputationData', function(source, cb)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end
    
    local reputation = LoadPlayerReputation(Player.PlayerData.citizenid)
    cb(reputation)
end)

SLCore.Functions.CreateCallback('sl-reputation:server:GetReputationHistory', function(source, cb, category)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end
    
    local result = MySQL.query.await([[
        SELECT points, reason, DATE_FORMAT(created_at, '%Y-%m-%d %H:%i') as date
        FROM reputation_history
        WHERE citizenid = ? AND category = ?
        ORDER BY created_at DESC LIMIT 10
    ]], {Player.PlayerData.citizenid, category})
    
    cb(result)
end)

-- Events
RegisterNetEvent('sl-reputation:server:UpdateReputation')
AddEventHandler('sl-reputation:server:UpdateReputation', function(target, category, points, reason)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Check if player has permission to update reputation
    if not Player.PlayerData.job.isboss then return end
    
    local TargetPlayer = SLCore.Functions.GetPlayer(target)
    if not TargetPlayer then return end
    
    UpdateReputation(TargetPlayer.PlayerData.citizenid, category, points, reason)
end)

-- Player loaded event
RegisterNetEvent('SLCore:Server:PlayerLoaded')
AddEventHandler('SLCore:Server:PlayerLoaded', function()
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return end
    
    InitializePlayerReputation(Player.PlayerData.citizenid)
end)

-- Reputation decay
CreateThread(function()
    while true do
        Wait(Config.TimeSettings.decayInterval * 60 * 1000) -- Convert minutes to milliseconds
        
        if Config.TimeSettings.decayAmount > 0 then
            MySQL.query([[
                UPDATE player_reputation
                SET points = GREATEST(0, points - ?)
                WHERE points > 0
            ]], {Config.TimeSettings.decayAmount})
        end
    end
end)

-- Exports
exports('UpdateReputation', UpdateReputation)
exports('GetPlayerReputation', function(citizenid)
    return LoadPlayerReputation(citizenid)
end)
