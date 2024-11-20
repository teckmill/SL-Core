local SLCore = exports['sl-core']:GetCoreObject()
local PlayerSkills = {}
local SkillUpdateTimer = nil

-- Initialize
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    SLCore.Functions.TriggerCallback('sl-jobs:server:GetSkills', function(skills)
        PlayerSkills = skills
        StartSkillUpdates()
    end)
end)

-- Skill Update Loop
function StartSkillUpdates()
    if SkillUpdateTimer then return end
    
    SkillUpdateTimer = SetInterval(function()
        if PlayerData.job and PlayerData.job.onduty then
            CheckSkillGains()
        end
    end, Config.SkillGainInterval * 60000)
end

function CheckSkillGains()
    local ped = PlayerPedId()
    local jobSkills = Config.Jobs[PlayerData.job.name].skills
    
    if not jobSkills then return end
    
    for skill, data in pairs(jobSkills) do
        if data.checkFunction then
            local xpGain = data.checkFunction(ped)
            if xpGain > 0 then
                TriggerServerEvent('sl-jobs:server:AddSkillXP', skill, xpGain)
            end
        end
    end
end

-- Skill Menu
function OpenSkillMenu()
    local menu = {
        {
            header = "Job Skills",
            isMenuHeader = true
        }
    }
    
    for skill, data in pairs(PlayerSkills) do
        if Config.Skills[skill] then
            local skillConfig = Config.Skills[skill]
            local progress = math.floor((data.xp / (skillConfig.xpPerLevel * skillConfig.maxLevel)) * 100)
            
            menu[#menu + 1] = {
                header = skillConfig.label,
                txt = string.format("Level: %d | Progress: %d%%", data.level, progress),
                params = {
                    event = "sl-jobs:client:ViewSkillDetails",
                    args = {
                        skill = skill,
                        data = data
                    }
                }
            }
        end
    end
    
    exports['sl-menu']:openMenu(menu)
end

-- Events
RegisterNetEvent('sl-jobs:client:UpdateSkill', function(skill, data)
    PlayerSkills[skill] = data
    -- Add any visual feedback here
end)

RegisterNetEvent('sl-jobs:client:ViewSkillDetails', function(data)
    local skillConfig = Config.Skills[data.skill]
    local skillData = data.data
    
    local menu = {
        {
            header = "< Go Back",
            params = {
                event = "sl-jobs:client:OpenSkillMenu"
            }
        },
        {
            header = skillConfig.label,
            isMenuHeader = true
        },
        {
            header = "Description",
            txt = skillConfig.description,
            isMenuHeader = true
        },
        {
            header = "Current Level",
            txt = string.format("Level %d | XP: %d/%d", 
                skillData.level, 
                skillData.xp, 
                skillConfig.xpPerLevel * (skillData.level + 1)),
            isMenuHeader = true
        }
    }
    
    exports['sl-menu']:openMenu(menu)
end)

-- Exports
exports('GetPlayerSkills', function()
    return PlayerSkills
end) 