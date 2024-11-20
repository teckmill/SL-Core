local SLCore = exports['sl-core']:GetCoreObject()
local ActiveReports = {}
local ReportCounter = 0

-- Utility functions
local function GenerateReportId()
    ReportCounter = ReportCounter + 1
    return ReportCounter
end

local function GetAdmins()
    local admins = {}
    local players = GetPlayers()
    
    for _, playerId in ipairs(players) do
        if SLCore.Functions.HasPermission(playerId, 'admin') then
            table.insert(admins, playerId)
        end
    end
    
    return admins
end

local function NotifyAdmins(message, type)
    local admins = GetAdmins()
    for _, adminId in ipairs(admins) do
        TriggerClientEvent('sl-core:client:Notify', adminId, message, type)
    end
end

-- Event handlers
RegisterNetEvent('sl-admin:server:CreateReport', function(data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local reportId = GenerateReportId()
    local report = {
        id = reportId,
        source = src,
        name = GetPlayerName(src),
        citizenid = Player.PlayerData.citizenid,
        type = data.type,
        description = data.description,
        timestamp = os.time(),
        status = 'pending',
        assignedTo = nil,
        comments = {},
        updates = {}
    }
    
    ActiveReports[reportId] = report
    
    -- Notify admins
    NotifyAdmins('New report (#' .. reportId .. ') from ' .. report.name, 'info')
    TriggerClientEvent('sl-admin:client:UpdateReports', -1, ActiveReports)
    TriggerClientEvent('sl-core:client:Notify', src, 'Report submitted successfully', 'success')
end)

RegisterNetEvent('sl-admin:server:AssignReport', function(reportId)
    local src = source
    if not SLCore.Functions.HasPermission(src, 'admin') then return end
    
    local report = ActiveReports[reportId]
    if not report then return end
    
    report.status = 'in_progress'
    report.assignedTo = src
    report.updates[#report.updates + 1] = {
        type = 'assigned',
        adminName = GetPlayerName(src),
        timestamp = os.time()
    }
    
    TriggerClientEvent('sl-admin:client:UpdateReports', -1, ActiveReports)
    TriggerClientEvent('sl-core:client:Notify', report.source, 'Your report (#' .. reportId .. ') is being handled', 'info')
end)

RegisterNetEvent('sl-admin:server:CloseReport', function(reportId, resolution)
    local src = source
    if not SLCore.Functions.HasPermission(src, 'admin') then return end
    
    local report = ActiveReports[reportId]
    if not report then return end
    
    report.status = 'closed'
    report.resolution = resolution
    report.updates[#report.updates + 1] = {
        type = 'closed',
        adminName = GetPlayerName(src),
        resolution = resolution,
        timestamp = os.time()
    }
    
    TriggerClientEvent('sl-admin:client:UpdateReports', -1, ActiveReports)
    TriggerClientEvent('sl-core:client:Notify', report.source, 'Your report (#' .. reportId .. ') has been resolved', 'success')
    
    -- Archive report after 24 hours
    SetTimeout(86400000, function()
        if ActiveReports[reportId] then
            ActiveReports[reportId] = nil
            TriggerClientEvent('sl-admin:client:UpdateReports', -1, ActiveReports)
        end
    end)
end)

RegisterNetEvent('sl-admin:server:AddComment', function(reportId, comment)
    local src = source
    if not SLCore.Functions.HasPermission(src, 'admin') then return end
    
    local report = ActiveReports[reportId]
    if not report then return end
    
    report.comments[#report.comments + 1] = {
        author = GetPlayerName(src),
        content = comment,
        timestamp = os.time()
    }
    
    TriggerClientEvent('sl-admin:client:UpdateReports', -1, ActiveReports)
end)

-- Event for players to request their report history
RegisterNetEvent('sl-admin:server:GetPlayerReports', function()
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local playerReports = {}
    for reportId, report in pairs(ActiveReports) do
        if report.citizenid == Player.PlayerData.citizenid then
            playerReports[reportId] = report
        end
    end
    
    TriggerClientEvent('sl-admin:client:UpdatePlayerReports', src, playerReports)
end)

-- Exports
exports('GetActiveReports', function()
    return ActiveReports
end)

exports('GetReportById', function(reportId)
    return ActiveReports[reportId]
end)
