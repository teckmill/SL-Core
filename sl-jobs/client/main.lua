local SLCore = exports['sl-core']:GetCoreObject()
local PlayerData = {}
local JobData = {}
local CurrentZones = {}
local isInDutyZone = false
local isInVehicleZone = false

-- Initialize
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    PlayerData = SLCore.Functions.GetPlayerData()
    TriggerServerEvent('sl-jobs:server:RequestJobData')
    InitializeJobZones()
end)

RegisterNetEvent('SLCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    TriggerServerEvent('sl-jobs:server:RequestJobData')
    InitializeJobZones()
end)

-- Job Data Management
RegisterNetEvent('sl-jobs:client:ReceiveJobData', function(data)
    JobData = data
    RefreshJobBlips()
end)

-- Zone Management
function InitializeJobZones()
    RemoveJobZones()
    if not PlayerData.job then return end
    
    local jobConfig = Config.Jobs[PlayerData.job.name]
    if not jobConfig then return end

    -- Duty Zones
    if jobConfig.locations.duty then
        for i, coords in pairs(jobConfig.locations.duty) do
            local zone = BoxZone:Create(
                vector3(coords.x, coords.y, coords.z),
                2.0, 2.0,
                {
                    name = "duty_" .. PlayerData.job.name .. "_" .. i,
                    heading = coords.w,
                    debugPoly = Config.Debug,
                    minZ = coords.z - 1.0,
                    maxZ = coords.z + 2.0
                }
            )
            zone:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    isInDutyZone = true
                    exports['sl-core']:DrawText('[E] Toggle Duty', 'left')
                else
                    isInDutyZone = false
                    exports['sl-core']:HideText()
                end
            end)
            CurrentZones[#CurrentZones + 1] = zone
        end
    end

    -- Vehicle Zones
    if jobConfig.locations.vehicles then
        for i, coords in pairs(jobConfig.locations.vehicles) do
            local zone = BoxZone:Create(
                vector3(coords.x, coords.y, coords.z),
                3.0, 3.0,
                {
                    name = "vehicle_" .. PlayerData.job.name .. "_" .. i,
                    heading = coords.w,
                    debugPoly = Config.Debug,
                    minZ = coords.z - 1.0,
                    maxZ = coords.z + 2.0
                }
            )
            zone:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    isInVehicleZone = true
                    exports['sl-core']:DrawText('[E] Vehicle Menu', 'left')
                else
                    isInVehicleZone = false
                    exports['sl-core']:HideText()
                end
            end)
            CurrentZones[#CurrentZones + 1] = zone
        end
    end
end

function RemoveJobZones()
    for _, zone in ipairs(CurrentZones) do
        zone:destroy()
    end
    CurrentZones = {}
end

-- Blip Management
function RefreshJobBlips()
    RemoveJobBlips()
    if not PlayerData.job then return end
    
    local jobConfig = Config.Jobs[PlayerData.job.name]
    if not jobConfig then return end

    -- Duty Location Blips
    if jobConfig.locations.duty then
        for _, coords in pairs(jobConfig.locations.duty) do
            local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
            SetBlipSprite(blip, 525)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.7)
            SetBlipColour(blip, 38)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(jobConfig.label .. " - Duty")
            EndTextCommandSetBlipName(blip)
            CurrentBlips[#CurrentBlips + 1] = blip
        end
    end
end

function RemoveJobBlips()
    if CurrentBlips then
        for _, blip in pairs(CurrentBlips) do
            RemoveBlip(blip)
        end
    end
    CurrentBlips = {}
end

-- Skill System
function UpdateSkill(skillName, amount)
    if not PlayerData.job or not JobData[PlayerData.job.name] then return end
    
    local currentSkills = JobData[PlayerData.job.name].skills or {}
    currentSkills[skillName] = math.min(
        (currentSkills[skillName] or 0) + amount,
        Config.MaxSkillLevel
    )
    
    TriggerServerEvent('sl-jobs:server:UpdateSkills', PlayerData.job.name, currentSkills)
end

-- Duty Management
RegisterNetEvent('sl-jobs:client:ToggleDuty', function()
    if not PlayerData.job then return end
    TriggerServerEvent('SLCore:ToggleDuty')
end)

-- Vehicle Management
function OpenVehicleMenu()
    if not PlayerData.job then return end
    
    local jobConfig = Config.Jobs[PlayerData.job.name]
    if not jobConfig or not jobConfig.vehicles then return end
    
    local vehicles = jobConfig.vehicles[PlayerData.job.grade] or {}
    local elements = {}
    
    for model, label in pairs(vehicles) do
        elements[#elements + 1] = {
            title = label,
            event = 'sl-jobs:client:SpawnVehicle',
            args = {
                model = model
            }
        }
    end
    
    exports['sl-menu']:openMenu(elements)
end

RegisterNetEvent('sl-jobs:client:SpawnVehicle', function(data)
    if not PlayerData.job then return end
    
    local jobConfig = Config.Jobs[PlayerData.job.name]
    if not jobConfig or not jobConfig.vehicles then return end
    
    local coords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    
    SLCore.Functions.SpawnVehicle(data.model, function(vehicle)
        SetEntityHeading(vehicle, heading)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
        SetVehicleEngineOn(vehicle, true, true)
    end, coords, true)
end)

-- Key Mapping
RegisterKeyMapping('togglejobmenu', 'Toggle Job Menu', 'keyboard', 'F6')

-- Commands
RegisterCommand('togglejobmenu', function()
    if not PlayerData.job then return end
    exports['sl-menu']:openMenu({
        {
            title = "Job Information",
            description = "View your current job details",
            event = "sl-jobs:client:ShowJobInfo"
        },
        {
            title = "Skills",
            description = "View your job skills",
            event = "sl-jobs:client:ShowSkills"
        }
    })
end)

-- Events
RegisterNetEvent('sl-jobs:client:ShowJobInfo', function()
    if not PlayerData.job or not JobData[PlayerData.job.name] then return end
    
    local jobInfo = JobData[PlayerData.job.name]
    local elements = {
        {
            title = "Job: " .. PlayerData.job.label,
            description = "Grade: " .. PlayerData.job.grade_label
        }
    }
    
    exports['sl-menu']:openMenu(elements)
end)

RegisterNetEvent('sl-jobs:client:ShowSkills', function()
    if not PlayerData.job or not JobData[PlayerData.job.name] then return end
    
    local skills = JobData[PlayerData.job.name].skills or {}
    local elements = {}
    
    for skill, level in pairs(skills) do
        elements[#elements + 1] = {
            title = Config.Skills[skill].label,
            description = "Level: " .. level .. "/" .. Config.MaxSkillLevel
        }
    end
    
    exports['sl-menu']:openMenu(elements)
end)

-- Main Thread
CreateThread(function()
    while true do
        if isInDutyZone then
            if IsControlJustReleased(0, 38) then -- E key
                TriggerEvent('sl-jobs:client:ToggleDuty')
            end
        elseif isInVehicleZone then
            if IsControlJustReleased(0, 38) then -- E key
                OpenVehicleMenu()
            end
        end
        Wait(0)
    end
end)

-- Skill Experience Thread
CreateThread(function()
    while true do
        if PlayerData.job and JobData[PlayerData.job.name] then
            local jobConfig = Config.Jobs[PlayerData.job.name]
            if jobConfig and jobConfig.grades[PlayerData.job.grade] then
                local skillGains = jobConfig.grades[PlayerData.job.grade].skills.gainRate
                if skillGains then
                    for skill, rate in pairs(skillGains) do
                        UpdateSkill(skill, rate)
                    end
                end
            end
        end
        Wait(Config.SkillGainInterval * 60 * 1000)
    end
end)
