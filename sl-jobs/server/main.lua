local SLCore = exports['sl-core']:GetCoreObject()
local Jobs = {}
local JobsData = {}
local EmployeeData = {}

-- Database initialization
CreateThread(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS sl_jobs (
            id INT AUTO_INCREMENT PRIMARY KEY,
            name VARCHAR(50) NOT NULL,
            label VARCHAR(50) NOT NULL,
            category VARCHAR(50) NOT NULL,
            owner VARCHAR(50),
            bank INT DEFAULT 0,
            settings JSON,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS sl_job_employees (
            id INT AUTO_INCREMENT PRIMARY KEY,
            job_id INT NOT NULL,
            citizen_id VARCHAR(50) NOT NULL,
            grade INT DEFAULT 0,
            skills JSON,
            hired_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (job_id) REFERENCES sl_jobs(id)
        )
    ]])

    LoadJobs()
end)

-- Load all jobs from database
function LoadJobs()
    local result = MySQL.query.await('SELECT * FROM sl_jobs')
    if result then
        for _, job in ipairs(result) do
            Jobs[job.name] = {
                label = job.label,
                category = job.category,
                owner = job.owner,
                bank = job.bank,
                settings = json.decode(job.settings)
            }
            LoadJobEmployees(job.id, job.name)
        end
    end
end

-- Load employees for a specific job
function LoadJobEmployees(jobId, jobName)
    local result = MySQL.query.await('SELECT * FROM sl_job_employees WHERE job_id = ?', {jobId})
    if result then
        EmployeeData[jobName] = {}
        for _, employee in ipairs(result) do
            EmployeeData[jobName][employee.citizen_id] = {
                grade = employee.grade,
                skills = json.decode(employee.skills),
                hired_at = employee.hired_at
            }
        end
    end
end

-- Job Management Functions
function CreateJob(name, data)
    if Jobs[name] then return false, "Job already exists" end
    
    local success = MySQL.insert.await('INSERT INTO sl_jobs (name, label, category, owner, settings) VALUES (?, ?, ?, ?, ?)',
        {name, data.label, data.category, data.owner, json.encode(data.settings)})
    
    if success then
        Jobs[name] = data
        return true, "Job created successfully"
    end
    return false, "Failed to create job"
end

function UpdateJob(name, data)
    if not Jobs[name] then return false, "Job doesn't exist" end
    
    local success = MySQL.update.await('UPDATE sl_jobs SET label = ?, category = ?, settings = ? WHERE name = ?',
        {data.label, data.category, json.encode(data.settings), name})
    
    if success then
        Jobs[name] = data
        return true, "Job updated successfully"
    end
    return false, "Failed to update job"
end

-- Employee Management Functions
function HireEmployee(jobName, citizenId, grade)
    if not Jobs[jobName] then return false, "Job doesn't exist" end
    if EmployeeData[jobName] and EmployeeData[jobName][citizenId] then
        return false, "Employee already hired"
    end

    local jobId = MySQL.scalar.await('SELECT id FROM sl_jobs WHERE name = ?', {jobName})
    local success = MySQL.insert.await('INSERT INTO sl_job_employees (job_id, citizen_id, grade) VALUES (?, ?, ?)',
        {jobId, citizenId, grade})
    
    if success then
        if not EmployeeData[jobName] then EmployeeData[jobName] = {} end
        EmployeeData[jobName][citizenId] = {
            grade = grade,
            skills = {},
            hired_at = os.time()
        }
        return true, "Employee hired successfully"
    end
    return false, "Failed to hire employee"
end

function FireEmployee(jobName, citizenId)
    if not Jobs[jobName] or not EmployeeData[jobName] or not EmployeeData[jobName][citizenId] then
        return false, "Employee not found"
    end

    local jobId = MySQL.scalar.await('SELECT id FROM sl_jobs WHERE name = ?', {jobName})
    local success = MySQL.execute.await('DELETE FROM sl_job_employees WHERE job_id = ? AND citizen_id = ?',
        {jobId, citizenId})
    
    if success then
        EmployeeData[jobName][citizenId] = nil
        return true, "Employee fired successfully"
    end
    return false, "Failed to fire employee"
end

-- Skill System Functions
function UpdateEmployeeSkills(jobName, citizenId, skills)
    if not EmployeeData[jobName] or not EmployeeData[jobName][citizenId] then
        return false, "Employee not found"
    end

    local jobId = MySQL.scalar.await('SELECT id FROM sl_jobs WHERE name = ?', {jobName})
    local success = MySQL.update.await('UPDATE sl_job_employees SET skills = ? WHERE job_id = ? AND citizen_id = ?',
        {json.encode(skills), jobId, citizenId})
    
    if success then
        EmployeeData[jobName][citizenId].skills = skills
        return true, "Skills updated successfully"
    end
    return false, "Failed to update skills"
end

-- Paycheck System
CreateThread(function()
    while true do
        ProcessPaychecks()
        Wait(Config.PaycheckInterval * 60 * 1000)
    end
end)

function ProcessPaychecks()
    for jobName, employees in pairs(EmployeeData) do
        for citizenId, data in pairs(employees) do
            local player = SLCore.Functions.GetPlayerByCitizenId(citizenId)
            if player then
                local grade = Config.Jobs[jobName].grades[data.grade]
                if grade then
                    local payment = grade.payment
                    -- Apply skill bonuses
                    if data.skills then
                        for skill, level in pairs(data.skills) do
                            payment = payment * (1 + (level / Config.MaxSkillLevel * 0.5))
                        end
                    end
                    player.Functions.AddMoney('bank', payment, 'job-payment')
                    TriggerClientEvent('sl-jobs:client:PaycheckReceived', player.PlayerData.source, payment)
                end
            end
        end
    end
end

-- Events and Callbacks
RegisterNetEvent('sl-jobs:server:RequestJobData', function()
    local src = source
    local player = SLCore.Functions.GetPlayer(src)
    if player then
        local citizenId = player.PlayerData.citizenid
        local playerJobs = {}
        for jobName, employees in pairs(EmployeeData) do
            if employees[citizenId] then
                playerJobs[jobName] = {
                    grade = employees[citizenId].grade,
                    skills = employees[citizenId].skills
                }
            end
        end
        TriggerClientEvent('sl-jobs:client:ReceiveJobData', src, playerJobs)
    end
end)

RegisterNetEvent('sl-jobs:server:RequestJobMarket', function()
    local src = source
    TriggerClientEvent('sl-jobs:client:ReceiveJobMarket', src, Jobs)
end)

-- Exports
exports('GetJobData', function(jobName)
    return Jobs[jobName]
end)

exports('GetEmployeeData', function(jobName, citizenId)
    if EmployeeData[jobName] then
        return EmployeeData[jobName][citizenId]
    end
    return nil
end)

exports('CreateJob', CreateJob)
exports('UpdateJob', UpdateJob)
exports('HireEmployee', HireEmployee)
exports('FireEmployee', FireEmployee)
exports('UpdateEmployeeSkills', UpdateEmployeeSkills)
