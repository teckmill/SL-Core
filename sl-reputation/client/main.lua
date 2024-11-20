local SLCore = exports['sl-core']:GetCoreObject()
local PlayerData = {}
local reputationData = {}

-- Functions
local function LoadReputationData()
    SLCore.Functions.TriggerCallback('sl-reputation:server:GetReputationData', function(data)
        reputationData = data
    end)
end

local function GetReputationLevel(points)
    local level = 0
    for l, data in pairs(Config.Levels) do
        if points >= data.minPoints then
            level = l
        end
    end
    return level
end

local function ShowReputationUI()
    local elements = {}
    
    for category, data in pairs(reputationData) do
        if Config.Categories[category] then
            local level = GetReputationLevel(data.points)
            local nextLevel = level + 1
            local pointsToNext = Config.Levels[nextLevel] and 
                (Config.Levels[nextLevel].minPoints - data.points) or 0
            
            table.insert(elements, {
                title = Config.Categories[category].label,
                description = string.format(
                    'Level: %s (%d points)\nNext Level: %d points needed',
                    Config.Levels[level].name,
                    data.points,
                    pointsToNext
                ),
                event = 'sl-reputation:client:ViewHistory',
                args = {category = category}
            })
        end
    end
    
    exports['sl-menu']:openMenu(elements)
end

-- Events
RegisterNetEvent('sl-reputation:client:UpdateReputation')
AddEventHandler('sl-reputation:client:UpdateReputation', function(category, points, reason)
    if not reputationData[category] then return end
    
    local oldLevel = GetReputationLevel(reputationData[category].points)
    reputationData[category].points = reputationData[category].points + points
    local newLevel = GetReputationLevel(reputationData[category].points)
    
    -- Show notification
    if Config.UI.showPointsGain then
        if points > 0 then
            SLCore.Functions.Notify(
                string.format(Lang:t('success.reputation_increased'), 
                points, Config.Categories[category].label),
                'success'
            )
        else
            SLCore.Functions.Notify(
                string.format(Lang:t('success.reputation_decreased'), 
                math.abs(points), Config.Categories[category].label),
                'error'
            )
        end
    end
    
    -- Show level up notification
    if newLevel > oldLevel and Config.UI.showLevelUp then
        SLCore.Functions.Notify(
            string.format(Lang:t('success.level_up'), 
            Config.Levels[newLevel].name, Config.Categories[category].label),
            'success'
        )
    end
end)

RegisterNetEvent('sl-reputation:client:ViewHistory')
AddEventHandler('sl-reputation:client:ViewHistory', function(data)
    local category = data.category
    if not reputationData[category] then return end
    
    SLCore.Functions.TriggerCallback('sl-reputation:server:GetReputationHistory', function(history)
        local elements = {}
        
        for _, entry in ipairs(history) do
            table.insert(elements, {
                title = string.format('%s: %d points', 
                    entry.reason, entry.points),
                description = 'Date: ' .. entry.date
            })
        end
        
        exports['sl-menu']:openMenu(elements)
    end, category)
end)

RegisterNetEvent('sl-reputation:client:OpenMenu')
AddEventHandler('sl-reputation:client:OpenMenu', function()
    ShowReputationUI()
end)

-- Commands
RegisterCommand('reputation', function()
    ShowReputationUI()
end)

-- Initialization
RegisterNetEvent('SLCore:Client:OnPlayerLoaded')
AddEventHandler('SLCore:Client:OnPlayerLoaded', function()
    PlayerData = SLCore.Functions.GetPlayerData()
    LoadReputationData()
end)

RegisterNetEvent('SLCore:Client:OnJobUpdate')
AddEventHandler('SLCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

-- Key Mapping
RegisterKeyMapping('reputation', 'Open Reputation Menu', 'keyboard', 'F7')
