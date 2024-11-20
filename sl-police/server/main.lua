local SLCore = exports['sl-core']:GetCoreObject()

-- Player cache
local cuffedPlayers = {}
local trackedPlayers = {}

-- Handcuff events
RegisterNetEvent('sl-police:server:CuffPlayer', function(playerId, isSoftcuff)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    local Target = SLCore.Functions.GetPlayer(playerId)
    
    if not Player or not Target then return end
    if not Player.PlayerData.job.name == "police" then return end
    
    TriggerClientEvent('sl-police:client:GetCuffed', Target.PlayerData.source, Player.PlayerData.source, isSoftcuff)
    cuffedPlayers[Target.PlayerData.citizenid] = true
end)

RegisterNetEvent('sl-police:server:UncuffPlayer', function(playerId)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    local Target = SLCore.Functions.GetPlayer(playerId)
    
    if not Player or not Target then return end
    if not Player.PlayerData.job.name == "police" then return end
    
    TriggerClientEvent('sl-police:client:GetCuffed', Target.PlayerData.source, Player.PlayerData.source)
    cuffedPlayers[Target.PlayerData.citizenid] = nil
end)

-- Search events
RegisterNetEvent('sl-police:server:SearchPlayer', function(playerId)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    local Target = SLCore.Functions.GetPlayer(playerId)
    
    if not Player or not Target then return end
    if not Player.PlayerData.job.name == "police" then return end
    
    local searchData = {
        cash = Target.PlayerData.money["cash"],
        items = Target.PlayerData.items
    }
    
    TriggerClientEvent('sl-police:client:ShowSearchResults', Player.PlayerData.source, searchData)
end)

-- Tracker events
RegisterNetEvent('sl-police:server:PlaceTracker', function(targetId)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    local Target = SLCore.Functions.GetPlayer(targetId)
    
    if not Player or not Target then return end
    if not Player.PlayerData.job.name == "police" then return end
    
    trackedPlayers[Target.PlayerData.citizenid] = true
    TriggerClientEvent('sl-police:client:StartTracking', Player.PlayerData.source, Target.PlayerData.source)
end)

RegisterNetEvent('sl-police:server:RemoveTracker', function(targetId)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    local Target = SLCore.Functions.GetPlayer(targetId)
    
    if not Player or not Target then return end
    if not Player.PlayerData.job.name == "police" then return end
    
    trackedPlayers[Target.PlayerData.citizenid] = nil
    TriggerClientEvent('sl-police:client:StopTracking', Player.PlayerData.source)
end)

-- Duty events
RegisterNetEvent('sl-police:server:ToggleDuty', function()
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    
    if not Player then return end
    if Player.PlayerData.job.name ~= "police" then return end
    
    if Player.PlayerData.job.onduty then
        Player.Functions.SetJobDuty(false)
        TriggerClientEvent('SLCore:Notify', src, Lang:t('info.offduty'), 'error')
    else
        Player.Functions.SetJobDuty(true)
        TriggerClientEvent('SLCore:Notify', src, Lang:t('info.onduty'), 'success')
    end
    
    TriggerClientEvent('sl-police:client:UpdateDuty', src)
end)

-- Utility functions
SLCore.Functions.CreateCallback('sl-police:server:IsCuffed', function(source, cb, citizenid)
    cb(cuffedPlayers[citizenid] or false)
end)

SLCore.Functions.CreateCallback('sl-police:server:IsTracked', function(source, cb, citizenid)
    cb(trackedPlayers[citizenid] or false)
end)

-- Cleanup on player drop
AddEventHandler('playerDropped', function()
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local citizenid = Player.PlayerData.citizenid
    cuffedPlayers[citizenid] = nil
    trackedPlayers[citizenid] = nil
end)
