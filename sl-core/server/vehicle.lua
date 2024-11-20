-- Vehicle Management Functions
function SLCore.Functions.SpawnVehicle(source, model, coords, warp)
    local ped = GetPlayerPed(source)
    model = type(model) == 'string' and GetHashKey(model) or model
    
    if not coords then
        coords = GetEntityCoords(ped)
    end
    
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, true)
    while not DoesEntityExist(veh) do Wait(0) end
    
    if warp then
        SetPedIntoVehicle(ped, veh, -1)
    end
    
    return veh
end

function SLCore.Functions.CreateVehicle(source, vehicle, coords)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end

    local plate = GeneratePlate()
    local vehicleData = {
        citizenid = Player.PlayerData.citizenid,
        plate = plate,
        model = vehicle,
        mods = '{}',
        status = '{"engine":1000.0,"body":1000.0,"fuel":100.0}',
    }

    MySQL.insert('INSERT INTO player_vehicles (citizenid, plate, model, mods, status) VALUES (?, ?, ?, ?, ?)',
        {vehicleData.citizenid, vehicleData.plate, vehicleData.model, vehicleData.mods, vehicleData.status},
        function(id)
            if id then
                local veh = SLCore.Functions.SpawnVehicle(source, vehicle, coords, true)
                SetVehicleNumberPlateText(veh, plate)
                TriggerClientEvent('sl-core:client:vehicleCreated', source, NetworkGetNetworkIdFromEntity(veh))
                return true
            end
            return false
        end
    )
end

function SLCore.Functions.GetVehicleProperties(vehicle)
    if not DoesEntityExist(vehicle) then return end
    
    local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
    local extras = {}
    
    for extraId = 0, 20 do
        if DoesExtraExist(vehicle, extraId) then
            extras[tostring(extraId)] = IsVehicleExtraTurnedOn(vehicle, extraId)
        end
    end
    
    return {
        model = GetEntityModel(vehicle),
        plate = GetVehicleNumberPlateText(vehicle),
        plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
        bodyHealth = GetVehicleBodyHealth(vehicle),
        engineHealth = GetVehicleEngineHealth(vehicle),
        tankHealth = GetVehiclePetrolTankHealth(vehicle),
        fuelLevel = GetVehicleFuelLevel(vehicle),
        dirtLevel = GetVehicleDirtLevel(vehicle),
        color1 = colorPrimary,
        color2 = colorSecondary,
        pearlescentColor = pearlescentColor,
        wheelColor = wheelColor,
        wheels = GetVehicleWheelType(vehicle),
        windowTint = GetVehicleWindowTint(vehicle),
        neonEnabled = {
            IsVehicleNeonLightEnabled(vehicle, 0),
            IsVehicleNeonLightEnabled(vehicle, 1),
            IsVehicleNeonLightEnabled(vehicle, 2),
            IsVehicleNeonLightEnabled(vehicle, 3),
        },
        extras = extras,
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
    }
end

function SLCore.Functions.SetVehicleProperties(vehicle, props)
    if not DoesEntityExist(vehicle) then return end
    
    SetVehicleModKit(vehicle, 0)
    SetVehicleAutoRepairDisabled(vehicle, false)
    
    if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
    if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
    if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
    if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
    if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end
    if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
    if props.color1 then SetVehicleColours(vehicle, props.color1, props.color2) end
    if props.pearlescentColor then SetVehicleExtraColours(vehicle, props.pearlescentColor, props.wheelColor) end
    if props.wheels then SetVehicleWheelType(vehicle, props.wheels) end
    if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end
    
    if props.neonEnabled then
        SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
        SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
        SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
        SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
    end
    
    if props.extras then
        for id, enabled in pairs(props.extras) do
            SetVehicleExtra(vehicle, tonumber(id), enabled and 0 or 1)
        end
    end
    
    if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
    if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, true) end
    if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
    if props.modSpoilers then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
    if props.modFrontBumper then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
    if props.modRearBumper then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
    if props.modSideSkirt then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
    if props.modExhaust then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
    if props.modFrame then SetVehicleMod(vehicle, 5, props.modFrame, false) end
    if props.modGrille then SetVehicleMod(vehicle, 6, props.modGrille, false) end
    if props.modHood then SetVehicleMod(vehicle, 7, props.modHood, false) end
    if props.modFender then SetVehicleMod(vehicle, 8, props.modFender, false) end
    if props.modRightFender then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
    if props.modRoof then SetVehicleMod(vehicle, 10, props.modRoof, false) end
    if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
    if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
    if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
    if props.modHorns then SetVehicleMod(vehicle, 14, props.modHorns, false) end
    if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
    if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
    if props.modTurbo then ToggleVehicleMod(vehicle, 18, props.modTurbo) end
    if props.modXenon then ToggleVehicleMod(vehicle, 22, props.modXenon) end
    if props.modFrontWheels then SetVehicleMod(vehicle, 23, props.modFrontWheels, false) end
    if props.modBackWheels then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
end

-- Helper Functions
function GeneratePlate()
    local plate = string.upper(GetRandomLetter() .. GetRandomLetter() .. GetRandomNumber() .. GetRandomNumber() .. GetRandomLetter() .. GetRandomLetter())
    MySQL.scalar('SELECT plate FROM player_vehicles WHERE plate = ?', {plate}, function(result)
        while result do
            plate = string.upper(GetRandomLetter() .. GetRandomLetter() .. GetRandomNumber() .. GetRandomNumber() .. GetRandomLetter() .. GetRandomLetter())
            result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
        end
    end)
    return plate
end

function GetRandomLetter()
    return string.char(math.random(65, 90))
end

function GetRandomNumber()
    return math.random(0, 9)
end
