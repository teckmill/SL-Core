local SLCore = exports['sl-core']:GetCoreObject()
local CoreReady = true

-- Events
RegisterNetEvent('sl-mechanics:server:BillCustomer', function(playerId, amount)
    if not CoreReady then return end
    
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    local Customer = SLCore.Functions.GetPlayer(tonumber(playerId))
    
    if not Player or not Customer then return end
    
    if Config.MechanicJobs[Player.PlayerData.job.name] then
        if Customer.Functions.RemoveMoney('bank', amount, "mechanic-bill") then
            Player.Functions.AddMoney('bank', math.floor(amount * 0.8), "mechanic-bill")
            -- Add 20% to society account
            exports['sl-banking']:AddAccountMoney(Player.PlayerData.job.name, math.floor(amount * 0.2))
            TriggerClientEvent('SLCore:Notify', Customer.PlayerData.source, 'You have been billed for $'..amount, 'error')
            TriggerClientEvent('SLCore:Notify', src, 'You billed the customer for $'..amount, 'success')
        else
            TriggerClientEvent('SLCore:Notify', src, 'Customer cannot afford the bill', 'error')
        end
    end
end)

RegisterNetEvent('sl-mechanics:server:RemoveItem', function(item, amount)
    if not CoreReady then return end
    
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    
    if Player and Config.MechanicJobs[Player.PlayerData.job.name] then
        Player.Functions.RemoveItem(item, amount)
        TriggerClientEvent('inventory:client:ItemBox', src, SLCore.Shared.Items[item], "remove")
    end
end)

-- Callbacks
SLCore.Functions.CreateCallback('sl-mechanics:server:GetConfig', function(source, cb)
    cb(Config)
end)

SLCore.Functions.CreateCallback('sl-mechanics:server:HasRequiredItems', function(source, cb, items)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    local hasItems = true
    
    if Player then
        for item, amount in pairs(items) do
            if Player.Functions.GetItemByName(item).amount < amount then
                hasItems = false
                break
            end
        end
    end
    
    cb(hasItems)
end)
