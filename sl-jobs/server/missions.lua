local SLCore = exports['sl-core']:GetCoreObject()

-- Mission Configuration
local Missions = {
    delivery = {
        reward = 500,
        xp = 100
    },
    patrol = {
        reward = 750,
        xp = 150
    }
}

-- Mission Functions
function GiveMissionReward(source, missionType)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return end
    
    local mission = Missions[missionType]
    if not mission then return end
    
    -- Give money reward
    Player.Functions.AddMoney('bank', mission.reward, 'Mission Completion: ' .. missionType)
    
    -- Add XP if applicable
    if mission.xp then
        TriggerEvent('sl-skills:server:AddXP', source, 'jobskill', mission.xp)
    end
    
    -- Log mission completion
    TriggerEvent('sl-log:server:CreateLog', 'jobs', 'Mission Completed', 'green', 
        string.format('%s completed mission %s and earned $%d', 
            GetPlayerName(source), missionType, mission.reward))
end

-- Events
RegisterNetEvent('sl-jobs:server:CompleteMission')
AddEventHandler('sl-jobs:server:CompleteMission', function(missionType)
    local src = source
    GiveMissionReward(src, missionType)
end)

-- Callbacks
SLCore.Functions.CreateCallback('sl-jobs:server:GetAvailableMissions', function(source, cb)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end
    
    local job = Player.PlayerData.job
    local availableMissions = {}
    
    -- Add missions based on job
    if job.name == 'police' then
        availableMissions = {
            {type = 'patrol', label = 'City Patrol', description = 'Patrol marked areas of the city'},
        }
    elseif job.name == 'ambulance' then
        availableMissions = {
            {type = 'delivery', label = 'Medical Supplies', description = 'Deliver medical supplies to clinics'},
        }
    end
    
    cb(availableMissions)
end)
