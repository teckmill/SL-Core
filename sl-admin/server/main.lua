local SLCore = nil
local Reports = {}
local SpectatingPlayers = {}
local FrozenPlayers = {}

-- Initialize SLCore
CreateThread(function()
    while SLCore == nil do
        if GetResourceState('sl-core') == 'started' then
            SLCore = exports['sl-core']:GetCoreObject()
        end
        Wait(100)
    end
end)

-- Utility Functions
local function IsPlayerAdmin(source)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local group = Player.PlayerData.group
    return Config.AdminRanks[group] and Config.AdminRanks[group] > 0
end

local function HasPermission(source, permission)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local group = Player.PlayerData.group
    local requiredRank = Config.Permissions[permission] or 0
    return Config.AdminRanks[group] and Config.AdminRanks[group] >= requiredRank
end

local function LogToDiscord(channel, message)
    if not Config.EnableDiscordLogs then return end
    
    local webhook = Config.DiscordLogChannels[channel] or Config.DiscordWebhook
    if webhook == '' then return end

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = 'SL Admin',
        embeds = {{
            description = message,
            color = 3447003,
            footer = {
                text = os.date('%Y-%m-%d %H:%M:%S')
            }
        }}
    }), { ['Content-Type'] = 'application/json' })
end

-- Player Management
RegisterNetEvent('sl-admin:server:KickPlayer', function(playerId, reason)
    local source = source
    if not HasPermission(source, 'kick') then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.no_permission'), 'error')
        return
    end

    local targetPlayer = SLCore.Functions.GetPlayer(playerId)
    if not targetPlayer then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.player_not_found'), 'error')
        return
    end

    local adminName = GetPlayerName(source)
    local playerName = GetPlayerName(playerId)
    
    DropPlayer(playerId, reason)
    
    if Config.LogActions['player_kicked'] then
        LogToDiscord('kicks', Lang:t('logs.player_kicked', {adminName, playerName, reason}))
    end
end)

RegisterNetEvent('sl-admin:server:BanPlayer', function(playerId, reason, duration)
    local source = source
    if not HasPermission(source, 'ban') then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.no_permission'), 'error')
        return
    end

    local targetPlayer = SLCore.Functions.GetPlayer(playerId)
    if not targetPlayer then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.player_not_found'), 'error')
        return
    end

    local adminName = GetPlayerName(source)
    local playerName = GetPlayerName(playerId)
    local playerLicense = SLCore.Functions.GetIdentifier(playerId, 'license')
    
    -- Save ban to database
    MySQL.insert('INSERT INTO bans (name, license, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?)',
        {playerName, playerLicense, reason, duration, adminName},
        function()
            DropPlayer(playerId, reason)
            if Config.LogActions['player_banned'] then
                LogToDiscord('bans', Lang:t('logs.player_banned', {adminName, playerName, reason, duration}))
            end
        end
    )
end)

RegisterNetEvent('sl-admin:server:RevivePlayer', function(playerId)
    local source = source
    if not HasPermission(source, 'revive') then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.no_permission'), 'error')
        return
    end

    local targetPlayer = SLCore.Functions.GetPlayer(playerId)
    if not targetPlayer then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.player_not_found'), 'error')
        return
    end

    TriggerClientEvent('sl-ambulance:client:Revive', playerId)
    
    local adminName = GetPlayerName(source)
    local playerName = GetPlayerName(playerId)
    
    if Config.LogActions['player_revived'] then
        LogToDiscord('admin', Lang:t('logs.player_revived', {adminName, playerName}))
    end
end)

RegisterNetEvent('sl-admin:server:GotoPlayer', function(playerId)
    local source = source
    if not HasPermission(source, 'goto') then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.no_permission'), 'error')
        return
    end

    local targetPlayer = SLCore.Functions.GetPlayer(playerId)
    if not targetPlayer then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.player_not_found'), 'error')
        return
    end

    local targetPed = GetPlayerPed(playerId)
    local coords = GetEntityCoords(targetPed)
    
    TriggerClientEvent('sl-admin:client:TeleportToCoords', source, coords)
    
    local adminName = GetPlayerName(source)
    local playerName = GetPlayerName(playerId)
    
    if Config.LogActions['admin_goto'] then
        LogToDiscord('admin', Lang:t('logs.admin_goto', {adminName, playerName}))
    end
end)

