local SLCore = exports['sl-core']:GetCoreObject()
local JobData = {}

-- Initialize
CreateThread(function()
    MySQL.ready(function()
        -- Create tables if they don't exist
        local sqlFile = LoadResourceFile(GetCurrentResourceName(), 'sql/jobs.sql')
        -- Split and execute SQL statements individually
        for statement in sqlFile:gmatch("([^;]+);") do
            statement = statement:gsub("^%s+", ""):gsub("%s+$", "") -- Trim whitespace
            if statement ~= "" then
                MySQL.Sync.execute(statement)
            end
        end
        LoadAllJobData()
    end)
end)

-- Load Job Data
function LoadAllJobData()
    local result = MySQL.Sync.fetchAll('SELECT * FROM job_data')
    for _, data in ipairs(result) do
        JobData[data.citizenid] = {
            job = data.job,
            grade = data.grade,
            duty = data.duty == 1,
            experience = data.experience,
            skills = json.decode(data.skills or '{}'),
            lastDuty = data.last_duty,
            totalHours = data.total_hours
        }
    end
end

-- Job Management
function SetPlayerJob(source, job, grade)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local citizenid = Player.PlayerData.citizenid
    local jobConfig = Config.Jobs[job]
    
    if not jobConfig then return false end
    if not jobConfig.grades[tostring(grade)] then grade = 0 end
    
    -- Update database
    MySQL.Async.execute('INSERT INTO job_data (citizenid, job, grade) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE job = VALUES(job), grade = VALUES(grade)',
        {citizenid, job, grade})
    
    -- Update cache
    JobData[citizenid] = JobData[citizenid] or {}
    JobData[citizenid].job = job
    JobData[citizenid].grade = grade
    JobData[citizenid].duty = jobConfig.defaultDuty or false
    
    -- Update player data
    Player.Functions.SetJob(job, grade)
    
    -- Log change
    LogJobAction(citizenid, job, 'job_change', json.encode({
        old_job = Player.PlayerData.job.name,
        new_job = job,
        new_grade = grade
    }))
    
    return true
end

-- Duty Management
RegisterNetEvent('sl-jobs:server:ToggleDuty', function()
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local citizenid = Player.PlayerData.citizenid
    local jobData = JobData[citizenid]
    if not jobData then return end
    
    local newDutyStatus = not jobData.duty
    
    -- Update database
    MySQL.Async.execute('UPDATE job_data SET duty = ?, last_duty = CURRENT_TIMESTAMP WHERE citizenid = ?',
        {newDutyStatus and 1 or 0, citizenid})
    
    -- Update cache
    jobData.duty = newDutyStatus
    jobData.lastDuty = os.time()
    
    -- Update player
    Player.Functions.SetJobDuty(newDutyStatus)
    TriggerClientEvent('SLCore:Client:SetDuty', src, newDutyStatus)
    
    -- Log action
    LogJobAction(citizenid, jobData.job, 'duty_toggle', json.encode({
        status = newDutyStatus
    }))
end)

-- Skill Management
function UpdateSkill(citizenid, skill, xp)
    if not Config.Skills[skill] then return false end
    
    local currentSkill = MySQL.Sync.fetchAll('SELECT * FROM job_skills WHERE citizenid = ? AND skill = ?',
        {citizenid, skill})[1]
    
    if currentSkill then
        local newXP = currentSkill.xp + xp
        local newLevel = math.floor(newXP / Config.Skills[skill].xpPerLevel)
        
        if newLevel > Config.Skills[skill].maxLevel then
            newLevel = Config.Skills[skill].maxLevel
            newXP = newLevel * Config.Skills[skill].xpPerLevel
        end
        
        MySQL.Async.execute('UPDATE job_skills SET level = ?, xp = ? WHERE citizenid = ? AND skill = ?',
            {newLevel, newXP, citizenid, skill})
            
        return true
    else
        MySQL.Async.execute('INSERT INTO job_skills (citizenid, skill, level, xp) VALUES (?, ?, ?, ?)',
            {citizenid, skill, 0, xp})
            
        return true
    end
end

-- Logging
function LogJobAction(citizenid, job, action, details)
    MySQL.Async.execute('INSERT INTO job_logs (citizenid, job, action, details) VALUES (?, ?, ?, ?)',
        {citizenid, job, action, details})
end

-- Callbacks
SLCore.Functions.CreateCallback('sl-jobs:server:GetJobData', function(source, cb)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end
    
    local citizenid = Player.PlayerData.citizenid
    cb(JobData[citizenid] or {})
end)

-- Exports
exports('SetPlayerJob', SetPlayerJob)
exports('UpdateSkill', UpdateSkill)
exports('GetJobData', function(citizenid)
    return JobData[citizenid]
end)
