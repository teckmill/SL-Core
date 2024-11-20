local SLCore = exports['sl-core']:GetCoreObject()
local fuelSynced = false
local inBlacklisted = false
local inGasStation = false

-- Fuel Functions
local function GetFuel(vehicle)
    return DecorGetFloat(vehicle, Config.FuelDecor)
end

local function SetFuel(vehicle, fuel)
    if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
        SetVehicleFuelLevel(vehicle, fuel + 0.0)
        DecorSetFloat(vehicle, Config.FuelDecor, GetVehicleFuelLevel(vehicle))
    end
end

local function LoadFuelDecor()
    if not DecorIsRegisteredAsType(Config.FuelDecor, 1) then
        DecorRegister(Config.FuelDecor, 1)
    end
end

-- Main Fuel Loop
CreateThread(function()
    LoadFuelDecor()
    
    while true do
        Wait(1000)
        
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            
            if GetPedInVehicleSeat(vehicle, -1) == ped then
                local fuel = GetFuel(vehicle)
                local engineHealth = GetVehicleEngineHealth(vehicle)
                local usage = Config.FuelUsage[math.floor(engineHealth / 100) * 10 / 10]
                
                if usage and GetIsVehicleEngineRunning(vehicle) then
                    local newFuel = fuel - usage
                    if newFuel > 0 then
                        SetFuel(vehicle, newFuel)
                    else
                        SetFuel(vehicle, 0)
                        SetVehicleEngineOn(vehicle, false, true, true)
                    end
                end
            end
        end
    end
end)

-- Refuel Vehicle
local function RefuelVehicle(vehicle, amount)
    local fuel = GetFuel(vehicle)
    local newFuel = math.min(100, fuel + amount)
    SetFuel(vehicle, newFuel)
    return newFuel - fuel
end

-- Events
RegisterNetEvent('sl-vehicles:client:RefuelVehicle', function(amount)
    local vehicle = GetClosestVehicle()
    if vehicle and #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) < 2.5 then
        local refueled = RefuelVehicle(vehicle, amount)
        if refueled > 0 then
            TriggerServerEvent('sl-vehicles:server:PayForFuel', refueled)
        end
    end
end)

-- Exports
exports('GetFuel', GetFuel)
exports('SetFuel', SetFuel)
exports('RefuelVehicle', RefuelVehicle) 