local SLCore = exports['sl-core']:GetCoreObject()

-- Vehicle Variables
local isInVehicle = false
local currentVehicle = 0
local vehicleSpeed = 0
local vehicleFuel = 0
local vehicleHealth = 1000
local seatbeltOn = false

-- Constants
local SPEED_MULTIPLIER = 2.236936 -- Convert to MPH
local UPDATE_INTERVAL = 200 -- Update interval in ms

-- Update Vehicle HUD
local function UpdateVehicleHUD()
    if not isInVehicle then return end
    
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    -- Get vehicle stats
    vehicleSpeed = GetEntitySpeed(vehicle) * SPEED_MULTIPLIER
    vehicleFuel = GetVehicleFuelLevel(vehicle)
    vehicleHealth = GetVehicleEngineHealth(vehicle)
    
    -- Update UI
    SendNUIMessage({
        action = "updateVehicle",
        show = true,
        speed = vehicleSpeed,
        fuel = vehicleFuel,
        engineHealth = vehicleHealth,
        seatbelt = seatbeltOn
    })
end

-- Vehicle Entry/Exit
CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        local inVehicle = IsPedInAnyVehicle(ped, false)
        
        if inVehicle ~= isInVehicle then
            isInVehicle = inVehicle
            if not isInVehicle then
                -- Hide vehicle HUD when exiting
                SendNUIMessage({
                    action = "updateVehicle",
                    show = false
                })
                seatbeltOn = false
            end
        end
    end
end)

-- Vehicle Stats Update Loop
CreateThread(function()
    while true do
        Wait(UPDATE_INTERVAL)
        if isInVehicle then
            UpdateVehicleHUD()
        end
    end
end)

-- Seatbelt Toggle
RegisterCommand('toggleseatbelt', function()
    if not isInVehicle then return end
    
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    local class = GetVehicleClass(vehicle)
    
    -- Don't allow seatbelt in motorcycles
    if class == 8 or class == 13 then return end
    
    seatbeltOn = not seatbeltOn
    TriggerEvent('sl-hud:client:ToggleSeatbelt', seatbeltOn)
    
    -- Play buckle/unbuckle sound
    PlaySoundFrontend(-1, seatbeltOn and "Faster_Click" or "Click_Fail", "RESPAWN_ONLINE_SOUNDSET", 1)
end)

RegisterKeyMapping('toggleseatbelt', 'Toggle Seatbelt', 'keyboard', 'b')

-- Seatbelt Effect
CreateThread(function()
    while true do
        Wait(0)
        if isInVehicle and not seatbeltOn then
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped, false)
            
            -- Eject player on crash if no seatbelt
            if GetEntitySpeedVector(vehicle, true).y > 1.0 and 
               GetLastMaterialHitByEntity(vehicle) ~= 0 then
                SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
                SetEntityVelocity(ped, GetEntitySpeedVector(vehicle, true).x * 4.0,
                                     GetEntitySpeedVector(vehicle, true).y * 4.0,
                                     GetEntitySpeedVector(vehicle, true).z * 4.0)
            end
        end
    end
end)
