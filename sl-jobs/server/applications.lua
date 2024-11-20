local SLCore = exports['sl-core']:GetCoreObject()
local Applications = {}

-- Load Applications
CreateThread(function()
    MySQL.ready(function()
        RefreshApplications()
    end)
end)

function RefreshApplications()
    local result = MySQL.Sync.fetchAll('SELECT * FROM job_applications WHERE status = ?', {'pending'})
    Applications = {}
    
    for _, app in ipairs(result) do
        Applications[app.id] = app
    end
end

-- Application Management
function SubmitApplication(source, job)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local jobConfig = Config.Jobs[job]
    if not jobConfig then return false end
    
    -- Check if player already has an application
    local existing = MySQL.Sync.fetchAll('SELECT * FROM job_applications WHERE citizenid = ? AND job = ? AND status = ?',
        {Player.PlayerData.citizenid, job, 'pending'})
    
    if #existing > 0 then
        TriggerClientEvent('SLCore:Notify', source, 'You already have a pending application!', 'error')
        return false
    end
    
    -- Create application
    local id = MySQL.insert.await('INSERT INTO job_applications (citizenid, job) VALUES (?, ?)',
        {Player.PlayerData.citizenid, job})
    
    if id then
        Applications[id] = {
            id = id,
            citizenid = Player.PlayerData.citizenid,
            job = job,
            status = 'pending',
            created_at = os.time()
        }
        
        -- Notify managers
        NotifyManagers(job, 'New job application received')
        return true
    end
    
    return false
end

function ReviewApplication(source, applicationId, status, notes)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local application = Applications[applicationId]
    if not application then return false end
    
    -- Check reviewer permissions
    if not CanReviewApplications(Player, application.job) then
        return false
    end
    
    -- Update application
    MySQL.Async.execute('UPDATE job_applications SET status = ?, reviewer = ?, notes = ? WHERE id = ?',
        {status, Player.PlayerData.citizenid, notes, applicationId})
    
    -- Notify applicant
    local applicant = SLCore.Functions.GetPlayerByCitizenId(application.citizenid)
    if applicant then
        TriggerClientEvent('SLCore:Notify', applicant.PlayerData.source, 
            'Your job application has been ' .. status, 
            status == 'accepted' and 'success' or 'error')
    end
    
    -- Handle acceptance
    if status == 'accepted' then
        local targetPlayer = SLCore.Functions.GetPlayerByCitizenId(application.citizenid)
        if targetPlayer then
            exports['sl-jobs']:SetPlayerJob(targetPlayer.PlayerData.source, application.job, 0)
        end
    end
    
    Applications[applicationId] = nil
    return true
end

-- Utility Functions
function CanReviewApplications(Player, job)
    if not Player.PlayerData.job.name == job then return false end
    
    local jobConfig = Config.Jobs[job]
    if not jobConfig then return false end
    
    local gradeConfig = jobConfig.grades[tostring(Player.PlayerData.job.grade)]
    return gradeConfig and (gradeConfig.isBoss or gradeConfig.canManage)
end

function NotifyManagers(job, message)
    local Players = SLCore.Functions.GetPlayers()
    
    for _, player in ipairs(Players) do
        local Player = SLCore.Functions.GetPlayer(player)
        if Player and Player.PlayerData.job.name == job then
            if CanReviewApplications(Player, job) then
                TriggerClientEvent('SLCore:Notify', Player.PlayerData.source, message, 'info')
            end
        end
    end
end

-- Callbacks
SLCore.Functions.CreateCallback('sl-jobs:server:GetApplications', function(source, cb, job)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end
    
    if CanReviewApplications(Player, job) then
        local applications = {}
        for _, app in pairs(Applications) do
            if app.job == job then
                applications[#applications + 1] = app
            end
        end
        cb(applications)
    else
        cb({})
    end
end)

-- Exports
exports('SubmitApplication', SubmitApplication)
exports('ReviewApplication', ReviewApplication) 