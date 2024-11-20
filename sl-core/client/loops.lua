local SLCore = exports['sl-core']:GetCoreObject()

-- Player State Check Loop
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            Wait(10000)
            if SLCore.Functions.GetPlayerData().metadata["hunger"] <= 0 or
               SLCore.Functions.GetPlayerData().metadata["thirst"] <= 0 then
                local ped = PlayerPedId()
                local currentHealth = GetEntityHealth(ped)
                SetEntityHealth(ped, currentHealth - math.random(5, 10))
            end
        end
        Wait(5000)
    end
end)

-- AFK Kick Loop
CreateThread(function()
    while true do
        Wait(1000)
        local player = PlayerPedId()
        if LocalPlayer.state.isLoggedIn then
            if not IsEntityDead(player) then
                local playerId = PlayerId()
                if not SLCore.Functions.GetPlayerData().metadata["injail"] then
                    if IsPauseMenuActive() then
                        if SLCore.Config.Server.AfkTimeout then
                            SLCore.Functions.Notify('You are AFK and will be kicked in ' .. math.ceil(SLCore.Config.Server.AfkTimeout / 60) .. ' minutes!', 'error', 10000)
                        end
                    end
                end
            end
        end
    end
end)

-- Player Load Check Loop
CreateThread(function()
    while true do
        Wait(1000)
        if LocalPlayer.state.isLoggedIn then
            Wait(30000)
            TriggerEvent('SLCore:Client:UpdateObject')
        end
    end
end)

-- Health Loop
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            if SLCore.PlayerData.metadata['dead'] then
                DisableAllControlActions(0)
                EnableControlAction(0, 1, true) -- Camera
                EnableControlAction(0, 2, true) -- Camera
                EnableControlAction(0, 245, true) -- Chat
            end
            
            -- Update health in metadata
            local health = GetEntityHealth(ped)
            if health ~= SLCore.PlayerData.metadata['health'] then
                TriggerServerEvent('SLCore:Server:SetMetaData', 'health', health)
            end
        end
        Wait(1000)
    end
end)

-- Position Sync Loop
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            if SLCore.PlayerData.metadata['lastposition'] ~= pos then
                TriggerServerEvent('SLCore:Server:SetMetaData', 'lastposition', pos)
            end
        end
        Wait(5000)
    end
end)

-- Stress Loop
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            -- Add stress based on actions
            if IsPedShooting(ped) then
                TriggerServerEvent('SLCore:Server:AddStress', 1)
            end
            if IsPedInMeleeCombat(ped) then
                TriggerServerEvent('SLCore:Server:AddStress', 2)
            end
        end
        Wait(3000)
    end
end)

-- Weapon Loop
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)
            if weapon ~= SLCore.PlayerData.metadata['currentweapon'] then
                TriggerServerEvent('SLCore:Server:SetMetaData', 'currentweapon', weapon)
            end
        end
        Wait(1000)
    end
end)
