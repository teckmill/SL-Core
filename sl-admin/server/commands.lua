local SLCore = exports['sl-core']:GetCoreObject()

-- Admin Commands
SLCore.Commands.Add('kick', 'Kick a player (Admin Only)', {{name = 'id', help = 'Player ID'}, {name = 'reason', help = 'Kick reason'}}, true, function(source, args)
    local src = source
    if not args[1] or not args[2] then
        TriggerClientEvent('SLCore:Notify', src, 'Invalid arguments', 'error')
        return
    end
    
    local targetId = tonumber(args[1])
    local reason = table.concat(args, ' ', 2)
    
    if not targetId then
        TriggerClientEvent('SLCore:Notify', src, 'Invalid player ID', 'error')
        return
    end
    
    local targetPlayer = SLCore.Functions.GetPlayer(targetId)
    if not targetPlayer then
        TriggerClientEvent('SLCore:Notify', src, 'Player not found', 'error')
        return
    end
    
    DropPlayer(targetId, 'Kicked: ' .. reason)
    TriggerClientEvent('SLCore:Notify', src, 'Player has been kicked', 'success')
    
    -- Log the kick
    TriggerEvent('sl-admin:server:Log', 'kick', {
        admin = GetPlayerName(src),
        target = GetPlayerName(targetId),
        reason = reason
    })
end, 'admin')

SLCore.Commands.Add('ban', 'Ban a player (Admin Only)', {{name = 'id', help = 'Player ID'}, {name = 'time', help = 'Ban duration (hours)'}, {name = 'reason', help = 'Ban reason'}}, true, function(source, args)
    local src = source
    if not args[1] or not args[2] or not args[3] then
        TriggerClientEvent('SLCore:Notify', src, 'Invalid arguments', 'error')
        return
    end
    
    local targetId = tonumber(args[1])
    local duration = tonumber(args[2])
    local reason = table.concat(args, ' ', 3)
    
    if not targetId or not duration then
        TriggerClientEvent('SLCore:Notify', src, 'Invalid arguments', 'error')
        return
    end
    
    local targetPlayer = SLCore.Functions.GetPlayer(targetId)
    if not targetPlayer then
        TriggerClientEvent('SLCore:Notify', src, 'Player not found', 'error')
        return
    end
    
    -- Check if player is already banned
    local isBanned = exports['sl-admin']:IsPlayerBanned(targetPlayer.PlayerData.license)
    if isBanned then
        TriggerClientEvent('SLCore:Notify', src, 'Player is already banned', 'error')
        return
    end
    
    -- Ban player
    local success = exports['sl-admin']:BanPlayer(targetId, duration, reason, src)
    if success then
        TriggerClientEvent('SLCore:Notify', src, 'Player has been banned', 'success')
        
        -- Log the ban
        TriggerEvent('sl-admin:server:Log', 'ban', {
            admin = GetPlayerName(src),
            target = GetPlayerName(targetId),
            duration = duration,
            reason = reason
        })
    else
        TriggerClientEvent('SLCore:Notify', src, 'Failed to ban player', 'error')
    end
end, 'admin')

SLCore.Commands.Add('unban', 'Unban a player (Admin Only)', {{name = 'identifier', help = 'Player License/Steam ID'}}, true, function(source, args)
    local src = source
    if not args[1] then
        TriggerClientEvent('SLCore:Notify', src, 'Please specify an identifier', 'error')
        return
    end
    
    local identifier = args[1]
    local success = exports['sl-admin']:UnbanPlayer(identifier, src)
    
    if success then
        TriggerClientEvent('SLCore:Notify', src, 'Player has been unbanned', 'success')
        
        -- Log the unban
        TriggerEvent('sl-admin:server:Log', 'unban', {
            admin = GetPlayerName(src),
            identifier = identifier
        })
    else
        TriggerClientEvent('SLCore:Notify', src, 'Failed to unban player', 'error')
    end
end, 'admin')

SLCore.Commands.Add('freeze', 'Freeze/Unfreeze a player (Admin Only)', {{name = 'id', help = 'Player ID'}}, true, function(source, args)
    local src = source
    if not args[1] then
        TriggerClientEvent('SLCore:Notify', src, 'Please specify a player ID', 'error')
        return
    end
    
    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('SLCore:Notify', src, 'Invalid player ID', 'error')
        return
    end
    
    local targetPlayer = SLCore.Functions.GetPlayer(targetId)
    if not targetPlayer then
        TriggerClientEvent('SLCore:Notify', src, 'Player not found', 'error')
        return
    end
    
    TriggerClientEvent('sl-admin:client:ToggleFreeze', targetId)
    TriggerClientEvent('SLCore:Notify', src, 'Player freeze toggled', 'success')
end, 'admin')

SLCore.Commands.Add('bring', 'Bring a player to you (Admin Only)', {{name = 'id', help = 'Player ID'}}, true, function(source, args)
    local src = source
    if not args[1] then
        TriggerClientEvent('SLCore:Notify', src, 'Please specify a player ID', 'error')
        return
    end
    
    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('SLCore:Notify', src, 'Invalid player ID', 'error')
        return
    end
    
    local targetPlayer = SLCore.Functions.GetPlayer(targetId)
    if not targetPlayer then
        TriggerClientEvent('SLCore:Notify', src, 'Player not found', 'error')
        return
    end
    
    local adminCoords = GetEntityCoords(GetPlayerPed(src))
    TriggerClientEvent('sl-admin:client:TeleportToCoords', targetId, adminCoords)
    TriggerClientEvent('SLCore:Notify', src, 'Player has been teleported to you', 'success')
end, 'admin')
