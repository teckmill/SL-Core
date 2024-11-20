local SLCore = exports['sl-core']:GetCoreObject()

-- Variables
local activeInteriors = {}

-- Interior Management
function AssignInterior(source, interiorType, shellType)
    if not Config.InteriorTypes[interiorType] then return false end
    if not Config.InteriorTypes[interiorType].shells[shellType] then return false end
    
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local identifier = Player.PlayerData.citizenid
    
    -- Check if player already has an interior assigned
    if activeInteriors[identifier] then
        return false, "Player already has an interior assigned"
    end
    
    -- Create interior data
    activeInteriors[identifier] = {
        type = interiorType,
        shell = shellType,
        owner = identifier,
        created = os.time()
    }
    
    -- Trigger client event to load interior
    TriggerClientEvent('sl-interiors:client:LoadInterior', source, interiorType, shellType)
    return true
end

function RemoveInterior(source)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local identifier = Player.PlayerData.citizenid
    
    if not activeInteriors[identifier] then
        return false, "No interior assigned to player"
    end
    
    -- Remove interior data
    activeInteriors[identifier] = nil
    
    -- Trigger client event to unload interior
    TriggerClientEvent('sl-interiors:client:UnloadInterior', source)
    return true
end

-- Events
RegisterNetEvent('sl-interiors:server:AssignInterior', function(interiorType, shellType)
    local source = source
    AssignInterior(source, interiorType, shellType)
end)

RegisterNetEvent('sl-interiors:server:RemoveInterior', function()
    local source = source
    RemoveInterior(source)
end)

-- Admin Commands
SLCore.Commands.Add('assigninterior', 'Assign an interior to a player (Admin Only)', {{name = 'id', help = 'Player ID'}, {name = 'type', help = 'Interior Type'}, {name = 'shell', help = 'Shell Type'}}, true, function(source, args)
    local targetSource = tonumber(args[1])
    local interiorType = args[2]
    local shellType = args[3]
    
    if not targetSource or not interiorType or not shellType then
        TriggerClientEvent('SLCore:Notify', source, 'Invalid arguments', 'error')
        return
    end
    
    local success, error = AssignInterior(targetSource, interiorType, shellType)
    if not success then
        TriggerClientEvent('SLCore:Notify', source, error or 'Failed to assign interior', 'error')
        return
    end
    
    TriggerClientEvent('SLCore:Notify', source, 'Interior assigned successfully', 'success')
end, 'admin')

SLCore.Commands.Add('removeinterior', 'Remove an interior from a player (Admin Only)', {{name = 'id', help = 'Player ID'}}, true, function(source, args)
    local targetSource = tonumber(args[1])
    
    if not targetSource then
        TriggerClientEvent('SLCore:Notify', source, 'Invalid player ID', 'error')
        return
    end
    
    local success, error = RemoveInterior(targetSource)
    if not success then
        TriggerClientEvent('SLCore:Notify', source, error or 'Failed to remove interior', 'error')
        return
    end
    
    TriggerClientEvent('SLCore:Notify', source, 'Interior removed successfully', 'success')
end, 'admin')

-- Player Disconnection
AddEventHandler('playerDropped', function()
    local source = source
    RemoveInterior(source)
end)

-- Exports
exports('AssignInterior', AssignInterior)
exports('RemoveInterior', RemoveInterior)
exports('GetActiveInteriors', function() return activeInteriors end)
