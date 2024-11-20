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
