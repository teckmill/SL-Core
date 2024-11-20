local SLCore = exports['sl-core']:GetCoreObject()

-- Player Events
RegisterNetEvent('SLCore:Server:OnPlayerLoaded', function(source)
    local Player = SLCore.Functions.GetPlayer(source)
    if Player then
        -- Update player state
        Player.PlayerData.loggedIn = true
        Player.Functions.Save()
        
        -- Send initial data to client
        TriggerClientEvent('SLCore:Client:OnPlayerLoaded', source)
        TriggerClientEvent('SLCore:Client:SetPlayerData', source, Player.PlayerData)
        
        -- Trigger hooks
        TriggerEvent('SLCore:Server:PlayerLoaded', source, Player)
    end
end)

RegisterNetEvent('SLCore:Server:OnPlayerUnload', function(source)
    local Player = SLCore.Functions.GetPlayer(source)
    if Player then
        -- Save and cleanup
        Player.Functions.Save()
        SLCore.Players[source] = nil
    end
end)

-- Money Events
RegisterNetEvent('SLCore:Server:AddMoney', function(source, moneytype, amount, reason)
    local Player = SLCore.Functions.GetPlayer(source)
    if Player then
        Player.Functions.AddMoney(moneytype, amount, reason)
    end
end)

RegisterNetEvent('SLCore:Server:RemoveMoney', function(source, moneytype, amount, reason)
    local Player = SLCore.Functions.GetPlayer(source)
    if Player then
        Player.Functions.RemoveMoney(moneytype, amount, reason)
    end
end)

-- Item Events
RegisterNetEvent('SLCore:Server:AddItem', function(source, item, amount, slot)
    local Player = SLCore.Functions.GetPlayer(source)
    if Player then
        Player.Functions.AddItem(item, amount, slot)
    end
end)

RegisterNetEvent('SLCore:Server:RemoveItem', function(source, item, amount, slot)
    local Player = SLCore.Functions.GetPlayer(source)
    if Player then
        Player.Functions.RemoveItem(item, amount, slot)
    end
end)

-- Job Events
RegisterNetEvent('SLCore:Server:SetJob', function(source, job, grade)
    local Player = SLCore.Functions.GetPlayer(source)
    if Player then
        Player.Functions.SetJob(job, grade)
    end
end)

-- Gang Events
RegisterNetEvent('SLCore:Server:SetGang', function(source, gang, grade)
    local Player = SLCore.Functions.GetPlayer(source)
    if Player then
        Player.Functions.SetGang(gang, grade)
    end
end)

-- Metadata Events
RegisterNetEvent('SLCore:Server:SetMetaData', function(source, meta, val)
    local Player = SLCore.Functions.GetPlayer(source)
    if Player then
        Player.Functions.SetMetaData(meta, val)
    end
end)

-- Permission Events
RegisterNetEvent('SLCore:Server:SetPermission', function(source, permission)
    local Player = SLCore.Functions.GetPlayer(source)
    if Player then
        SLCore.Functions.AddPermission(source, permission)
    end
end)

-- Callback Registration
SLCore.Functions.CreateCallback('SLCore:Server:HasItem', function(source, cb, items)
    local Player = SLCore.Functions.GetPlayer(source)
    if Player then
        if type(items) == 'table' then
            local result = {}
            for _, item in pairs(items) do
                result[item] = Player.Functions.GetItemByName(item)
            end
            cb(result)
        else
            cb(Player.Functions.GetItemByName(items))
        end
    else
        cb(nil)
    end
end)
