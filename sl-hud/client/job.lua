local SLCore = exports['sl-core']:GetCoreObject()

-- Job Variables
local isEnabled = true
local currentJob = nil
local onDuty = false

-- Update Job Display
local function UpdateJobHUD()
    if not isEnabled then return end
    
    local Player = SLCore.Functions.GetPlayerData()
    if not Player then return end
    
    local jobInfo = Player.job
    if not jobInfo then return end
    
    -- Only update if job changed
    if currentJob ~= jobInfo.name or onDuty ~= jobInfo.onduty then
        currentJob = jobInfo.name
        onDuty = jobInfo.onduty
        
        SendNUIMessage({
            action = "updateJob",
            job = jobInfo.label,
            grade = jobInfo.grade.name,
            duty = onDuty,
            show = true
        })
    end
end

-- Job Update Events
RegisterNetEvent('sl-hud:client:UpdateJob')
AddEventHandler('sl-hud:client:UpdateJob', function()
    UpdateJobHUD()
end)

-- Toggle Job Display
RegisterCommand('togglejob', function()
    isEnabled = not isEnabled
    SendNUIMessage({
        action = "updateJob",
        show = isEnabled
    })
end)

-- Duty Toggle Command
RegisterCommand('duty', function()
    if not currentJob then return end
    TriggerServerEvent('sl-core:ToggleDuty')
end)

RegisterKeyMapping('duty', 'Toggle Duty', 'keyboard', 'f5')

-- Initialize Job Display
CreateThread(function()
    Wait(1000)
    UpdateJobHUD()
end)

-- Job Update Loop
CreateThread(function()
    while true do
        Wait(5000) -- Check every 5 seconds
        UpdateJobHUD()
    end
end)
