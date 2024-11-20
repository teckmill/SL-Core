local SLCore = nil
local CoreReady = false
local damageTimer = 0
local lastVehicle = nil
local vehicleDamage = {}

-- Wait for core to be ready
CreateThread(function()
    while SLCore == nil do
        if GetResourceState('sl-core') == 'started' then
            SLCore = exports['sl-core']:GetCoreObject()
            if SLCore then
                CoreReady = true
                print('^2[SL-Vehicle] ^7Successfully connected to SL-Core')
                break
            end
        end
        Wait(100)
    end
end)

-- Functions
local function GetVehicleStatus(vehicle)
    local status = {
        engine = math.floor(GetVehicleEngineHealth(vehicle)),
        body = math.floor(GetVehicleBodyHealth(vehicle)),
        tank = math.floor(GetVehiclePetrolTankHealth(vehicle)),
        fuel = math.floor(GetVehicleFuelLevel(vehicle))
    }
    return status
end

local function ApplyVehicleDamage(vehicle, damage)
    if not damage then return end
    
    SetVehicleEngineHealth(vehicle, damage.engine + 0.0)
    SetVehicleBodyHealth(vehicle, damage.body + 0.0)
    SetVehiclePetrolTankHealth(vehicle, damage.tank + 0.0)
    SetVehicleFuelLevel(vehicle, damage.fuel + 0.0)
end

-- Threads
CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        
        if IsPedInAnyVehicle(ped, false) then
            sleep = 100
            local vehicle = GetVehiclePedIsIn(ped, false)
            local plate = GetVehicleNumberPlateText(vehicle)
            
            if vehicle ~= lastVehicle then
                lastVehicle = vehicle
                SLCore.Functions.TriggerCallback('sl-vehicle:server:GetVehicleByPlate', function(result)
                    if result and result.damage then
                        vehicleDamage[plate] = json.decode(result.damage)
                        ApplyVehicleDamage(vehicle, vehicleDamage[plate])
                    end
                end, plate)
            end
            
            -- Save damage every 10 seconds
            if (GetGameTimer() - damageTimer) > 10000 then
                damageTimer = GetGameTimer()
                local status = GetVehicleStatus(vehicle)
                vehicleDamage[plate] = status
                
                TriggerServerEvent('sl-vehicle:server:UpdateVehicle', plate, {
                    damage = json.encode(status)
                })
            end
        else
            lastVehicle = nil
        end
        
        Wait(sleep)
    end
end)

-- Engine Management
CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        
        if IsPedInAnyVehicle(ped, false) then
            sleep = 100
            local vehicle = GetVehiclePedIsIn(ped, false)
            local engineHealth = GetVehicleEngineHealth(vehicle)
            
            -- Engine dies under 400 health
            if engineHealth < 400.0 then
                if GetIsVehicleEngineRunning(vehicle) then
                    SetVehicleEngineOn(vehicle, false, true, true)
                end
            end
            
            -- Engine smoking under 300 health
            if engineHealth < 300.0 then
                SetVehicleEngineHealth(vehicle, 300.0)
                if not IsVehicleExtraTurnedOn(vehicle, 1) then
                    SetVehicleExtra(vehicle, 1, false) -- Enable engine smoke
                end
            else
                if IsVehicleExtraTurnedOn(vehicle, 1) then
                    SetVehicleExtra(vehicle, 1, true) -- Disable engine smoke
                end
            end
        end
        
        Wait(sleep)
    end
end)

-- Damage Events
RegisterNetEvent('sl-vehicle:client:SetVehicleStatus', function(plate, status)
    vehicleDamage[plate] = status
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if GetVehicleNumberPlateText(vehicle) == plate then
        ApplyVehicleDamage(vehicle, status)
    end
end)

-- Exports
exports('GetVehicleStatus', GetVehicleStatus)
exports('ApplyVehicleDamage', ApplyVehicleDamage)
