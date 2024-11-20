local SLCore = exports['sl-core']:GetCoreObject()

-- Hunger System Variables
local hunger = 100
local lastHunger = 100
local hungerRate = 0.1 -- Rate at which hunger decreases

-- Update Hunger Status
CreateThread(function()
    while true do
        Wait(10000) -- Update every 10 seconds
        if LocalPlayer.state.isLoggedIn then
            -- Decrease hunger over time
            hunger = math.max(0, hunger - hungerRate)
            
            if hunger ~= lastHunger then
                lastHunger = hunger
                TriggerEvent('sl-hud:client:UpdateStatus', 'hunger', hunger)
                
                -- Apply hunger effects
                if hunger <= 0 then
                    local ped = PlayerPedId()
                    local health = GetEntityHealth(ped)
                    SetEntityHealth(ped, health - 1)
                end
            end
        end
    end
end)

-- Event handler for food consumption
RegisterNetEvent('sl-hud:client:EatFood', function(amount)
    hunger = math.min(100, hunger + amount)
    TriggerEvent('sl-hud:client:UpdateStatus', 'hunger', hunger)
end)
