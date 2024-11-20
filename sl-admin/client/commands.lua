local SLCore = exports['sl-core']:GetCoreObject()

-- Command Registrations
RegisterCommand('aduty', function()
    if not SLCore.Functions.HasPermission('admin') then return end
    -- Toggle admin duty
    TriggerServerEvent('sl-admin:server:ToggleAdminDuty')
end)

RegisterCommand('noclip', function()
    if not SLCore.Functions.HasPermission('admin') then return end
    -- Toggle noclip
    TriggerEvent('sl-admin:client:ToggleNoClip')
end)

RegisterCommand('tpm', function()
    if not SLCore.Functions.HasPermission('admin') then return end
    -- Teleport to waypoint
    TriggerEvent('sl-admin:client:TeleportToWaypoint')
end)

RegisterCommand('fix', function()
    if not SLCore.Functions.HasPermission('admin') then return end
    -- Fix vehicle
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        TriggerServerEvent('sl-admin:server:FixVehicle', VehToNet(vehicle))
    end
end)

RegisterCommand('car', function(source, args)
    if not SLCore.Functions.HasPermission('admin') then return end
    -- Spawn vehicle
    if args[1] then
        TriggerServerEvent('sl-admin:server:SpawnVehicle', args[1])
    end
end)

RegisterCommand('dv', function()
    if not SLCore.Functions.HasPermission('admin') then return end
    -- Delete vehicle
    TriggerEvent('sl-admin:client:DeleteVehicle')
end)

-- Command Events
RegisterNetEvent('sl-admin:client:DeleteVehicle', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        DeleteEntity(vehicle)
    else
        local coords = GetEntityCoords(PlayerPedId())
        local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
        if vehicle ~= 0 then
            DeleteEntity(vehicle)
        end
    end
end)

RegisterNetEvent('sl-admin:client:TeleportToWaypoint', function()
    local waypoint = GetFirstBlipInfoId(8)
    if DoesBlipExist(waypoint) then
        local coords = GetBlipInfoIdCoord(waypoint)
        local ped = PlayerPedId()
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Wait(0)
        end
        SetEntityCoords(ped, coords.x, coords.y, -50.0)
        local ground
        local groundFound = false
        for height = -50.0, 1000.0, 1.0 do
            RequestCollisionAtCoord(coords.x, coords.y, height)
            Wait(0)
            ground = GetGroundZFor_3dCoord(coords.x, coords.y, height, true)
            if ground then
                SetEntityCoords(ped, coords.x, coords.y, height)
                groundFound = true
                break
            end
        end
        if not groundFound then
            SetEntityCoords(ped, coords.x, coords.y, -50.0)
        end
        DoScreenFadeIn(500)
    end
end)
