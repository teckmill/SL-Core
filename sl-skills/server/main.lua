local SLCore = exports['sl-core']:GetCoreObject()

-- Database initialization
MySQL.ready(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS player_skills (
            citizenid VARCHAR(50) PRIMARY KEY,
            skills TEXT NOT NULL
        )
    ]])
end)

-- Load player skills
RegisterNetEvent('sl-skills:server:LoadSkills', function()
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end

    MySQL.query('SELECT skills FROM player_skills WHERE citizenid = ?', {
        Player.PlayerData.citizenid
    }, function(result)
        local skills = {}
        if result and result[1] then
            skills = json.decode(result[1].skills)
        else
            -- Initialize default skills
            for skill, _ in pairs(Config.Skills) do
                skills[skill] = {
                    level = 1,
                    xp = 0
                }
            end
            
            MySQL.insert('INSERT INTO player_skills (citizenid, skills) VALUES (?, ?)', {
                Player.PlayerData.citizenid,
                json.encode(skills)
            })
        end
        
        TriggerClientEvent('sl-skills:client:UpdateSkills', src, skills)
    end)
end)

-- Save player skills
local function SavePlayerSkills(citizenid, skills)
    MySQL.update('UPDATE player_skills SET skills = ? WHERE citizenid = ?', {
        json.encode(skills),
        citizenid
    })
end

-- Add XP to skill
RegisterNetEvent('sl-skills:server:AddXP', function(skill, activity)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Validate skill and activity
    if not Config.Skills[skill] then
        TriggerClientEvent('SLCore:Notify', src, 'Invalid skill type', 'error')
        return
    end
    
    if not Config.Skills[skill].activities[activity] then
        TriggerClientEvent('SLCore:Notify', src, 'Invalid activity type', 'error')
        return
    end
    
    -- Get skill data
    MySQL.query('SELECT skills FROM player_skills WHERE citizenid = ?', {
        Player.PlayerData.citizenid
    }, function(result)
        if not result or not result[1] then return end
        
        local skills = json.decode(result[1].skills)
        local skillData = skills[skill]
        
        -- Calculate XP gain
        local xpGain = Config.Skills[skill].activities[activity]
        
        -- Apply VIP multiplier if applicable
        if Player.PlayerData.vip then
            xpGain = xpGain * Config.VIPMultiplier
        end
        
        -- Check max XP per activity
        if xpGain > Config.MaxXPPerActivity then
            xpGain = Config.MaxXPPerActivity
        end
        
        -- Add XP and check for level up
        skillData.xp = skillData.xp + xpGain
        local xpForNextLevel = Config.Skills[skill].xpPerLevel * skillData.level
        
        while skillData.xp >= xpForNextLevel and skillData.level < Config.Skills[skill].maxLevel do
            skillData.xp = skillData.xp - xpForNextLevel
            skillData.level = skillData.level + 1
            
            -- Level up notification
            TriggerClientEvent('SLCore:Notify', src, 'You have leveled up your '..Config.Skills[skill].name..' skill to level '..skillData.level, 'success')
            
            -- Check for new bonuses
            local bonuses = Config.Bonuses[skill]
            if bonuses and bonuses[skillData.level] then
                TriggerClientEvent('SLCore:Notify', src, 'You have unlocked a new bonus: '..bonuses[skillData.level].description, 'success')
            end
            
            xpForNextLevel = Config.Skills[skill].xpPerLevel * skillData.level
        end
        
        -- Save and update client
        SavePlayerSkills(Player.PlayerData.citizenid, skills)
        TriggerClientEvent('sl-skills:client:UpdateSkills', src, skills)
    end)
end)

-- Admin commands
SLCore.Commands.Add('resetskill', 'Reset skill progress (Admin Only)', {{name = 'skill', help = 'Skill to reset'}}, true, function(source, args)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local skill = args[1]
    if not Config.Skills[skill] then
        TriggerClientEvent('SLCore:Notify', src, 'Invalid skill type', 'error')
        return
    end
    
    MySQL.query('SELECT skills FROM player_skills WHERE citizenid = ?', {
        Player.PlayerData.citizenid
    }, function(result)
        if not result or not result[1] then return end
        
        local skills = json.decode(result[1].skills)
        skills[skill] = {
            level = 1,
            xp = 0
        }
        
        SavePlayerSkills(Player.PlayerData.citizenid, skills)
        TriggerClientEvent('sl-skills:client:UpdateSkills', src, skills)
        TriggerClientEvent('SLCore:Notify', src, 'Skill reset successfully', 'success')
    end)
end, 'admin')

SLCore.Commands.Add('addskillxp', 'Add XP to a skill (Admin Only)', {
    {name = 'skill', help = 'Skill to add XP to'},
    {name = 'amount', help = 'Amount of XP to add'}
}, true, function(source, args)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local skill = args[1]
    local amount = tonumber(args[2])
    
    if not Config.Skills[skill] then
        TriggerClientEvent('SLCore:Notify', src, 'Invalid skill type', 'error')
        return
    end
    
    if not amount or amount < 1 then
        TriggerClientEvent('SLCore:Notify', src, 'Invalid XP amount', 'error')
        return
    end
    
    TriggerEvent('sl-skills:server:AddXP', skill, 'admin', amount)
end, 'admin')

-- Periodic save
if Config.PeriodicSave then
    CreateThread(function()
        while true do
            Wait(Config.SaveInterval * 60 * 1000)
            
            local players = SLCore.Functions.GetPlayers()
            for _, player in ipairs(players) do
                local Player = SLCore.Functions.GetPlayer(player)
                if Player then
                    MySQL.query('SELECT skills FROM player_skills WHERE citizenid = ?', {
                        Player.PlayerData.citizenid
                    }, function(result)
                        if result and result[1] then
                            local skills = json.decode(result[1].skills)
                            SavePlayerSkills(Player.PlayerData.citizenid, skills)
                        end
                    end)
                end
            end
        end
    end)
end

-- Exports
exports('GetPlayerSkillLevel', function(source, skill)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return 0 end
    
    local result = MySQL.query.await('SELECT skills FROM player_skills WHERE citizenid = ?', {
        Player.PlayerData.citizenid
    })
    
    if result and result[1] then
        local skills = json.decode(result[1].skills)
        if skills[skill] then
            return skills[skill].level
        end
    end
    
    return 0
end)
