-- Player Exports

exports('GetCoreObject', function()
    return SLCore
end)

exports('GetPlayer', function(source)
    return SLCore.Functions.GetPlayer(source)
end)

exports('GetPlayers', function()
    return SLCore.Functions.GetPlayers()
end)

exports('GetQueuedPlayers', function()
    return SLCore.Config.Server.Queue
end)

-- Item Exports

exports('GetItems', function()
    return SLCore.Shared.Items
end)

exports('GetWeapons', function()
    return SLCore.Shared.Weapons
end)

-- Vehicle Exports

exports('GetVehicles', function()
    return SLCore.Shared.Vehicles
end)

-- Gang Exports

exports('GetGangs', function()
    return SLCore.Shared.Gangs
end)

-- Job Exports

exports('GetJobs', function()
    return SLCore.Shared.Jobs
end)

-- Utility Exports

exports('GetIdentifier', function(source, idtype)
    return SLCore.Functions.GetIdentifier(source, idtype)
end)

exports('GetSource', function(identifier)
    return SLCore.Functions.GetSource(identifier)
end)

exports('GetPermission', function(source)
    return SLCore.Functions.GetPermission(source)
end)

exports('HasPermission', function(source, permission)
    return SLCore.Functions.HasPermission(source, permission)
end)

-- Callback Exports

exports('CreateCallback', function(name, cb)
    SLCore.Functions.CreateCallback(name, cb)
end)

exports('TriggerCallback', function(name, source, cb, ...)
    SLCore.Functions.TriggerCallback(name, source, cb, ...)
end)

-- Command Exports

exports('CreateCommand', function(name, help, arguments, argsrequired, callback, permission)
    SLCore.Commands.Add(name, help, arguments, argsrequired, callback, permission)
end)

exports('GetCommands', function()
    return SLCore.Commands.List
end)

-- Item Exports

exports('CreateUseableItem', function(item, data)
    SLCore.Functions.CreateUseableItem(item, data)
end)

exports('CanUseItem', function(item)
    return SLCore.Functions.CanUseItem(item)
end)

-- Money Exports

exports('AddMoney', function(source, moneytype, amount, reason)
    local Player = SLCore.Functions.GetPlayer(source)
    if Player then
        return Player.Functions.AddMoney(moneytype, amount, reason)
    end
    return false
end)

exports('RemoveMoney', function(source, moneytype, amount, reason)
    local Player = SLCore.Functions.GetPlayer(source)
    if Player then
        return Player.Functions.RemoveMoney(moneytype, amount, reason)
    end
    return false
end)

exports('GetMoney', function(source, moneytype)
    local Player = SLCore.Functions.GetPlayer(source)
    if Player then
        return Player.Functions.GetMoney(moneytype)
    end
    return 0
end)
