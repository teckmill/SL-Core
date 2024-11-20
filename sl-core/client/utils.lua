local QBCore = exports['qb-core']:GetCoreObject()
local Utils = {}

-- Notification wrapper function
function Utils.Notify(msg, type, time)
    if GetResourceState('qb-core') == 'started' then
        QBCore.Functions.Notify(msg, type or 'primary', time or 5000)
    end
end

-- Draw 3D text in world
function Utils.DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- Check if player is in vehicle
function Utils.IsInVehicle()
    return IsPedInAnyVehicle(PlayerPedId(), false)
end

-- Get closest vehicle
function Utils.GetClosestVehicle(coords)
    local vehicles = GetGamePool('CVehicle')
    local closestDistance = -1
    local closestVehicle = -1
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(PlayerPedId())
    end
    for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(coords - vehicleCoords)
        if closestDistance == -1 or closestDistance > distance then
            closestVehicle = vehicles[i]
            closestDistance = distance
        end
    end
    return closestVehicle, closestDistance
end

-- Get closest player
function Utils.GetClosestPlayer()
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(PlayerPedId())
    for i = 1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = #(coords - pos)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

-- Request animation dictionary
function Utils.RequestAnimDict(animDict)
    if HasAnimDictLoaded(animDict) then return end
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(10)
    end
end

-- Request model
function Utils.RequestModel(model)
    if HasModelLoaded(model) then return end
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
end

-- Create a blip on the map
function Utils.CreateBlip(coords, sprite, color, text, scale, display)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, display or 4)
    SetBlipScale(blip, scale or 0.8)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    return blip
end

-- Progress bar wrapper
function Utils.ProgressBar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    if GetResourceState('progressbar') ~= 'started' then return end
    exports['progressbar']:Progress({
        name = name:lower(),
        duration = duration,
        label = label,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        controlDisables = disableControls,
        animation = animation,
        prop = prop,
        propTwo = propTwo,
    }, function(cancelled)
        if cancelled then
            if onCancel then
                onCancel()
            end
        else
            if onFinish then
                onFinish()
            end
        end
    end)
end

return Utils
