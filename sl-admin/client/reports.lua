local SLCore = exports['sl-core']:GetCoreObject()

-- Variables
local activeReports = {}
local myReports = {}

-- Functions
local function formatReport(report)
    return string.format('[%s] %s: %s', report.id, report.name, report.reason)
end

local function updateReportsList()
    SendNUIMessage({
        action = 'updateReports',
        reports = activeReports
    })
end

-- Event Handlers
RegisterNetEvent('sl-admin:client:UpdateReports', function(reports)
    activeReports = reports
    updateReportsList()
end)

RegisterNetEvent('sl-admin:client:ReportTaken', function(reportId, adminName)
    if myReports[reportId] then
        SLCore.Functions.Notify('Your report is being handled by ' .. adminName, 'success')
        myReports[reportId] = nil
    end
end)

RegisterNetEvent('sl-admin:client:ReportClosed', function(reportId, adminName)
    if myReports[reportId] then
        SLCore.Functions.Notify('Your report has been resolved by ' .. adminName, 'success')
        myReports[reportId] = nil
    end
end)

-- Commands
RegisterCommand('report', function(source, args)
    if #args < 1 then
        SLCore.Functions.Notify('Please specify a reason for your report', 'error')
        return
    end
    
    local reason = table.concat(args, ' ')
    if #reason < 10 then
        SLCore.Functions.Notify('Report reason is too short', 'error')
        return
    end
    
    if #reason > 255 then
        SLCore.Functions.Notify('Report reason is too long', 'error')
        return
    end
    
    TriggerServerEvent('sl-admin:server:CreateReport', reason)
end)

RegisterCommand('reports', function()
    if not SLCore.Functions.HasPermission('admin') then return end
    
    if #activeReports == 0 then
        SLCore.Functions.Notify('No active reports', 'primary')
        return
    end
    
    for _, report in pairs(activeReports) do
        SLCore.Functions.Notify(formatReport(report), 'primary')
    end
end)

-- NUI Callbacks
RegisterNUICallback('takeReport', function(data, cb)
    if not data.reportId then return end
    TriggerServerEvent('sl-admin:server:TakeReport', data.reportId)
    cb('ok')
end)

RegisterNUICallback('closeReport', function(data, cb)
    if not data.reportId then return end
    TriggerServerEvent('sl-admin:server:CloseReport', data.reportId)
    cb('ok')
end)

-- Initialization
CreateThread(function()
    Wait(1000) -- Wait for core to be ready
    TriggerServerEvent('sl-admin:server:RequestReports')
end)
