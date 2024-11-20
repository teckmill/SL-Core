local SLCore = exports['sl-core']:GetCoreObject()

-- Admin Commands
SLCore.Commands.Add('createhouse', 'Create a new house (Admin Only)', {
    {name = 'price', help = 'House price'},
    {name = 'shell', help = 'Shell type (optional)'},
}, true, function(source, args)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player.PlayerData.job.name == 'realestate' and not Player.PlayerData.job.grade.level >= 3 then
        TriggerClientEvent('SLCore:Notify', src, 'You do not have permission to use this command', 'error')
        return
    end
    
    local price = tonumber(args[1])
    local shell = args[2]
    
    if not price or price <= 0 then
        TriggerClientEvent('SLCore:Notify', src, 'Invalid price', 'error')
        return
    end
    
    TriggerClientEvent('sl-housing:client:CreateHouse', src, price, shell)
end)

SLCore.Commands.Add('deletehouse', 'Delete a house (Admin Only)', {
    {name = 'id', help = 'House ID'},
}, true, function(source, args)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player.PlayerData.job.name == 'realestate' and not Player.PlayerData.job.grade.level >= 3 then
        TriggerClientEvent('SLCore:Notify', src, 'You do not have permission to use this command', 'error')
        return
    end
    
    local houseId = args[1]
    if not houseId then
        TriggerClientEvent('SLCore:Notify', src, 'Invalid house ID', 'error')
        return
    end
    
    TriggerClientEvent('sl-housing:client:DeleteHouse', src, houseId)
end)

SLCore.Commands.Add('houseprice', 'Change house price (Admin Only)', {
    {name = 'id', help = 'House ID'},
    {name = 'price', help = 'New price'},
}, true, function(source, args)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player.PlayerData.job.name == 'realestate' and not Player.PlayerData.job.grade.level >= 2 then
        TriggerClientEvent('SLCore:Notify', src, 'You do not have permission to use this command', 'error')
        return
    end
    
    local houseId = args[1]
    local price = tonumber(args[2])
    
    if not houseId or not price or price <= 0 then
        TriggerClientEvent('SLCore:Notify', src, 'Invalid parameters', 'error')
        return
    end
    
    TriggerClientEvent('sl-housing:client:SetHousePrice', src, houseId, price)
end)

-- Player Commands
SLCore.Commands.Add('house', 'View house information', {}, false, function(source, args)
    local src = source
    TriggerClientEvent('sl-housing:client:ViewOwnedHouses', src)
end)

SLCore.Commands.Add('knock', 'Knock on a door', {}, false, function(source, args)
    local src = source
    TriggerClientEvent('sl-housing:client:KnockOnDoor', src)
end)

SLCore.Commands.Add('givekeys', 'Give house keys to nearby player', {}, false, function(source, args)
    local src = source
    TriggerClientEvent('sl-housing:client:GiveKeys', src)
end)

SLCore.Commands.Add('removekeys', 'Remove house keys from someone', {
    {name = 'id', help = 'Player ID'},
}, false, function(source, args)
    local src = source
    local targetId = tonumber(args[1])
    
    if not targetId then
        TriggerClientEvent('SLCore:Notify', src, 'Invalid player ID', 'error')
        return
    end
    
    TriggerClientEvent('sl-housing:client:RemoveKeys', src, targetId)
end)

SLCore.Commands.Add('houselocations', 'View all house locations (Real Estate Only)', {}, false, function(source, args)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player.PlayerData.job.name == 'realestate' then
        TriggerClientEvent('SLCore:Notify', src, 'You do not have permission to use this command', 'error')
        return
    end
    
    TriggerClientEvent('sl-housing:client:ViewAllHouses', src)
end)

SLCore.Commands.Add('houseteleport', 'Teleport to a house (Admin Only)', {
    {name = 'id', help = 'House ID'},
}, true, function(source, args)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player.PlayerData.job.name == 'realestate' and not Player.PlayerData.job.grade.level >= 3 then
        TriggerClientEvent('SLCore:Notify', src, 'You do not have permission to use this command', 'error')
        return
    end
    
    local houseId = args[1]
    if not houseId then
        TriggerClientEvent('SLCore:Notify', src, 'Invalid house ID', 'error')
        return
    end
    
    TriggerClientEvent('sl-housing:client:TeleportToHouse', src, houseId)
end)