RegisterNetEvent('sl-admin:server:BringPlayer', function(playerId)
    local source = source
    if not HasPermission(source, 'bring') then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.no_permission'), 'error')
        return
    end

    local targetPlayer = SLCore.Functions.GetPlayer(playerId)
    if not targetPlayer then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.player_not_found'), 'error')
        return
    end

    local adminPed = GetPlayerPed(source)
    local coords = GetEntityCoords(adminPed)
    
    TriggerClientEvent('sl-admin:client:TeleportToCoords', playerId, coords)
    
    local adminName = GetPlayerName(source)
    local playerName = GetPlayerName(playerId)
    
    if Config.LogActions['admin_bring'] then
        LogToDiscord('admin', Lang:t('logs.admin_bring', {adminName, playerName}))
    end
end)

RegisterNetEvent('sl-admin:server:GiveItem', function(playerId, item, amount)
    local source = source
    if not HasPermission(source, 'giveitem') then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.no_permission'), 'error')
        return
    end

    local targetPlayer = SLCore.Functions.GetPlayer(playerId)
    if not targetPlayer then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.player_not_found'), 'error')
        return
    end

    if not SLCore.Shared.Items[item] then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.invalid_item'), 'error')
        return
    end

    targetPlayer.Functions.AddItem(item, amount)
    
    local adminName = GetPlayerName(source)
    local playerName = GetPlayerName(playerId)
    
    if Config.LogActions['item_given'] then
        LogToDiscord('admin', Lang:t('logs.item_given', {adminName, playerName, amount, item}))
    end
end)

-- Report System
RegisterNetEvent('sl-admin:server:SubmitReport', function(message)
    local source = source
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return end

    if #message < Config.MinReportLength then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.report_too_short'), 'error')
        return
    end

    if #message > Config.MaxReportLength then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.report_too_long'), 'error')
        return
    end

    local reportId = #Reports + 1
    Reports[reportId] = {
        id = reportId,
        player = source,
        message = message,
        name = GetPlayerName(source),
        timestamp = os.time(),
        status = 'open',
        handler = nil
    }

    -- Notify admins
    if Config.NotifyAdminsOnReport then
        local players = SLCore.Functions.GetPlayers()
        for _, v in ipairs(players) do
            if HasPermission(v, 'reports') then
                TriggerClientEvent('sl-core:client:Notify', v, Lang:t('info.received_report', {GetPlayerName(source), message}), 'info')
            end
        end
    end

    if Config.LogActions['report_handled'] then
        LogToDiscord('reports', string.format('New report from %s: %s', GetPlayerName(source), message))
    end
end)

-- Spectate System
RegisterNetEvent('sl-admin:server:SpectatePlayer', function(playerId)
    local source = source
    if not HasPermission(source, 'spectate') then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.no_permission'), 'error')
        return
    end

    if SpectatingPlayers[source] then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.already_spectating'), 'error')
        return
    end

    local targetPlayer = SLCore.Functions.GetPlayer(playerId)
    if not targetPlayer then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.player_not_found'), 'error')
        return
    end

    SpectatingPlayers[source] = playerId
    TriggerClientEvent('sl-admin:client:BeginSpectate', source, playerId)
    
    if Config.SpectateNotifyTarget then
        TriggerClientEvent('sl-core:client:Notify', playerId, Lang:t('info.being_spectated'), 'info')
    end
end)

-- Vehicle Management
RegisterNetEvent('sl-admin:server:SpawnVehicle', function(model)
    local source = source
    if not HasPermission(source, 'vehicle') then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.no_permission'), 'error')
        return
    end

    TriggerClientEvent('sl-admin:client:SpawnVehicle', source, model)
    
    local adminName = GetPlayerName(source)
    
    if Config.LogActions['vehicle_spawned'] then
        LogToDiscord('admin', Lang:t('logs.vehicle_spawned', {adminName, model}))
    end
end)

