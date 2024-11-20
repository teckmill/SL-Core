local SLCore = nil
local CoreReady = false

-- Wait for core to be ready
CreateThread(function()
    while SLCore == nil do
        SLCore = exports['sl-core']:GetCoreObject()
        if not SLCore then 
            Wait(100)
        end
    end
    CoreReady = true
    InitializeMechanics()
end)

-- Local Variables
local PlayerJob = {}
local onDuty = false
local currentGarage = nil
local currentVehicle = nil
local currentLift = nil

-- Functions
local function LoadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(0)
    end
end

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function SetVehicleDamage(vehicle, health)
    local engineHealth = health
    local bodyHealth = health
    local petrolTankHealth = health
    
    SetVehicleEngineHealth(vehicle, engineHealth)
    SetVehicleBodyHealth(vehicle, bodyHealth)
    SetVehiclePetrolTankHealth(vehicle, petrolTankHealth)
end

local function RepairVehicle(vehicle)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    if DoesEntityExist(vehicle) then
        local vehCoords = GetEntityCoords(vehicle)
        if #(coords - vehCoords) < 5.0 then
            local time = math.random(10000, 20000)
            
            LoadAnimDict("mini@repair")
            TaskPlayAnim(ped, "mini@repair", "fixing_a_ped", 8.0, -8.0, -1, 1, 0, false, false, false)
            
            SLCore.Functions.Progressbar("repair_vehicle", "Repairing Vehicle...", time, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                StopAnimTask(ped, "mini@repair", "fixing_a_ped", 1.0)
                SetVehicleFixed(vehicle)
                SetVehicleDirtLevel(vehicle, 0.0)
                SetVehicleEngineHealth(vehicle, 1000.0)
                SetVehicleBodyHealth(vehicle, 1000.0)
                SLCore.Functions.Notify("Vehicle repaired!", "success")
            end, function() -- Cancel
                StopAnimTask(ped, "mini@repair", "fixing_a_ped", 1.0)
                SLCore.Functions.Notify("Repair cancelled!", "error")
            end)
        end
    end
end

-- Initialize
function InitializeMechanics()
    -- Create Blips
    for k, v in pairs(Config.Locations) do
        if v.blip then
            local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
            SetBlipSprite(blip, v.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, v.blip.scale)
            SetBlipColour(blip, v.blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blip.label)
            EndTextCommandSetBlipName(blip)
        end
    end
end

-- Events
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    PlayerJob = SLCore.Functions.GetPlayerData().job
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent('SLCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('SLCore:Client:SetDuty', function(duty)
    onDuty = duty
end)

RegisterNetEvent('sl-mechanics:client:RepairVehicle', function()
    local vehicle = SLCore.Functions.GetClosestVehicle()
    if vehicle ~= 0 then
        RepairVehicle(vehicle)
    end
end)

-- Threads
CreateThread(function()
    while true do
        if CoreReady then
            local sleep = 1000
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            
            if PlayerJob.name and Config.MechanicJobs[PlayerJob.name] then
                for k, v in pairs(Config.Locations) do
                    local dist = #(pos - v.coords)
                    if dist < 10 then
                        sleep = 0
                        if dist < 3 then
                            if not onDuty then
                                DrawText3D(v.coords.x, v.coords.y, v.coords.z, "~g~E~w~ - Go on duty")
                                if IsControlJustReleased(0, 38) then
                                    TriggerServerEvent("SLCore:ToggleDuty")
                                end
                            else
                                DrawText3D(v.coords.x, v.coords.y, v.coords.z, "~r~E~w~ - Go off duty")
                                if IsControlJustReleased(0, 38) then
                                    TriggerServerEvent("SLCore:ToggleDuty")
                                end
                            end
                        end
                    end
                end
            end
            Wait(sleep)
        else
            Wait(1000)
        end
    end
end)

-- Exports
exports('RepairVehicle', RepairVehicle)
