local SLCore = exports['sl-core']:GetCoreObject()
local DamageComponents = {
    Engine = false,
    Body = false,
    Radiator = false,
    Clutch = false,
    Transmission = false,
    Brakes = false,
    Axle = false,
    Tank = false
}

-- Damage Functions
local function UpdateVehicleDamage(vehicle)
    local engineHealth = GetVehicleEngineHealth(vehicle)
    local bodyHealth = GetVehicleBodyHealth(vehicle)
    local tankHealth = GetVehiclePetrolTankHealth(vehicle)
    
    -- Engine Damage
    if engineHealth < Config.EngineDisablePercent then
        if not DamageComponents.Engine then
            DamageComponents.Engine = true
            SetVehicleEngineOn(vehicle, false, true, true)
            SLCore.Functions.Notify('Engine severely damaged!', 'error')
        end
    else
        DamageComponents.Engine = false
    end
    
    -- Body Damage
    if bodyHealth < 50.0 and not DamageComponents.Body then
        DamageComponents.Body = true
        SLCore.Functions.Notify('Vehicle body severely damaged!', 'error')
    elseif bodyHealth >= 50.0 then
        DamageComponents.Body = false
    end
    
    -- Tank Damage
    if tankHealth < 50.0 and not DamageComponents.Tank then
        DamageComponents.Tank = true
        SLCore.Functions.Notify('Fuel tank damaged, leaking fuel!', 'error')
    elseif tankHealth >= 50.0 then
        DamageComponents.Tank = false
    end
end

-- Damage Loop
CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            if GetPedInVehicleSeat(vehicle, -1) == ped then
                UpdateVehicleDamage(vehicle)
            end
        end
    end
end)

-- Vehicle Repair
local function RepairVehicle(vehicle)
    local ped = PlayerPedId()
    
    if Config.UseRepairAnimations then
        TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)
        SLCore.Functions.Progressbar("repair_vehicle", "Repairing Vehicle...", 10000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            ClearPedTasksImmediately(ped)
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            SetVehicleUndriveable(vehicle, false)
            SLCore.Functions.Notify("Vehicle repaired!", "success")
        end)
    else
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SLCore.Functions.Notify("Vehicle repaired!", "success")
    end
end

-- Events
RegisterNetEvent('sl-vehicles:client:RepairVehicle', function()
    local vehicle = GetClosestVehicle()
    if vehicle and #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) < 5.0 then
        RepairVehicle(vehicle)
    end
end)

-- Exports
exports('RepairVehicle', RepairVehicle)
exports('GetVehicleDamage', function(vehicle)
    return {
        engine = GetVehicleEngineHealth(vehicle),
        body = GetVehicleBodyHealth(vehicle),
        tank = GetVehiclePetrolTankHealth(vehicle)
    }
end) 