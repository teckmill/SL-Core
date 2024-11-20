CreateThread(function()
    while true do
        Wait(0)
        if LocalPlayer.state.isLoggedIn then
            Wait(1000 * 60) -- Wait a minute
            TriggerServerEvent('SLCore:UpdatePlayer')
        else
            Wait(1000)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(SLCore.Config.UpdateInterval)
        if LocalPlayer.state.isLoggedIn then
            local position = GetEntityCoords(PlayerPedId())
            if SLCore.Functions.GetPlayerData().metadata["tracker"] then
                local gender = SLCore.Functions.GetPlayerData().charinfo.gender
                TriggerServerEvent("SLCore:UpdatePlayerPosition", position, gender)
            else
                TriggerServerEvent("SLCore:UpdatePlayerPosition", position)
            end
        end
    end
end)

-- Health/Armor Updates
CreateThread(function()
    while true do
        Wait(1000)
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            local health = GetEntityHealth(ped)
            local armor = GetPedArmour(ped)
            if health ~= currentHealth or armor ~= currentArmor then
                currentHealth = health
                currentArmor = armor
                TriggerServerEvent('SLCore:Server:UpdatePlayerData')
            end
        end
    end
end)

-- Stress Gain
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            if IsPedShooting(ped) then
                local stressGain = math.random(1, 3)
                TriggerServerEvent('SLCore:Server:UpdatePlayerData', "metadata", "stress", stressGain)
            end
        end
        Wait(100)
    end
end)

-- Hunger/Thirst Decrease
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            local decrease = math.random(2, 4)
            TriggerServerEvent('SLCore:Server:UpdatePlayerData', "metadata", "hunger", -decrease)
            TriggerServerEvent('SLCore:Server:UpdatePlayerData', "metadata", "thirst", -decrease)
        end
        Wait(1000 * 60 * SLCore.Config.UpdateInterval)
    end
end)
