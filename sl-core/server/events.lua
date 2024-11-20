RegisterNetEvent('SLCore:Server:TriggerCallback', function(name, ...)
    local src = source
    SLCore.Functions.TriggerCallback(name, src, function(...)
        TriggerClientEvent('SLCore:Client:TriggerCallback', src, name, ...)
    end, ...)
end)

RegisterNetEvent('SLCore:Server:UseItem', function(item)
    local src = source
    if item and item.amount > 0 then
        if SLCore.UseableItems[item.name] then
            SLCore.UseableItems[item.name](source, item)
        end
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    if not SLCore.Players[src] then return end
    local Player = SLCore.Players[src]
    TriggerEvent('SLCore:Server:PlayerDisconnected', src, Player)
    Player.Functions.Save()
    SLCore.Players[src] = nil
end)
