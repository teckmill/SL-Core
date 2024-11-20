local SLCore = exports['sl-core']:GetCoreObject()
local SpawnedVehicles = {}

-- Utility Functions
local function GetVehicleSpawnPoint(coords)
    local found = false
    local spawnPos = coords
    local heading = 0
    
    for i = 1, 100 do
        local offsetX = math.random(-20, 20)
        local offsetY = math.random(-20, 20)
        local testPos = vector3(coords.x + offsetX, coords.y + offsetY, coords.z)
        local outHeading = 0.0
        
        local result, nodePos, heading = GetClosestVehicleNodeWithHeading(testPos.x, testPos.y, testPos.z, outHeading, 3, 0, 0)
        if result then
            local clear = IsSpawnPointClear(nodePos, 3.0)
            if clear then
                spawnPos = nodePos
                heading = heading
                found = true
                break
            end
        end
    end
    
    return found, spawnPos, heading
end

-- Spawn Vehicle
function SpawnVehicle(model, coords, plate, props)
    local hash = GetHashKey(model)
    
    -- Request model
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
    
    -- Find spawn point
    local found, spawnPos, heading = GetVehicleSpawnPoint(coords)
    if not found then
        SLCore.Functions.Notify("No suitable spawn location found", "error")
        return nil
    end
    
    -- Create vehicle
    local vehicle = CreateVehicle(hash, spawnPos.x, spawnPos.y, spawnPos.z, heading, true, false)
    if not DoesEntityExist(vehicle) then return nil end
    
    -- Set properties
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleNumberPlateText(vehicle, plate)
    
    if props then
        SLCore.Functions.SetVehicleProperties(vehicle, props)
    end
    
    -- Initial setup
    SetVehicleEngineHealth(vehicle, props and props.health.engine or 1000.0)
    SetVehicleBodyHealth(vehicle, props and props.health.body or 1000.0)
    SetVehiclePetrolTankHealth(vehicle, props and props.health.tank or 1000.0)
    SetVehicleFuelLevel(vehicle, props and props.fuel or 100.0)
    
    -- Track spawned vehicle
    SpawnedVehicles[plate] = vehicle
    
    SetModelAsNoLongerNeeded(hash)
    return vehicle
end

-- Despawn Vehicle
function DespawnVehicle(vehicle)
    if not DoesEntityExist(vehicle) then return false end
    
    -- Save vehicle state before despawning
    local plate = GetVehicleNumberPlateText(vehicle)
    local props = SLCore.Functions.GetVehicleProperties(vehicle)
    
    -- Trigger save event
    TriggerServerEvent('sl-vehicles:server:SaveVehicle', plate, props)
    
    -- Delete vehicle
    DeleteEntity(vehicle)
    SpawnedVehicles[plate] = nil
    
    return true
end

-- Events
RegisterNetEvent('sl-vehicles:client:SpawnVehicle', function(data)
    local vehicle = SpawnVehicle(data.model, data.coords, data.plate, data.props)
    if vehicle then
        SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
        SLCore.Functions.Notify("Vehicle spawned!", "success")
    end
end)

RegisterNetEvent('sl-vehicles:client:DespawnVehicle', function(plate)
    if SpawnedVehicles[plate] then
        DespawnVehicle(SpawnedVehicles[plate])
        SLCore.Functions.Notify("Vehicle stored!", "success")
    end
end)

-- Exports
exports('SpawnVehicle', SpawnVehicle)
exports('DespawnVehicle', DespawnVehicle)
exports('GetSpawnedVehicles', function() return SpawnedVehicles end) 