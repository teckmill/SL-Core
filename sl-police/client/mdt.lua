local SLCore = exports['sl-core']:GetCoreObject()
local isOpen = false
local currentTab = 'home'
local citizenData = {}
local warrantData = {}
local reportData = {}

-- MDT Functions
function OpenMDT()
    if not isOpen then
        isOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "open"
        })
        LoadMDTData()
    end
end

function LoadMDTData()
    SLCore.Functions.TriggerCallback('sl-police:server:GetMDTData', function(data)
        SendNUIMessage({
            action = "updateData",
            data = data
        })
    end)
end

-- NUI Callbacks
RegisterNUICallback('close', function(data, cb)
    isOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('searchCitizen', function(data, cb)
    SLCore.Functions.TriggerCallback('sl-police:server:SearchCitizen', function(result)
        cb(result)
    end, data.search)
end)

RegisterNUICallback('newWarrant', function(data, cb)
    TriggerServerEvent('sl-police:server:NewWarrant', data)
    cb('ok')
end)

RegisterNUICallback('newReport', function(data, cb)
    TriggerServerEvent('sl-police:server:NewReport', data)
    cb('ok')
end)

-- Commands
RegisterCommand('mdt', function()
    if PlayerData.job.name == "police" then
        OpenMDT()
    end
end) 