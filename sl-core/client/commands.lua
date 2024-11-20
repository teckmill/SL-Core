local SLCore = exports['sl-core']:GetCoreObject()

-- Basic Commands
RegisterCommand('tpm', function()
    local WaypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords.x, waypointCoords.y, height + 0.0)
            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, height + 0.0)
            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords.x, waypointCoords.y, height + 0.0)
                break
            end
            Wait(5)
        end
    end
end)

RegisterCommand('car', function(source, args)
    if not args[1] then return end
    if not IsModelValid(args[1]) then return end
    
    RequestModel(args[1])
    while not HasModelLoaded(args[1]) do Wait(0) end
    
    local vehicle = CreateVehicle(args[1], GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), true, false)
    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetEntityAsNoLongerNeeded(vehicle)
    SetModelAsNoLongerNeeded(args[1])
end)

RegisterCommand('dv', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped)
    if vehicle ~= 0 then
        DeleteEntity(vehicle)
    else
        local coords = GetEntityCoords(ped)
        local closestVehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
        if closestVehicle ~= 0 then
            DeleteEntity(closestVehicle)
        end
    end
end)

RegisterCommand('fix', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped)
    if vehicle ~= 0 then
        SetVehicleFixed(vehicle)
        SetVehicleDirtLevel(vehicle, 0.0)
        SetVehicleEngineHealth(vehicle, 1000.0)
    end
end)

RegisterCommand('heal', function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, 200)
    ClearPedBloodDamage(ped)
end)

RegisterCommand('armor', function()
    local ped = PlayerPedId()
    SetPedArmour(ped, 100)
end)

-- Admin Commands
RegisterCommand('noclip', function()
    if not SLCore.Functions.IsAdmin() then return end
    TriggerServerEvent('sl-core:server:ToggleNoclip')
end)

RegisterCommand('coords', function()
    if not SLCore.Functions.IsAdmin() then return end
    local coords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    print('Coords: vector4('..coords.x..', '..coords.y..', '..coords.z..', '..heading..')')
end)
