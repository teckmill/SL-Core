local SLCore = nil
local CoreReady = false

-- Wait for core to be ready
CreateThread(function()
    while SLCore == nil do
        SLCore = exports['sl-core']:GetCoreObject()
        if not SLCore then 
            Wait(100)
        end
    end
    CoreReady = true
end)

-- Local Variables
local isNearPump = false
local isFueling = false
local currentFuel = 0.0
local currentCost = 0.0
local currentPump = 0
local fuelSynced = false
local inBlacklisted = false

-- Functions
local function GetFuel(vehicle)
    return DecorGetFloat(vehicle, Config.FuelDecor)
end

local function SetFuel(vehicle, fuel)
    if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
        SetVehicleFuelLevel(vehicle, fuel + 0.0)
        DecorSetFloat(vehicle, Config.FuelDecor, GetVehicleFuelLevel(vehicle))
    end
end

local function LoadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(100)
    end
end

local function ManageFuelUsage(vehicle)
    if not DecorExistOn(vehicle, Config.FuelDecor) then
        SetFuel(vehicle, math.random(200, 800) / 10)
    elseif not fuelSynced then
        SetFuel(vehicle, GetFuel(vehicle))
        fuelSynced = true
    end

    if IsVehicleEngineOn(vehicle) then
        SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - Config.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] * (Config.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
    end
end

-- Main Thread
CreateThread(function()
    DecorRegister(Config.FuelDecor, 1)

    while true do
        Wait(1000)

        local ped = PlayerPedId()
        
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)

            if GetPedInVehicleSeat(vehicle, -1) == ped then
                ManageFuelUsage(vehicle)
            end
        end
    end
end)

-- Events
RegisterNetEvent('sl-fuel:client:RefuelVehicle', function(amount)
    if isFueling then return end
    
    local vehicle = GetClosestVehicle()
    local ped = PlayerPedId()
    
    if DoesEntityExist(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehicle)) < 3.0 then
        if not Config.ElectricVehicles[GetEntityModel(vehicle)] then
            local curFuel = GetFuel(vehicle)
            local newFuel = math.min(curFuel + amount, 100.0)
            
            SetFuel(vehicle, newFuel)
            SLCore.Functions.Notify('Vehicle refueled', 'success')
        else
            SLCore.Functions.Notify('This is an electric vehicle', 'error')
        end
    end
end)

-- Exports
exports('GetFuel', GetFuel)
exports('SetFuel', SetFuel)
