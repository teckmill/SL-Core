local SLCore = exports['sl-core']:GetCoreObject()

-- Stress System Variables
local stress = 0
local lastStress = 0
local stressRate = 0

-- Stress Factors
local stressFactors = {
    SHOOTING = 3,
    RUNNING = 0.1,
    INJURED = 0.5,
    DRIVING_FAST = 0.2
}

-- Update Stress Status
CreateThread(function()
    while true do
        Wait(1000)
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            
            -- Check various stress factors
            if IsPedShooting(ped) then
                AddStress(stressFactors.SHOOTING)
            end
            
            if IsPedRunning(ped) or IsPedSprinting(ped) then
                AddStress(stressFactors.RUNNING)
            end
            
            if GetEntityHealth(ped) < 150 then
                AddStress(stressFactors.INJURED)
            end
            
            if IsPedInAnyVehicle(ped, false) then
                local speed = GetEntitySpeed(GetVehiclePedIsIn(ped, false))
                if speed > 100 then
                    AddStress(stressFactors.DRIVING_FAST)
                end
            end
            
            -- Natural stress reduction over time
            if stress > 0 then
                stress = math.max(0, stress - 0.05)
                if stress ~= lastStress then
                    lastStress = stress
                    TriggerEvent('sl-hud:client:UpdateStatus', 'stress', stress)
                end
            end
            
            -- Apply stress effects
            if stress >= 80 then
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
            end
        end
    end
end)

-- Function to add stress
function AddStress(amount)
    stress = math.min(100, stress + amount)
    TriggerEvent('sl-hud:client:UpdateStatus', 'stress', stress)
end

-- Event handler for stress relief items
RegisterNetEvent('sl-hud:client:RelieveStress', function(amount)
    stress = math.max(0, stress - amount)
    TriggerEvent('sl-hud:client:UpdateStatus', 'stress', stress)
end)
