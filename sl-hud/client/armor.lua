local SLCore = exports['sl-core']:GetCoreObject()

-- Armor System Variables
local isWearingArmor = false
local armorType = nil

-- Armor Types and Their Values
local armorTypes = {
    ['light_armor'] = 50,
    ['medium_armor'] = 75,
    ['heavy_armor'] = 100
}

-- Event handler for armor item use
RegisterNetEvent('sl-hud:client:UseArmor', function(armorItem)
    local ped = PlayerPedId()
    if not isWearingArmor then
        if armorTypes[armorItem] then
            isWearingArmor = true
            armorType = armorItem
            SetPedArmour(ped, armorTypes[armorItem])
            TriggerEvent('sl-hud:client:UpdateStatus', 'armor', armorTypes[armorItem])
        end
    else
        -- Remove current armor before applying new one
        SetPedArmour(ped, 0)
        isWearingArmor = false
        armorType = nil
        TriggerEvent('sl-hud:client:UpdateStatus', 'armor', 0)
    end
end)

-- Check armor damage
CreateThread(function()
    while true do
        Wait(1000)
        if isWearingArmor and LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            local currentArmor = GetPedArmour(ped)
            if currentArmor <= 0 then
                isWearingArmor = false
                armorType = nil
            end
        end
    end
end)
