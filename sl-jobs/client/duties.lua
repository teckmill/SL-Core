local SLCore = exports['sl-core']:GetCoreObject()
local PlayerData = {}
local onDuty = false
local dutyZones = {}

-- Initialize
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    PlayerData = SLCore.Functions.GetPlayerData()
    onDuty = PlayerData.job.onduty
    InitializeDutyZones()
end)

RegisterNetEvent('SLCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('SLCore:Client:SetDuty', function(duty)
    onDuty = duty
end)

-- Create Duty Zones
function InitializeDutyZones()
    for jobName, jobData in pairs(Config.Jobs) do
        for locationName, locationData in pairs(jobData.locations) do
            if locationData.duty then
                local dutyData = locationData.duty
                
                -- Create zone
                local zone = BoxZone:Create(
                    vector3(dutyData.coords.x, dutyData.coords.y, dutyData.coords.z),
                    2.0, 2.0, {
                        name = jobName .. "_duty_" .. locationName,
                        heading = dutyData.coords.w,
                        debugPoly = false,
                        minZ = dutyData.coords.z - 1.0,
                        maxZ = dutyData.coords.z + 1.0
                    }
                )
                
                dutyZones[#dutyZones + 1] = {
                    zone = zone,
                    job = jobName,
                    location = locationName,
                    data = dutyData
                }
                
                -- Add target
                if Config.Duty.useTarget then
                    exports['sl-target']:AddBoxZone(
                        jobName .. "_duty_" .. locationName,
                        vector3(dutyData.coords.x, dutyData.coords.y, dutyData.coords.z),
                        2.0, 2.0,
                        {
                            name = jobName .. "_duty_" .. locationName,
                            heading = dutyData.coords.w,
                            debugPoly = false,
                            minZ = dutyData.coords.z - 1.0,
                            maxZ = dutyData.coords.z + 1.0
                        },
                        {
                            options = {
                                {
                                    type = "client",
                                    event = "sl-jobs:client:ToggleDuty",
                                    icon = "fas fa-sign-in-alt",
                                    label = "Toggle Duty",
                                    job = jobName
                                }
                            },
                            distance = 2.0
                        }
                    )
                end
            end
        end
    end
end

-- Toggle Duty
RegisterNetEvent('sl-jobs:client:ToggleDuty', function()
    local PlayerData = SLCore.Functions.GetPlayerData()
    local jobName = PlayerData.job.name
    local jobData = Config.Jobs[jobName]
    
    if not jobData then return end
    
    TriggerServerEvent('sl-jobs:server:ToggleDuty')
end)

-- Key Controls (if not using target)
if not Config.Duty.useTarget then
    CreateThread(function()
        while true do
            local sleep = 1000
            local pos = GetEntityCoords(PlayerPedId())
            local inRange = false
            
            for _, dutyZone in pairs(dutyZones) do
                if PlayerData.job.name == dutyZone.job then
                    local dist = #(pos - vector3(dutyZone.data.coords.x, dutyZone.data.coords.y, dutyZone.data.coords.z))
                    if dist < 5.0 then
                        sleep = 0
                        inRange = true
                        DrawMarker(2, dutyZone.data.coords.x, dutyZone.data.coords.y, dutyZone.data.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                        
                        if dist < 1.5 then
                            DrawText3D(dutyZone.data.coords.x, dutyZone.data.coords.y, dutyZone.data.coords.z + 0.2, '[' .. Config.Duty.dutyKey .. '] - Toggle Duty')
                            if IsControlJustReleased(0, Keys[Config.Duty.dutyKey]) then
                                TriggerServerEvent('sl-jobs:server:ToggleDuty')
                            end
                        end
                    end
                end
            end
            
            if not inRange then
                sleep = 1000
            end
            
            Wait(sleep)
        end
    end)
end

-- Utility Functions
function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end 