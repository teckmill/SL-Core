local SLCore = exports['sl-core']:GetCoreObject()
local currentMission = nil
local missionBlip = nil
local missionMarker = nil

-- Mission Configuration
local Missions = {
    delivery = {
        title = "Delivery Mission",
        description = "Deliver packages to marked locations",
        reward = 500,
        duration = 600, -- 10 minutes
        locations = {
            vector3(-255.95, -983.14, 31.22),
            vector3(149.58, -1040.71, 29.37),
            vector3(-141.16, -592.04, 32.42)
        }
    },
    patrol = {
        title = "Patrol Mission",
        description = "Patrol marked areas of the city",
        reward = 750,
        duration = 900, -- 15 minutes
        locations = {
            vector3(428.23, -984.28, 30.71),
            vector3(-1094.83, -836.18, 19.0),
            vector3(827.25, -1290.03, 28.24)
        }
    }
}

-- Mission Functions
function StartMission(missionType)
    if currentMission then return end
    
    local mission = Missions[missionType]
    if not mission then return end
    
    currentMission = {
        type = missionType,
        startTime = GetGameTimer(),
        completed = 0,
        total = #mission.locations
    }
    
    -- Create mission blip
    local location = mission.locations[1]
    missionBlip = AddBlipForCoord(location.x, location.y, location.z)
    SetBlipSprite(missionBlip, 1)
    SetBlipRoute(missionBlip, true)
    
    -- Notify player
    SLCore.Functions.Notify(mission.title .. " started!", "success")
end

function CompleteMissionPoint()
    if not currentMission then return end
    
    local mission = Missions[currentMission.type]
    currentMission.completed = currentMission.completed + 1
    
    if currentMission.completed >= currentMission.total then
        CompleteMission()
    else
        -- Update to next point
        local nextLocation = mission.locations[currentMission.completed + 1]
        SetBlipCoords(missionBlip, nextLocation.x, nextLocation.y, nextLocation.z)
        SetBlipRoute(missionBlip, true)
    end
end

function CompleteMission()
    if not currentMission then return end
    
    local mission = Missions[currentMission.type]
    TriggerServerEvent('sl-jobs:server:CompleteMission', currentMission.type)
    
    -- Cleanup
    if missionBlip then
        RemoveBlip(missionBlip)
        missionBlip = nil
    end
    
    currentMission = nil
    SLCore.Functions.Notify(mission.title .. " completed!", "success")
end

-- Events
RegisterNetEvent('sl-jobs:client:StartMission')
AddEventHandler('sl-jobs:client:StartMission', function(missionType)
    StartMission(missionType)
end)

-- Threads
CreateThread(function()
    while true do
        Wait(0)
        if currentMission then
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local mission = Missions[currentMission.type]
            local targetLocation = mission.locations[currentMission.completed + 1]
            
            local distance = #(coords - targetLocation)
            if distance < 5.0 then
                DrawMarker(1, targetLocation.x, targetLocation.y, targetLocation.z - 1.0, 
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
                    1.5, 1.5, 1.0, 255, 255, 0, 100, 
                    false, true, 2, false, nil, nil, false)
                
                if distance < 1.5 then
                    SLCore.Functions.DrawText3D(targetLocation.x, targetLocation.y, targetLocation.z, 
                        '[E] Complete Point')
                    
                    if IsControlJustReleased(0, 38) then -- E key
                        CompleteMissionPoint()
                    end
                end
            end
        end
    end
end)
