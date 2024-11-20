local SLCore = exports['sl-core']:GetCoreObject()

-- Gang Variables
local isEnabled = true
local currentGang = nil
local currentGrade = nil

-- Update Gang Display
local function UpdateGangHUD()
    if not isEnabled then return end
    
    local Player = SLCore.Functions.GetPlayerData()
    if not Player then return end
    
    local gangInfo = Player.gang
    if not gangInfo then return end
    
    -- Only update if gang changed
    if currentGang ~= gangInfo.name or currentGrade ~= gangInfo.grade.level then
        currentGang = gangInfo.name
        currentGrade = gangInfo.grade.level
        
        SendNUIMessage({
            action = "updateGang",
            gang = gangInfo.label,
            grade = gangInfo.grade.name,
            show = true
        })
    end
end

-- Gang Update Events
RegisterNetEvent('sl-hud:client:UpdateGang')
AddEventHandler('sl-hud:client:UpdateGang', function()
    UpdateGangHUD()
end)

-- Toggle Gang Display
RegisterCommand('togglegang', function()
    isEnabled = not isEnabled
    SendNUIMessage({
        action = "updateGang",
        show = isEnabled
    })
end)

-- Gang Territory Check
CreateThread(function()
    while true do
        Wait(1000)
        if isEnabled then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            
            -- Check if player is in gang territory
            local inTerritory = exports['sl-gangs']:IsInGangTerritory(coords)
            if inTerritory then
                SendNUIMessage({
                    action = "updateTerritory",
                    territory = inTerritory,
                    show = true
                })
            end
        end
    end
end)

-- Initialize Gang Display
CreateThread(function()
    Wait(1000)
    UpdateGangHUD()
end)

-- Gang Update Loop
CreateThread(function()
    while true do
        Wait(5000) -- Check every 5 seconds
        UpdateGangHUD()
    end
end)

-- Gang Reputation System
RegisterNetEvent('sl-hud:client:UpdateReputation')
AddEventHandler('sl-hud:client:UpdateReputation', function(rep)
    if not isEnabled then return end
    
    SendNUIMessage({
        action = "updateReputation",
        reputation = rep,
        show = true
    })
end)
