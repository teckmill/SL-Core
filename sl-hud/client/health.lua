local SLCore = exports['sl-core']:GetCoreObject()

-- Health System Variables
local health = 100
local armor = 0
local lastHealth = 100
local lastArmor = 0

-- Update Health Status
CreateThread(function()
    while true do
        Wait(500)
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            health = GetEntityHealth(ped) - 100
            armor = GetPedArmour(ped)
            
            if health ~= lastHealth or armor ~= lastArmor then
                lastHealth = health
                lastArmor = armor
                TriggerEvent('sl-hud:client:UpdateStatus', 'health', health)
                TriggerEvent('sl-hud:client:UpdateStatus', 'armor', armor)
            end
        end
    end
end)
