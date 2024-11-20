local SLCore = exports['sl-core']:GetCoreObject()
local OnlinePlayers = {}
local BannedPlayers = {}

-- Load banned players from database
local function LoadBannedPlayers()
    local result = MySQL.query.await('SELECT * FROM bans')
    if result then
        for _, ban in ipairs(result) do
            BannedPlayers[ban.license] = {
                name = ban.name,
                license = ban.license,
                discord = ban.discord,
                ip = ban.ip,
                reason = ban.reason,
                expire = ban.expire,
                bannedby = ban.bannedby
            }
        end
    end
end

-- Update online players list
local function UpdateOnlinePlayers()
    local players = GetPlayers()
    local tempPlayers = {}
    
    for _, playerId in ipairs(players) do
        local Player = SLCore.Functions.GetPlayer(tonumber(playerId))
        if Player then
            local ped = GetPlayerPed(playerId)
            local coords = GetEntityCoords(ped)
            
            tempPlayers[playerId] = {
                source = playerId,
                name = GetPlayerName(playerId),
                citizenid = Player.PlayerData.citizenid,
                cid = Player.PlayerData.cid,
                license = Player.PlayerData.license,
                discord = Player.PlayerData.discord,
                ip = GetPlayerEndpoint(playerId),
                health = GetEntityHealth(ped),
                armor = GetPedArmour(ped),
                position = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z
                },
                job = Player.PlayerData.job,
                gang = Player.PlayerData.gang,
                metadata = Player.PlayerData.metadata
            }
        end
    end
    
    OnlinePlayers = tempPlayers
    TriggerClientEvent('sl-admin:client:UpdatePlayers', -1, OnlinePlayers)
end

-- Event handlers
RegisterNetEvent('sl-admin:server:GetPlayers', function()
    local src = source
    TriggerClientEvent('sl-admin:client:UpdatePlayers', src, OnlinePlayers)
end)

RegisterNetEvent('sl-admin:server:KickPlayer', function(playerId, reason)
    local src = source
    if not SLCore.Functions.HasPermission(src, 'admin') then return end
    
    local Player = SLCore.Functions.GetPlayer(tonumber(playerId))
    if Player then
        DropPlayer(playerId, reason or 'Kicked by admin')
        TriggerClientEvent('sl-core:client:Notify', src, 'Player kicked: ' .. reason, 'success')
    end
end)

RegisterNetEvent('sl-admin:server:BanPlayer', function(playerId, reason, length)
    local src = source
    if not SLCore.Functions.HasPermission(src, 'admin') then return end
    
    local Player = SLCore.Functions.GetPlayer(tonumber(playerId))
    if Player then
        local adminName = GetPlayerName(src)
        local banTime = length and os.time() + (length * 3600) or 2147483647
        
        MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)',
            {Player.PlayerData.name, Player.PlayerData.license, Player.PlayerData.discord, GetPlayerEndpoint(playerId),
             reason, banTime, adminName})
        
        BannedPlayers[Player.PlayerData.license] = {
            name = Player.PlayerData.name,
            license = Player.PlayerData.license,
            discord = Player.PlayerData.discord,
            ip = GetPlayerEndpoint(playerId),
            reason = reason,
            expire = banTime,
            bannedby = adminName
        }
        
        DropPlayer(playerId, 'Banned: ' .. reason)
        TriggerClientEvent('sl-core:client:Notify', src, 'Player banned: ' .. reason, 'success')
    end
end)

RegisterNetEvent('sl-admin:server:UnbanPlayer', function(license)
    local src = source
    if not SLCore.Functions.HasPermission(src, 'admin') then return end
    
    MySQL.query('DELETE FROM bans WHERE license = ?', {license})
    BannedPlayers[license] = nil
    TriggerClientEvent('sl-core:client:Notify', src, 'Player unbanned', 'success')
end)

RegisterNetEvent('sl-admin:server:TeleportToPlayer', function(playerId)
    local src = source
    if not SLCore.Functions.HasPermission(src, 'admin') then return end
    
    local targetPed = GetPlayerPed(playerId)
    local coords = GetEntityCoords(targetPed)
    TriggerClientEvent('sl-admin:client:TeleportToCoords', src, coords)
end)

RegisterNetEvent('sl-admin:server:BringPlayer', function(playerId)
    local src = source
    if not SLCore.Functions.HasPermission(src, 'admin') then return end
    
    local adminPed = GetPlayerPed(src)
    local coords = GetEntityCoords(adminPed)
    TriggerClientEvent('sl-admin:client:TeleportToCoords', playerId, coords)
end)

-- Initialization
CreateThread(function()
    LoadBannedPlayers()
    
    while true do
        UpdateOnlinePlayers()
        Wait(5000) -- Update every 5 seconds
    end
end)

-- Exports
exports('GetOnlinePlayers', function()
    return OnlinePlayers
end)

exports('GetBannedPlayers', function()
    return BannedPlayers
end)
