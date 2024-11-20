SLCore.Functions = {}

function SLCore.Functions.CreateCallback(name, cb)
    SLCore.ServerCallbacks[name] = cb
end

function SLCore.Functions.TriggerCallback(name, source, cb, ...)
    if SLCore.ServerCallbacks[name] then
        SLCore.ServerCallbacks[name](source, cb, ...)
    end
end

function SLCore.Functions.GetIdentifier(source, idtype)
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in pairs(identifiers) do
        if string.find(identifier, idtype) then
            return identifier
        end
    end
    return nil
end

function SLCore.Functions.GetSource(identifier)
    for src, _ in pairs(SLCore.Players) do
        local idens = GetPlayerIdentifiers(src)
        for _, id in pairs(idens) do
            if identifier == id then
                return src
            end
        end
    end
    return nil
end

function SLCore.Functions.GetPlayer(source)
    if type(source) == 'number' then
        return SLCore.Players[source]
    else
        return SLCore.Players[SLCore.Functions.GetSource(source)]
    end
end

function SLCore.Functions.GetPlayers()
    local sources = {}
    for k, _ in pairs(SLCore.Players) do
        sources[#sources+1] = k
    end
    return sources
end

function SLCore.Functions.CreateUseableItem(item, cb)
    SLCore.UseableItems[item] = cb
end

function SLCore.Functions.HasPermission(source, permission)
    local license = SLCore.Functions.GetIdentifier(source, 'license')
    if permission == 'admin' or permission == 'god' then
        if IsPlayerAceAllowed(source, 'command') then
            return true
        end
    end
    return false
end

function SLCore.Functions.Kick(source, reason, setKickReason, deferrals)
    reason = '\n' .. reason .. '\n🔸 Check our Discord for further information: ' .. SLCore.Config.Server.Discord
    if setKickReason then
        setKickReason(reason)
    end
    CreateThread(function()
        if deferrals then
            deferrals.update(reason)
            Wait(2500)
        end
        if source then
            DropPlayer(source, reason)
        end
    end)
end
