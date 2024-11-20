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

-- Initialize Database
CreateThread(function()
    MySQL.ready(function()
        -- Create tables if they don't exist
        local sqlFile = LoadResourceFile(GetCurrentResourceName(), 'sql/hud.sql')
        if sqlFile then
            MySQL.Sync.execute(sqlFile)
            Log('info', 'Database table initialized successfully')
        end
    end)
end)

-- Player Data Management
local PlayerSettings = {}

-- Save player HUD settings
local function SavePlayerSettings(source, settings)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end

    local identifier = Player.PlayerData.identifier
    if not identifier then return false end

    PlayerSettings[identifier] = settings
    local success = MySQL.Sync.execute('INSERT INTO player_hud_settings (identifier, settings) VALUES (?, ?) ON DUPLICATE KEY UPDATE settings = ?',
        {identifier, json.encode(settings), json.encode(settings)})
    
    if success then
        Log('debug', string.format('Saved HUD settings for player %s', identifier))
        return true
    end
    return false
end

-- Load player HUD settings
local function LoadPlayerSettings(source)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return nil end

    local identifier = Player.PlayerData.identifier
    if not identifier then return nil end

    -- Check cache first
    if PlayerSettings[identifier] then
        return PlayerSettings[identifier]
    end

    -- Load from database
    local result = MySQL.Sync.fetchAll('SELECT settings FROM player_hud_settings WHERE identifier = ? LIMIT 1', {identifier})
    if result and result[1] then
        PlayerSettings[identifier] = json.decode(result[1].settings)
        Log('debug', string.format('Loaded HUD settings for player %s', identifier))
        return PlayerSettings[identifier]
    end

    return nil
end

-- Event Handlers
RegisterNetEvent('sl-hud:server:SaveSettings', function(settings)
    local source = source
    if not SavePlayerSettings(source, settings) then
        Log('error', string.format('Failed to save HUD settings for player %s', source))
    end
end)

RegisterNetEvent('sl-hud:server:RequestSettings', function()
    local source = source
    local settings = LoadPlayerSettings(source)
    TriggerClientEvent('sl-hud:client:ReceiveSettings', source, settings)
end)

-- Exports
exports('SavePlayerSettings', SavePlayerSettings)
exports('LoadPlayerSettings', LoadPlayerSettings)
exports('ResetPlayerSettings', function(source)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end

    local identifier = Player.PlayerData.identifier
    if not identifier then return false end

    PlayerSettings[identifier] = nil
    return MySQL.Sync.execute('DELETE FROM player_hud_settings WHERE identifier = ?', {identifier})
end)

-- Auto-save loop
CreateThread(function()
    while true do
        Wait(Config.SaveInterval)
        for source, player in pairs(SLCore.Functions.GetPlayers()) do
            if PlayerSettings[player.PlayerData.identifier] then
                SavePlayerSettings(source, PlayerSettings[player.PlayerData.identifier])
            end
        end
    end
end)
