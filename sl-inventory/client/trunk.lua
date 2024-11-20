local SLCore = exports['sl-core']:GetCoreObject()
local inTrunk = false
local currentVehicle = nil

-- Function to get vehicle in front of player
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

-- Open trunk inventory
function OpenTrunkInventory()
    local vehicle = GetVehicleInDirection()
    if not vehicle then return end
    
    local plate = GetVehicleNumberPlateText(vehicle)
    local vehClass = GetVehicleClass(vehicle)
    
    if vehClass == 18 then return end
    
    if GetVehicleDoorLockStatus(vehicle) < 2 then
        local trunk = GetEntityBoneIndexByName(vehicle, "boot")
        if trunk ~= -1 then
            local coords = GetWorldPositionOfEntityBone(vehicle, trunk)
            local playerPed = PlayerPedId()
            local pos = GetEntityCoords(playerPed)
            if #(pos - coords) < 2.0 and not IsPedInAnyVehicle(playerPed) then
                if GetVehicleDoorAngleRatio(vehicle, 5) < 0.9 then
                    SetVehicleDoorOpen(vehicle, 5, false, false)
                end
                OpenInventory("trunk", plate)
                currentVehicle = vehicle
                inTrunk = true
            end
        end
    else
        SLCore.Functions.Notify("Vehicle is locked", "error")
    end
end

-- Close trunk
RegisterNetEvent('sl-inventory:client:CloseTrunk')
AddEventHandler('sl-inventory:client:CloseTrunk', function()
    inTrunk = false
    if currentVehicle then
        SetVehicleDoorShut(currentVehicle, 5, false)
        currentVehicle = nil
    end
end)

-- Key binding for trunk
RegisterCommand('+openTrunk', function()
    if not LocalPlayer.state.isLoggedIn then return end
    OpenTrunkInventory()
end)

RegisterKeyMapping('+openTrunk', 'Open Trunk', 'keyboard', 'L')
