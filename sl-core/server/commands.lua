SLCore.Commands = {}
SLCore.Commands.List = {}

SLCore.Commands.Add = function(name, help, arguments, argsrequired, callback, permission)
    SLCore.Commands.List[name:lower()] = {
        name = name:lower(),
        permission = permission,
        help = help,
        arguments = arguments,
        argsrequired = argsrequired,
        callback = callback
    }
end

SLCore.Commands.Refresh = function(source)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return end
    for command, info in pairs(SLCore.Commands.List) do
        if SLCore.Functions.HasPermission(source, info.permission) then
            TriggerClientEvent('chat:addSuggestion', source, '/' .. command, info.help, info.arguments)
        end
    end
end

-- Default commands
SLCore.Commands.Add('tp', 'Teleport to a player or coords (Admin Only)', {}, false, function(source, args)
    if not args[1] and not args[2] and not args[3] then
        return
    end
    if args[1] and not args[2] and not args[3] then
        local target = tonumber(args[1])
        if target ~= source then
            if GetPlayerPing(target) ~= 0 then
                local targetCoords = GetEntityCoords(GetPlayerPed(target))
                TriggerClientEvent('SLCore:Command:TeleportToPlayer', source, targetCoords)
            else
                TriggerClientEvent('SLCore:Notify', source, 'Player not online', 'error')
            end
        else
            TriggerClientEvent('SLCore:Notify', source, 'You cannot teleport to yourself', 'error')
        end
    end
end, 'admin')
