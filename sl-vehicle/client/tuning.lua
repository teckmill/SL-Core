local SLCore = nil
local CoreReady = false
local currentVehicle = nil
local tuningMenu = false

-- Wait for core to be ready
CreateThread(function()
    while SLCore == nil do
        if GetResourceState('sl-core') == 'started' then
            SLCore = exports['sl-core']:GetCoreObject()
            if SLCore then
                CoreReady = true
                print('^2[SL-Vehicle] ^7Successfully connected to SL-Core')
                break
            end
        end
        Wait(100)
    end
end)

-- Functions
local function GetVehicleTuning(vehicle)
    if not DoesEntityExist(vehicle) then return nil end
    
    return {
        engine = GetVehicleMod(vehicle, 11),
        brakes = GetVehicleMod(vehicle, 12),
        transmission = GetVehicleMod(vehicle, 13),
        suspension = GetVehicleMod(vehicle, 15),
        turbo = IsToggleModOn(vehicle, 18),
        xenon = IsToggleModOn(vehicle, 22),
        neon = {
            enabled = {
                IsVehicleNeonLightEnabled(vehicle, 0),
                IsVehicleNeonLightEnabled(vehicle, 1),
                IsVehicleNeonLightEnabled(vehicle, 2),
                IsVehicleNeonLightEnabled(vehicle, 3)
            },
            color = table.pack(GetVehicleNeonLightsColour(vehicle))
        },
        windowTint = GetVehicleWindowTint(vehicle),
        tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicle))
    }
end

local function ApplyVehicleTuning(vehicle, tuning)
    if not DoesEntityExist(vehicle) or not tuning then return end
    
    SetVehicleModKit(vehicle, 0)
    
    if tuning.engine then SetVehicleMod(vehicle, 11, tuning.engine, false) end
    if tuning.brakes then SetVehicleMod(vehicle, 12, tuning.brakes, false) end
    if tuning.transmission then SetVehicleMod(vehicle, 13, tuning.transmission, false) end
    if tuning.suspension then SetVehicleMod(vehicle, 15, tuning.suspension, false) end
    if tuning.turbo ~= nil then ToggleVehicleMod(vehicle, 18, tuning.turbo) end
    if tuning.xenon ~= nil then ToggleVehicleMod(vehicle, 22, tuning.xenon) end
    
    if tuning.neon then
        if tuning.neon.enabled then
            SetVehicleNeonLightEnabled(vehicle, 0, tuning.neon.enabled[1])
            SetVehicleNeonLightEnabled(vehicle, 1, tuning.neon.enabled[2])
            SetVehicleNeonLightEnabled(vehicle, 2, tuning.neon.enabled[3])
            SetVehicleNeonLightEnabled(vehicle, 3, tuning.neon.enabled[4])
        end
        if tuning.neon.color then
            SetVehicleNeonLightsColour(vehicle, tuning.neon.color[1], tuning.neon.color[2], tuning.neon.color[3])
        end
    end
    
    if tuning.windowTint then SetVehicleWindowTint(vehicle, tuning.windowTint) end
    if tuning.tyreSmokeColor then
        ToggleVehicleMod(vehicle, 20, true)
        SetVehicleTyreSmokeColor(vehicle, tuning.tyreSmokeColor[1], tuning.tyreSmokeColor[2], tuning.tyreSmokeColor[3])
    end
end

-- Events
RegisterNetEvent('sl-vehicle:client:OpenTuningMenu', function()
    if not CoreReady then return end
    if tuningMenu then return end
    
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then
        SLCore.Functions.Notify('You must be in a vehicle', 'error')
        return
    end
    
    local vehicle = GetVehiclePedIsIn(ped, false)
    if not DoesEntityExist(vehicle) then return end
    
    local plate = GetVehicleNumberPlateText(vehicle)
    SLCore.Functions.TriggerCallback('sl-vehicle:server:GetVehicleTuning', function(result)
        if result then
            currentVehicle = vehicle
            tuningMenu = true
            -- Open tuning menu UI here
            -- This will be implemented when we add the UI system
        end
    end, plate)
end)

RegisterNetEvent('sl-vehicle:client:ApplyTuning', function(tuning)
    if not CoreReady or not currentVehicle then return end
    
    ApplyVehicleTuning(currentVehicle, tuning)
    local plate = GetVehicleNumberPlateText(currentVehicle)
    
    TriggerServerEvent('sl-vehicle:server:UpdateVehicle', plate, {
        tuning = json.encode(GetVehicleTuning(currentVehicle))
    })
end)

-- Exports
exports('GetVehicleTuning', GetVehicleTuning)
exports('ApplyVehicleTuning', ApplyVehicleTuning)
