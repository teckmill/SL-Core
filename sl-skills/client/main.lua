local SLCore = exports['sl-core']:GetCoreObject()
local PlayerData = {}
local skillsData = {}
local cooldowns = {}

-- Initialize
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('sl-skills:server:LoadSkills')
end)

RegisterNetEvent('sl-skills:client:UpdateSkills', function(skills)
    skillsData = skills
    if Config.UI.showXPBar then
        UpdateSkillsUI()
    end
end)

-- XP gain functions
local function CheckCooldown(activity)
    if not cooldowns[activity] then return true end
    return (GetGameTimer() - cooldowns[activity]) >= (Config.XPCooldown * 1000)
end

local function SetCooldown(activity)
    cooldowns[activity] = GetGameTimer()
end

-- Activity detection threads
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            
            -- Running detection
            if IsPedRunning(ped) and not IsPedInAnyVehicle(ped, true) then
                if CheckCooldown('running') then
                    TriggerServerEvent('sl-skills:server:AddXP', 'stamina', 'running')
                    SetCooldown('running')
                end
            end
            
            -- Swimming detection
            if IsPedSwimming(ped) then
                if CheckCooldown('swimming') then
                    TriggerServerEvent('sl-skills:server:AddXP', 'stamina', 'swimming')
                    TriggerServerEvent('sl-skills:server:AddXP', 'strength', 'swimming')
                    SetCooldown('swimming')
                end
            end
            
            -- Fighting detection
            if IsPedInMeleeCombat(ped) then
                if CheckCooldown('fighting') then
                    TriggerServerEvent('sl-skills:server:AddXP', 'strength', 'fighting')
                    SetCooldown('fighting')
                end
            end
            
            -- Shooting detection
            if IsPedShooting(ped) then
                if CheckCooldown('combat') then
                    TriggerServerEvent('sl-skills:server:AddXP', 'shooting', 'combat')
                    SetCooldown('combat')
                end
            end
        end
        Wait(1000)
    end
end)

-- Driving skill thread
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            
            if IsPedInAnyVehicle(ped, false) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                local speed = GetEntitySpeed(vehicle) * 3.6 -- Convert to km/h
                
                if GetPedInVehicleSeat(vehicle, -1) == ped then -- If driver
                    if speed > 50 then -- Only gain XP above 50 km/h
                        if CheckCooldown('driving') then
                            TriggerServerEvent('sl-skills:server:AddXP', 'driving', 'racing')
                            SetCooldown('driving')
                        end
                    end
                    
                    -- Drifting detection
                    local isVehicleDrifting = IsVehicleDrifting(vehicle)
                    if isVehicleDrifting and speed > 30 then
                        if CheckCooldown('drifting') then
                            TriggerServerEvent('sl-skills:server:AddXP', 'driving', 'drifting')
                            SetCooldown('drifting')
                        end
                    end
                end
            end
        end
        Wait(1000)
    end
end)

-- UI Functions
function UpdateSkillsUI()
    SendNUIMessage({
        action = 'updateSkills',
        skills = skillsData
    })
end

-- Skill menu
RegisterCommand('skills', function()
    if not LocalPlayer.state.isLoggedIn then return end
    OpenSkillsMenu()
end)

function OpenSkillsMenu()
    local menu = {
        {
            header = Lang:t('menu.skills_title'),
            isMenuHeader = true
        }
    }
    
    for skill, data in pairs(skillsData) do
        local skillConfig = Config.Skills[skill]
        if skillConfig then
            menu[#menu + 1] = {
                header = skillConfig.name,
                txt = string.format('%s - Level %d (%d/%d XP)', 
                    skillConfig.description, 
                    data.level, 
                    data.xp, 
                    skillConfig.xpPerLevel
                ),
                params = {
                    event = 'sl-skills:client:ShowSkillDetails',
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

-- Skill details menu
RegisterNetEvent('sl-skills:client:ShowSkillDetails', function(data)
    local skill = data.skill
    local skillData = data.data
    local skillConfig = Config.Skills[skill]
    
    local menu = {
        {
            header = '← Go Back',
            params = {
                event = 'sl-menu:client:closeMenu'
            }
        },
        {
            header = skillConfig.name,
            txt = skillConfig.description,
            isMenuHeader = true
        },
        {
            header = Lang:t('menu.current_level'),
            txt = string.format('Level %d (%d/%d XP)', 
                skillData.level, 
                skillData.xp, 
                skillConfig.xpPerLevel
            ),
            isMenuHeader = true
        }
    }
    
    -- Add active bonuses
    local bonuses = Config.Bonuses[skill]
    if bonuses then
        for level, bonus in pairs(bonuses) do
            if skillData.level >= level then
                menu[#menu + 1] = {
                    header = 'Active Bonus',
                    txt = bonus.description,
                    isMenuHeader = true
                }
            end
        end
    end
    
    exports['sl-menu']:openMenu(menu)
end)

-- Apply skill effects
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn and skillsData.stamina then
            -- Stamina effects
            local staminaLevel = skillsData.stamina.level
            local staminaMultiplier = 1.0
            
            for level, bonus in pairs(Config.Bonuses.stamina) do
                if staminaLevel >= level then
                    if bonus.type == 'sprint_duration' or bonus.type == 'both' then
                        staminaMultiplier = bonus.value
                    end
                end
            end
            
            StatSetInt('MP0_STAMINA', math.min(100, 50 + (staminaLevel / 2)), true)
            SetPlayerStamina(PlayerId(), GetPlayerStamina(PlayerId()) * staminaMultiplier)
        end
        Wait(1000)
    end
end)

-- Export functions
exports('GetSkillLevel', function(skill)
    if skillsData[skill] then
        return skillsData[skill].level
    end
    return 0
end)

exports('GetSkillBonus', function(skill, bonusType)
    if not skillsData[skill] then return 1.0 end
    
    local level = skillsData[skill].level
    local bonuses = Config.Bonuses[skill]
    local highestBonus = 1.0
    
    if bonuses then
        for reqLevel, bonus in pairs(bonuses) do
            if level >= reqLevel and (bonus.type == bonusType or bonus.type == 'both') then
                highestBonus = bonus.value
            end
        end
    end
    
    return highestBonus
end)
