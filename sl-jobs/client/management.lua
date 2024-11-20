local SLCore = exports['sl-core']:GetCoreObject()
local ManagementUI = {}
local isManagementOpen = false

-- Management UI Functions
function OpenManagementUI()
    if not CanAccessManagement() then return end
    SetNuiFocus(true, true)
    isManagementOpen = true
    
    -- Get initial data
    SLCore.Functions.TriggerCallback('sl-jobs:server:GetManagementData', function(data)
        SendNUIMessage({
            action = "openManagement",
            data = data
        })
    end)
end

function CloseManagementUI()
    SetNuiFocus(false, false)
    isManagementOpen = false
    SendNUIMessage({
        action = "closeManagement"
    })
end

-- NUI Callbacks
RegisterNUICallback('closeManagement', function(data, cb)
    CloseManagementUI()
    cb('ok')
end)

RegisterNUICallback('getEmployees', function(data, cb)
    SLCore.Functions.TriggerCallback('sl-jobs:server:GetEmployees', function(employees)
        cb(employees)
    end)
end)

RegisterNUICallback('getApplications', function(data, cb)
    SLCore.Functions.TriggerCallback('sl-jobs:server:GetApplications', function(applications)
        cb(applications)
    end)
end)

RegisterNUICallback('reviewApplication', function(data, cb)
    TriggerServerEvent('sl-jobs:server:ReviewApplication', data.id, data.status, data.notes)
    cb('ok')
end)

RegisterNUICallback('manageEmployee', function(data, cb)
    TriggerServerEvent('sl-jobs:server:ManageEmployee', data.citizenid, data.action, data.value)
    cb('ok')
end)

RegisterNUICallback('getSocietyFunds', function(data, cb)
    SLCore.Functions.TriggerCallback('sl-jobs:server:GetSocietyFunds', function(funds)
        cb(funds)
    end)
end)

RegisterNUICallback('manageFunds', function(data, cb)
    TriggerServerEvent('sl-jobs:server:ManageFunds', data.action, data.amount)
    cb('ok')
end)

-- Events
RegisterNetEvent('sl-jobs:client:UpdateManagementUI', function(data)
    if isManagementOpen then
        SendNUIMessage({
            action = "updateData",
            data = data
        })
    end
end)

-- Utility Functions
function CanAccessManagement()
    local PlayerData = SLCore.Functions.GetPlayerData()
    if not PlayerData.job then return false end
    
    local jobConfig = Config.Jobs[PlayerData.job.name]
    if not jobConfig then return false end
    
    local gradeConfig = jobConfig.grades[tostring(PlayerData.job.grade)]
    return gradeConfig and (gradeConfig.isBoss or gradeConfig.canManage)
end

-- Command
RegisterCommand('jobmanagement', function()
    OpenManagementUI()
end)

-- Export
exports('OpenManagementUI', OpenManagementUI) 