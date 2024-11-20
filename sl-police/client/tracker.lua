local SLCore = exports['sl-core']:GetCoreObject()
local activeTrackers = {}
local isTracking = false
local currentTracker = nil

-- Function to place tracker
local function placeTracker(targetId)
    if not IsPoliceJob() then return end
    
    local player = GetPlayerFromServerId(targetId)
    if not player then return end
    
    local targetPed = GetPlayerPed(player)
    local coords = GetEntityCoords(targetPed)
    
    TriggerServerEvent('sl-police:server:PlaceTracker', targetId, coords)
end

-- Function to remove tracker
local function removeTracker(targetId)
    if not IsPoliceJob() then return end
    
    TriggerServerEvent('sl-police:server:RemoveTracker', targetId)
end

-- Function to update tracker position
local function updateTrackerPosition()
    while isTracking do
        Wait(1000)
        if currentTracker then
            local player = GetPlayerFromServerId(currentTracker)
            if player then
                local targetPed = GetPlayerPed(player)
                local coords = GetEntityCoords(targetPed)
                TriggerServerEvent('sl-police:server:UpdateTrackerLocation', currentTracker, coords)
            end
        end
    end
end

-- Function to start tracking
RegisterNetEvent('sl-police:client:StartTracking', function(targetId)
    if not IsPoliceJob() then return end
    
    isTracking = true
    currentTracker = targetId
    SLCore.Functions.Notify(Lang:t('info.tracker_active'), 'success')
    CreateThread(updateTrackerPosition)
end)

-- Function to stop tracking
RegisterNetEvent('sl-police:client:StopTracking', function()
    isTracking = false
    currentTracker = nil
    SLCore.Functions.Notify(Lang:t('info.tracker_removed'), 'error')
end)

-- Function to show tracker blip
RegisterNetEvent('sl-police:client:UpdateTrackerLocation', function(coords)
    if not IsPoliceJob() then return end
    
    if not DoesBlipExist(activeTrackers[currentTracker]) then
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 161)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Tracker")
        EndTextCommandSetBlipName(blip)
        activeTrackers[currentTracker] = blip
    else
        SetBlipCoords(activeTrackers[currentTracker], coords.x, coords.y, coords.z)
    end
end)

-- Function to remove tracker blip
RegisterNetEvent('sl-police:client:RemoveTrackerBlip', function(targetId)
    if activeTrackers[targetId] then
        RemoveBlip(activeTrackers[targetId])
        activeTrackers[targetId] = nil
    end
end)

-- Export functions
exports('PlaceTracker', placeTracker)
exports('RemoveTracker', removeTracker)
exports('IsTracking', function() return isTracking end)
exports('GetCurrentTracker', function() return currentTracker end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for _, blip in pairs(activeTrackers) do
            if DoesBlipExist(blip) then
                RemoveBlip(blip)
            end
        end
    end
end)
