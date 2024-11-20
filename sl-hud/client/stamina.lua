local SLCore = exports['sl-core']:GetCoreObject()

-- Stamina System Variables
local stamina = 100
local lastStamina = 100
local isSwimming = false
local isRunning = false

-- Update Stamina Status
CreateThread(function()
    while true do
        Wait(200)
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            stamina = GetPlayerStamina(PlayerId())
            isSwimming = IsPedSwimming(ped)
            isRunning = IsPedRunning(ped) or IsPedSprinting(ped)
            
            -- Reduce stamina while running or swimming
            if isRunning or isSwimming then
                stamina = math.max(0, stamina - 1)
            else
                -- Regenerate stamina while resting
                stamina = math.min(100, stamina + 0.5)
            end
            
            if stamina ~= lastStamina then
                lastStamina = stamina
                TriggerEvent('sl-hud:client:UpdateStatus', 'stamina', stamina)
            end
            
            -- Apply stamina effects
            if stamina <= 0 then
                SetPedMoveRateOverride(ped, 0.8)
            else
                SetPedMoveRateOverride(ped, 1.0)
            end
        end
    end
end)
