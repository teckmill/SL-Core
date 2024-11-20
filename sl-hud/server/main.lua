local SLCore = exports['sl-core']:GetCoreObject()

-- Server Configuration
local Config = {
    SaveInterval = 5 * 60 * 1000, -- 5 minutes
    EnableLogging = true,
    LogLevel = 'info' -- 'debug', 'info', 'warn', 'error'
}

-- Utility Functions
local function Log(level, message)
    if not Config.EnableLogging then return end
    if not Config.LogLevel:find(level) then return end
    print(string.format('[SL-HUD] [%s] %s', level:upper(), message))
end

-- Player Data Management
local PlayerSettings = {}

-- Save player HUD settings
local function SavePlayerSettings(source, settings)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return end

    local citizenid = Player.PlayerData.citizenid
    PlayerSettings[citizenid] = settings

    -- Save to database
    MySQL.Async.execute('INSERT INTO player_hud_settings (citizenid, settings) VALUES (?, ?) ON DUPLICATE KEY UPDATE settings = ?',
        {citizenid, json.encode(settings), json.encode(settings)},
        function(rowsChanged)
            if rowsChanged > 0 then
                Log('info', string.format('Saved HUD settings for player %s', citizenid))
            end
        end
    )
end

-- Load player HUD settings
local function LoadPlayerSettings(source)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return end

    local citizenid = Player.PlayerData.citizenid

    -- Check cache first
    if PlayerSettings[citizenid] then
        TriggerClientEvent('sl-hud:client:LoadSettings', source, PlayerSettings[citizenid])
        return
    end

    -- Load from database
    MySQL.Async.fetchAll('SELECT settings FROM player_hud_settings WHERE citizenid = ?', {citizenid},
        function(result)
            if result and result[1] then
                local settings = json.decode(result[1].settings)
                PlayerSettings[citizenid] = settings
                TriggerClientEvent('sl-hud:client:LoadSettings', source, settings)
                Log('info', string.format('Loaded HUD settings for player %s', citizenid))
            else
                -- Use default settings if none found
                TriggerClientEvent('sl-hud:client:LoadSettings', source, {})
            end
        end
    )
end

-- Clear cached settings when player disconnects
local function ClearPlayerCache(source)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return end

    local citizenid = Player.PlayerData.citizenid
    if PlayerSettings[citizenid] then
        PlayerSettings[citizenid] = nil
        Log('debug', string.format('Cleared cached HUD settings for player %s', citizenid))
    end
end

-- Event Handlers
RegisterNetEvent('sl-hud:server:SaveSettings', function(settings)
    local source = source
    SavePlayerSettings(source, settings)
end)

-- Framework Events
AddEventHandler('SLCore:Server:PlayerLoaded', function(Player)
    LoadPlayerSettings(Player.PlayerData.source)
end)

AddEventHandler('playerDropped', function()
    ClearPlayerCache(source)
end)

-- Server Startup
CreateThread(function()
    -- Create database table if it doesn't exist
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS player_hud_settings (
            citizenid VARCHAR(50) PRIMARY KEY,
            settings LONGTEXT NOT NULL,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )
    ]], {}, function(success)
        if success then
            Log('info', 'Database table initialized successfully')
        else
            Log('error', 'Failed to initialize database table')
        end
    end)
end)

-- Periodic cleanup of old settings
CreateThread(function()
    while true do
        Wait(Config.SaveInterval)
        -- Clean up settings older than 30 days
        MySQL.Async.execute('DELETE FROM player_hud_settings WHERE updated_at < DATE_SUB(NOW(), INTERVAL 30 DAY)', {},
            function(rowsDeleted)
                if rowsDeleted > 0 then
                    Log('info', string.format('Cleaned up %d old HUD settings records', rowsDeleted))
                end
            end
        )
    end
end)

-- Exports
exports('GetPlayerSettings', function(source)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return nil end
    return PlayerSettings[Player.PlayerData.citizenid]
end)

exports('ResetPlayerSettings', function(source)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end

    local citizenid = Player.PlayerData.citizenid
    PlayerSettings[citizenid] = nil

    MySQL.Async.execute('DELETE FROM player_hud_settings WHERE citizenid = ?', {citizenid},
        function(rowsDeleted)
            if rowsDeleted > 0 then
                Log('info', string.format('Reset HUD settings for player %s', citizenid))
                TriggerClientEvent('sl-hud:client:LoadSettings', source, {})
            end
        end
    )
    return true
end)
