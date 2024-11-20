local SLCore = exports['sl-core']:GetCoreObject()

-- Thirst System Variables
local thirst = 100
local lastThirst = 100
local thirstRate = 0.15 -- Rate at which thirst decreases

-- Update Thirst Status
CreateThread(function()
    while true do
        Wait(10000) -- Update every 10 seconds
        if LocalPlayer.state.isLoggedIn then
            -- Decrease thirst over time
            thirst = math.max(0, thirst - thirstRate)
            
            if thirst ~= lastThirst then
                lastThirst = thirst
                TriggerEvent('sl-hud:client:UpdateStatus', 'thirst', thirst)
                
                -- Apply thirst effects
                if thirst <= 0 then
                    local ped = PlayerPedId()
                    local health = GetEntityHealth(ped)
                    SetEntityHealth(ped, health - 1)
                end
            end
            
            -- Increase thirst rate while running or in hot weather
            local ped = PlayerPedId()
            if IsPedRunning(ped) or IsPedSprinting(ped) then
                thirstRate = 0.25
            else
                thirstRate = 0.15
            end
        end
    end
end)

-- Event handler for drink consumption
RegisterNetEvent('sl-hud:client:DrinkBeverage', function(amount)
    thirst = math.min(100, thirst + amount)
    TriggerEvent('sl-hud:client:UpdateStatus', 'thirst', thirst)
end)
