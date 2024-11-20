local SLCore = exports['sl-core']:GetCoreObject()
local CoreReady = true

-- Events
RegisterNetEvent('sl-fuel:server:PayForFuel', function(amount)
    if not CoreReady then return end
    
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end

    local cost = math.floor(amount * Config.CostMultiplier)
    local tax = math.floor(cost * Config.GlobalTax)
    local total = cost + tax

    if Player.Functions.RemoveMoney('cash', total, "fuel-purchase") then
        -- Add tax to society account
        exports['sl-banking']:AddAccountMoney('government', tax)
        TriggerClientEvent('sl-fuel:client:RefuelVehicle', src, amount)
    else
        TriggerClientEvent('SLCore:Notify', src, 'Not enough money', 'error')
    end
end)

RegisterNetEvent('sl-fuel:server:BuyJerryCan', function()
    if not CoreReady then return end
    
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end

    if Player.Functions.RemoveMoney('cash', Config.JerryCanCost, "jerrycan-purchase") then
        Player.Functions.AddItem('jerrycan', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, SLCore.Shared.Items['jerrycan'], 'add')
    else
        TriggerClientEvent('SLCore:Notify', src, 'Not enough money', 'error')
    end
end)

-- Callbacks
SLCore.Functions.CreateCallback('sl-fuel:server:GetConfig', function(source, cb)
    cb(Config)
end)
