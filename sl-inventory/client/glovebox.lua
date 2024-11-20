local SLCore = exports['sl-core']:GetCoreObject()
local inGlovebox = false
local currentVehicle = nil

-- Function to get vehicle player is looking at
local function GetVehicleInDirection()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local inDirection = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
    local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(playerCoords.x, playerCoords.y, playerCoords.z, inDirection.x, inDirection.y, inDirection.z, 10, playerPed, 0)
    local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    if hit == 1 and GetEntityType(entityHit) == 2 then
        return entityHit
    end

    return nil
end

-- Open glovebox inventory
function OpenGloveboxInventory()
    local vehicle = nil
    if IsPedInAnyVehicle(PlayerPedId()) then
        vehicle = GetVehiclePedIsIn(PlayerPedId())
    else
        vehicle = GetVehicleInDirection()
        if not vehicle then return end
    end
    
    local plate = GetVehicleNumberPlateText(vehicle)
    local vehClass = GetVehicleClass(vehicle)
    
    if vehClass == 18 then return end
    
    if GetVehicleDoorLockStatus(vehicle) < 2 then
        local glovebox = GetEntityBoneIndexByName(vehicle, "glove")
        if glovebox ~= -1 then
            local coords = GetWorldPositionOfEntityBone(vehicle, glovebox)
            local playerPed = PlayerPedId()
            local pos = GetEntityCoords(playerPed)
            if #(pos - coords) < 2.0 or IsPedInAnyVehicle(playerPed) then
                OpenInventory("glovebox", plate)
                currentVehicle = vehicle
                inGlovebox = true
            end
        end
    else
        SLCore.Functions.Notify("Vehicle is locked", "error")
    end
end

-- Close glovebox
RegisterNetEvent('sl-inventory:client:CloseGlovebox')
AddEventHandler('sl-inventory:client:CloseGlovebox', function()
    inGlovebox = false
    currentVehicle = nil
end)

-- Key binding for glovebox
RegisterCommand('+openGlovebox', function()
    if not LocalPlayer.state.isLoggedIn then return end
    OpenGloveboxInventory()
end)

RegisterKeyMapping('+openGlovebox', 'Open Glovebox', 'keyboard', 'K')
