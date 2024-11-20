local SLCore = exports['sl-core']:GetCoreObject()

-- Player Exports
exports('GetPlayer', function(source)
    return SLCore.Functions.GetPlayer(source)
end)

exports('GetPlayers', function()
    return SLCore.Functions.GetPlayers()
end)

exports('GetPlayerByCitizenId', function(citizenid)
    return SLCore.Functions.GetPlayerByCitizenId(citizenid)
end)

exports('GetOfflinePlayerByCitizenId', function(citizenid)
    return SLCore.Functions.GetOfflinePlayerByCitizenId(citizenid)
end)

-- Item Exports
exports('GetItems', function()
    return SLCore.Shared.Items
end)

exports('GetItemByName', function(item)
    return SLCore.Shared.Items[item]
end)

-- Vehicle Exports
exports('GetVehiclesByName', function(name)
    return SLCore.Shared.Vehicles[name]
end)

-- Job Exports
exports('GetJobs', function()
    return SLCore.Shared.Jobs
end)

exports('GetJob', function(name)
    return SLCore.Shared.Jobs[name]
end)

-- Gang Exports
exports('GetGangs', function()
    return SLCore.Shared.Gangs
end)

exports('GetGang', function(name)
    return SLCore.Shared.Gangs[name]
end)

-- Permission Exports
exports('AddPermission', function(source, permission)
    return SLCore.Functions.AddPermission(source, permission)
end)

exports('RemovePermission', function(source)
    return SLCore.Functions.RemovePermission(source)
end)

-- Utility Exports
exports('GetIdentifier', function(source, idtype)
    return SLCore.Functions.GetIdentifier(source, idtype)
end)

exports('GetSource', function(identifier)
    return SLCore.Functions.GetSource(identifier)
end)

exports('GetPlayerByPhone', function(number)
    return SLCore.Functions.GetPlayerByPhone(number)
end)

-- Callback Exports
exports('CreateCallback', function(name, cb)
    return SLCore.Functions.CreateCallback(name, cb)
end)

exports('TriggerCallback', function(name, source, cb, ...)
    return SLCore.Functions.TriggerCallback(name, source, cb, ...)
end)
