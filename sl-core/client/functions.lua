-- Utility Functions
function SLCore.Functions.GetClosestPlayer(coords)
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = coords or GetEntityCoords(PlayerPedId())

    for i = 1, #players do
        local target = GetPlayerPed(players[i])
        if target ~= PlayerPedId() then
            local targetCoords = GetEntityCoords(target)
            local distance = #(targetCoords - coords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = players[i]
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

function SLCore.Functions.GetVehicleProperties(vehicle)
    local properties = {
        model = GetEntityModel(vehicle),
        plate = GetVehicleNumberPlateText(vehicle),
        plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
        bodyHealth = GetVehicleBodyHealth(vehicle),
        engineHealth = GetVehicleEngineHealth(vehicle),
        tankHealth = GetVehiclePetrolTankHealth(vehicle),
        fuelLevel = GetVehicleFuelLevel(vehicle),
        dirtLevel = GetVehicleDirtLevel(vehicle),
        color1 = GetVehicleCustomPrimaryColour(vehicle),
        color2 = GetVehicleCustomSecondaryColour(vehicle),
        pearlescentColor = GetVehiclePearlescentColour(vehicle),
        wheelColor = GetVehicleExtraColours(vehicle),
        wheels = GetVehicleWheelType(vehicle),
        windowTint = GetVehicleWindowTint(vehicle),
        xenonColor = GetVehicleXenonLightsColour(vehicle),
        neonEnabled = {
            IsVehicleNeonLightEnabled(vehicle, 0),
            IsVehicleNeonLightEnabled(vehicle, 1),
            IsVehicleNeonLightEnabled(vehicle, 2),
            IsVehicleNeonLightEnabled(vehicle, 3)
        },
        extras = {},
        neonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),
        tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicle)),
        modSpoilers = GetVehicleMod(vehicle, 0),
        modFrontBumper = GetVehicleMod(vehicle, 1),
        modRearBumper = GetVehicleMod(vehicle, 2),
        modSideSkirt = GetVehicleMod(vehicle, 3),
        modExhaust = GetVehicleMod(vehicle, 4),
        modFrame = GetVehicleMod(vehicle, 5),
        modGrille = GetVehicleMod(vehicle, 6),
        modHood = GetVehicleMod(vehicle, 7),
        modFender = GetVehicleMod(vehicle, 8),
        modRightFender = GetVehicleMod(vehicle, 9),
        modRoof = GetVehicleMod(vehicle, 10),
        modEngine = GetVehicleMod(vehicle, 11),
        modBrakes = GetVehicleMod(vehicle, 12),
        modTransmission = GetVehicleMod(vehicle, 13),
        modHorns = GetVehicleMod(vehicle, 14),
        modSuspension = GetVehicleMod(vehicle, 15),
        modArmor = GetVehicleMod(vehicle, 16),
        modTurbo = IsToggleModOn(vehicle, 18),
        modSmokeEnabled = IsToggleModOn(vehicle, 20),
        modXenon = IsToggleModOn(vehicle, 22),
        modFrontWheels = GetVehicleMod(vehicle, 23),
        modBackWheels = GetVehicleMod(vehicle, 24),
        modCustomTiresF = GetVehicleModVariation(vehicle, 23),
        modCustomTiresR = GetVehicleModVariation(vehicle, 24)
    }
    return properties
end

function SLCore.Functions.SetVehicleProperties(vehicle, props)
    SetVehicleModKit(vehicle, 0)
    SetVehicleCustomPrimaryColour(vehicle, props.color1[1], props.color1[2], props.color1[3])
    SetVehicleCustomSecondaryColour(vehicle, props.color2[1], props.color2[2], props.color2[3])
    SetVehiclePearlescentColour(vehicle, props.pearlescentColor)
    SetVehicleWheelType(vehicle, props.wheels)
    SetVehicleWindowTint(vehicle, props.windowTint)
    SetVehicleXenonLightsColour(vehicle, props.xenonColor)
    
    for i = 0, 3 do
        SetVehicleNeonLightEnabled(vehicle, i, props.neonEnabled[i + 1])
    end
    
    SetVehicleNeonLightsColour(vehicle, table.unpack(props.neonColor))
    SetVehicleTyreSmokeColor(vehicle, table.unpack(props.tyreSmokeColor))
    SetVehicleModKit(vehicle, 0)
    
    for i = 0, 16 do
        SetVehicleMod(vehicle, i, props["mod" .. i])
    end
    
    SetVehicleMod(vehicle, 23, props.modFrontWheels, props.modCustomTiresF)
    SetVehicleMod(vehicle, 24, props.modBackWheels, props.modCustomTiresR)
end 