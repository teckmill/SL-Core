local SLCore = exports['sl-core']:GetCoreObject()
local BanList = {}

-- Load bans from database on resource start
CreateThread(function()
    MySQL.query('SELECT * FROM bans', {}, function(result)
        if result then
            for _, ban in ipairs(result) do
                BanList[ban.license] = {
                    name = ban.name,
                    license = ban.license,
                    reason = ban.reason,
                    expire = ban.expire,
                    bannedby = ban.bannedby
                }
            end
        end
    end)
end)

-- Check if a player is banned
function IsPlayerBanned(license)
    if not BanList[license] then return false end
    
    -- Check if ban has expired
    if BanList[license].expire ~= 0 and os.time() > BanList[license].expire then
        -- Remove expired ban
        MySQL.query('DELETE FROM bans WHERE license = ?', {license})
        BanList[license] = nil
        return false
    end
    
    return true
end
exports('IsPlayerBanned', IsPlayerBanned)

-- Ban a player
function BanPlayer(playerId, duration, reason, adminId)
    local targetPlayer = SLCore.Functions.GetPlayer(playerId)
    if not targetPlayer then return false end
    
    local license = targetPlayer.PlayerData.license
    local name = GetPlayerName(playerId)
    local adminName = GetPlayerName(adminId)
    local expireTime = duration > 0 and (os.time() + (duration * 3600)) or 0
    
    -- Save to database
    MySQL.insert('INSERT INTO bans (name, license, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?)',
        {name, license, reason, expireTime, adminName},
        function()
            BanList[license] = {
                name = name,
                license = license,
                reason = reason,
                expire = expireTime,
                bannedby = adminName
            }
            
            -- Kick the player
            DropPlayer(playerId, string.format('Banned: %s\nExpires: %s\nBanned by: %s', 
                reason,
                expireTime > 0 and os.date('%Y-%m-%d %H:%M:%S', expireTime) or 'Never',
                adminName
            ))
        end
    )
    
    return true
end
exports('BanPlayer', BanPlayer)

-- Unban a player
function UnbanPlayer(identifier, adminId)
    if not BanList[identifier] then return false end
    
    MySQL.query('DELETE FROM bans WHERE license = ?', {identifier}, function()
        BanList[identifier] = nil
    end)
    
    return true
end
exports('UnbanPlayer', UnbanPlayer)

-- Get ban info
function GetBanInfo(identifier)
    return BanList[identifier]
end
exports('GetBanInfo', GetBanInfo)

-- Get all bans
function GetAllBans()
    return BanList
end
exports('GetAllBans', GetAllBans)

-- Check player on connection
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local source = source
    local license = SLCore.Functions.GetIdentifier(source, 'license')
    
    deferrals.defer()
    Wait(50)
    
    deferrals.update('Checking ban status...')
    
    if IsPlayerBanned(license) then
        local banInfo = BanList[license]
        local expire = banInfo.expire > 0 and os.date('%Y-%m-%d %H:%M:%S', banInfo.expire) or 'Never'
        
        deferrals.done(string.format(
            'You are banned from this server!\nReason: %s\nExpires: %s\nBanned by: %s',
            banInfo.reason,
            expire,
            banInfo.bannedby
        ))
    else
        deferrals.done()
    end
end)
