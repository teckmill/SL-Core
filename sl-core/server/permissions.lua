-- Permissions System
SLCore.Permissions = {}

-- Permission Levels
SLCore.Permissions.Levels = {
    ['user'] = 0,
    ['helper'] = 1,
    ['moderator'] = 2,
    ['admin'] = 3,
    ['superadmin'] = 4,
    ['owner'] = 5
}

-- Get permission level
function SLCore.Permissions.GetLevel(permission)
    return SLCore.Permissions.Levels[permission] or 0
end

-- Check if permission level is sufficient
function SLCore.Permissions.HasPermission(source, requiredPermission)
    if source == 0 then return true end -- Console always has permission
    
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local playerPermLevel = SLCore.Permissions.GetLevel(Player.PlayerData.permission)
    local requiredPermLevel = SLCore.Permissions.GetLevel(requiredPermission)
    
    return playerPermLevel >= requiredPermLevel
end

-- Add permission to player
function SLCore.Permissions.AddPermission(source, permission)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    Player.PlayerData.permission = permission
    Player.Functions.Save()
    
    TriggerClientEvent('sl-core:client:notify', source, {
        type = 'success',
        message = 'Permission updated to: ' .. permission,
        duration = 5000
    })
    
    return true
end

-- Register permission commands
Citizen.CreateThread(function()
    SLCore.Commands.Add("setpermission", "Set a player's permission level", {
        {name = "id", help = "Player ID"},
        {name = "permission", help = "Permission level"}
    }, true, function(source, args)
        if source ~= 0 then -- Only console can set permissions
            TriggerClientEvent('sl-core:client:notify', source, {
                type = 'error',
                message = 'Only console can set permissions',
                duration = 5000
            })
            return
        end
        
        local Player = SLCore.Functions.GetPlayer(tonumber(args[1]))
        if not Player then return end
        
        if not SLCore.Permissions.Levels[args[2]] then
            print('Invalid permission level')
            return
        end
        
        SLCore.Permissions.AddPermission(tonumber(args[1]), args[2])
        print('Permission set for ' .. Player.PlayerData.name .. ' to ' .. args[2])
    end)
end)

-- Add permission column to players table if it doesn't exist
MySQL.ready(function()
    MySQL.query.await([[
        ALTER TABLE players
        ADD COLUMN IF NOT EXISTS permission VARCHAR(50) DEFAULT 'user'
    ]])
end)
