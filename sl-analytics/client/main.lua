local SLCore = exports['sl-core']:GetCoreObject()

-- Local Variables
local currentBusiness = nil
local dashboardActive = false
local activeReports = {}
local cachedAnalytics = {}

-- UI States
local function ToggleDashboard(state)
    dashboardActive = state
    SetNuiFocus(state, state)
    SendNUIMessage({
        action = "toggleDashboard",
        show = state,
        theme = Config.UI.theme,
        layout = Config.UI.dashboard.layout
    })
end

local function RefreshDashboard()
    if not currentBusiness or not dashboardActive then return end
    
    SLCore.Functions.TriggerCallback('sl-analytics:server:getAnalytics', function(analytics)
        if analytics then
            cachedAnalytics = analytics
            SendNUIMessage({
                action = "updateDashboard",
                data = analytics
            })
        end
    end, currentBusiness)
end

-- Report Generation
local function GenerateReport(reportType, parameters)
    if not currentBusiness then return end
    
    TriggerServerEvent('sl-analytics:server:generateReport', {
        businessId = currentBusiness,
        type = reportType,
        startDate = parameters.startDate,
        endDate = parameters.endDate
    })
end

local function ExportReport(reportType, format, parameters)
    if not currentBusiness then return end
    
    TriggerServerEvent('sl-analytics:server:exportReport', {
        businessId = currentBusiness,
        reportType = reportType,
        format = format,
        parameters = parameters
    })
end

-- Event Handlers
RegisterNetEvent('sl-analytics:client:displayReport', function(reportData)
    if not dashboardActive then return end
    
    SendNUIMessage({
        action = "displayReport",
        report = reportData
    })
end)

RegisterNetEvent('sl-analytics:client:setActiveBusiness', function(businessId)
    currentBusiness = businessId
    if dashboardActive then
        RefreshDashboard()
    end
end)

RegisterNetEvent('sl-analytics:client:showNotification', function(data)
    if not Config.UI.notifications.sound then return end
    
    SendNUIMessage({
        action = "showNotification",
        notification = {
            type = data.type,
            title = data.title,
            message = data.message,
            duration = Config.UI.notifications.duration
        }
    })
end)

-- NUI Callbacks
RegisterNUICallback('generateReport', function(data, cb)
    GenerateReport(data.type, data.parameters)
    cb('ok')
end)

RegisterNUICallback('exportReport', function(data, cb)
    ExportReport(data.type, data.format, data.parameters)
    cb('ok')
end)

RegisterNUICallback('refreshData', function(data, cb)
    RefreshDashboard()
    cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
    ToggleDashboard(false)
    cb('ok')
end)

-- Commands
RegisterCommand('businessanalytics', function()
    if not currentBusiness then
        SLCore.Functions.Notify('You need to be in a business to use analytics', 'error')
        return
    end
    
    ToggleDashboard(not dashboardActive)
end)

-- Initialization
CreateThread(function()
    while true do
        if dashboardActive and currentBusiness then
            RefreshDashboard()
            Wait(Config.RefreshInterval)
        else
            Wait(1000)
        end
    end
end)

-- Exports
exports('ToggleDashboard', ToggleDashboard)
exports('GenerateReport', GenerateReport)
exports('ExportReport', ExportReport)
exports('GetCurrentAnalytics', function() return cachedAnalytics end)