RegisterNetEvent('sl-admin:server:DeleteVehicle', function()
    local source = source
    if not HasPermission(source, 'vehicle') then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.no_permission'), 'error')
        return
    end

    TriggerClientEvent('sl-admin:client:DeleteVehicle', source)
    
    local adminName = GetPlayerName(source)
    
    if Config.LogActions['vehicle_deleted'] then
        LogToDiscord('admin', Lang:t('logs.vehicle_deleted', {adminName}))
    end
end)

-- Weather and Time Control
RegisterNetEvent('sl-admin:server:SetWeather', function(weather)
    local source = source
    if not HasPermission(source, 'weather') then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.no_permission'), 'error')
        return
    end

    TriggerClientEvent('sl-admin:client:SetWeather', -1, weather)
    
    local adminName = GetPlayerName(source)
    
    if Config.LogActions['weather_changed'] then
        LogToDiscord('admin', Lang:t('logs.weather_changed', {adminName, weather}))
    end
end)

RegisterNetEvent('sl-admin:server:SetTime', function(hour)
    local source = source
    if not HasPermission(source, 'time') then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.no_permission'), 'error')
        return
    end

    TriggerClientEvent('sl-admin:client:SetTime', -1, hour)
    
    local adminName = GetPlayerName(source)
    
    if Config.LogActions['time_changed'] then
        LogToDiscord('admin', Lang:t('logs.time_changed', {adminName, hour}))
    end
end)

-- Developer Tools
RegisterNetEvent('sl-admin:server:ToggleDevMode', function()
    local source = source
    if not HasPermission(source, 'developer') then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.no_permission'), 'error')
        return
    end

    TriggerClientEvent('sl-admin:client:ToggleDevMode', source)
end)

RegisterNetEvent('sl-admin:server:OpenInventory', function(playerId)
    local source = source
    if not HasPermission(source, 'inventory') then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.no_permission'), 'error')
        return
    end

    local targetPlayer = SLCore.Functions.GetPlayer(playerId)
    if not targetPlayer then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.player_not_found'), 'error')
        return
    end

    TriggerClientEvent('sl-inventory:client:OpenPlayerInventory', source, playerId)
    
    local adminName = GetPlayerName(source)
    local playerName = GetPlayerName(playerId)
    
    if Config.LogActions['inventory_opened'] then
        LogToDiscord('admin', Lang:t('logs.inventory_opened', {adminName, playerName}))
    end
end)

-- Player State Management
RegisterNetEvent('sl-admin:server:FreezePlayer', function(playerId)
    local source = source
    if not HasPermission(source, 'freeze') then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.no_permission'), 'error')
        return
    end

    local targetPlayer = SLCore.Functions.GetPlayer(playerId)
    if not targetPlayer then
        TriggerClientEvent('sl-core:client:Notify', source, Lang:t('error.player_not_found'), 'error')
        return
    end

    FrozenPlayers[playerId] = not FrozenPlayers[playerId]
    TriggerClientEvent('sl-admin:client:SetFrozen', playerId, FrozenPlayers[playerId])
end)

-- Resource Events
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    
    -- Initialize database tables
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS bans (
            id INT AUTO_INCREMENT PRIMARY KEY,
            name VARCHAR(50),
            license VARCHAR(50),
            discord VARCHAR(50),
            ip VARCHAR(50),
            reason TEXT,
            expire INT(11),
            bannedby VARCHAR(50),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ]], {})

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS admin_logs (
            id INT AUTO_INCREMENT PRIMARY KEY,
            admin VARCHAR(50),
            action VARCHAR(50),
            target VARCHAR(50),
            details TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ]], {})
end)

AddEventHandler('playerDropped', function()
    local source = source
    if SpectatingPlayers[source] then
        SpectatingPlayers[source] = nil
    end
    if FrozenPlayers[source] then
        FrozenPlayers[source] = nil
    end
end)

-- Exports
exports('IsPlayerAdmin', IsPlayerAdmin)
exports('HasPermission', HasPermission)
exports('GetReports', function() return Reports end)
exports('GetSpectatingPlayers', function() return SpectatingPlayers end)
exports('GetFrozenPlayers', function() return FrozenPlayers end)
