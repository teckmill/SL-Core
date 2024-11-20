local SLCore = exports['sl-core']:GetCoreObject()
local jobVehicles = {}
local currentGarage = nil

-- Job Vehicle Configuration
local JobVehicles = {
    police = {
        {model = 'police', label = 'Police Cruiser', price = 0},
        {model = 'police2', label = 'Police SUV', price = 0},
        {model = 'police3', label = 'Police Van', price = 0}
    },
    ambulance = {
        {model = 'ambulance', label = 'Ambulance', price = 0},
        {model = 'emsnspeedo', label = 'EMS Speedo', price = 0}
    },
    mechanic = {
        {model = 'towtruck', label = 'Tow Truck', price = 0},
        {model = 'flatbed', label = 'Flatbed', price = 0}
    }
}

-- Garage Locations
local GarageLocations = {
    police = {
        main = vector3(442.09, -1014.52, 28.63),
        spawn = vector4(438.42, -1018.30, 27.75, 90.0)
    },
    ambulance = {
        main = vector3(297.94, -579.79, 43.26),
        spawn = vector4(294.02, -574.13, 43.18, 70.0)
    },
    mechanic = {
        main = vector3(-359.59, -133.44, 38.68),
        spawn = vector4(-363.23, -128.19, 38.68, 160.0)
    }
}

-- Functions
function OpenJobGarage(job)
    if not JobVehicles[job] then return end
    
    local elements = {}
    for _, vehicle in ipairs(JobVehicles[job]) do
        table.insert(elements, {
            title = vehicle.label,
            description = 'Take out ' .. vehicle.label,
            event = 'sl-jobs:client:SpawnJobVehicle',
            args = {
                model = vehicle.model,
                price = vehicle.price
            }
        })
    end
    
    exports['sl-menu']:openMenu(elements)
end

function SpawnJobVehicle(data)
    if not currentGarage then return end
    
    local model = data.model
    local coords = GarageLocations[currentGarage].spawn
    
    SLCore.Functions.SpawnVehicle(model, function(vehicle)
        SetEntityHeading(vehicle, coords.w)
        exports['sl-fuel']:SetFuel(vehicle, 100.0)
        TriggerEvent('vehiclekeys:client:SetOwner', GetVehicleNumberPlateText(vehicle))
        SetVehicleEngineOn(vehicle, true, true)
    end, coords, true)
end

function StoreJobVehicle()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle == 0 then
        SLCore.Functions.Notify('You must be in a vehicle!', 'error')
        return
    end
    
    local plate = GetVehicleNumberPlateText(vehicle)
    DeleteVehicle(vehicle)
    SLCore.Functions.Notify('Vehicle stored!', 'success')
end

-- Events
RegisterNetEvent('sl-jobs:client:OpenGarage')
AddEventHandler('sl-jobs:client:OpenGarage', function(job)
    currentGarage = job
    OpenJobGarage(job)
end)

RegisterNetEvent('sl-jobs:client:SpawnJobVehicle')
AddEventHandler('sl-jobs:client:SpawnJobVehicle', function(data)
    SpawnJobVehicle(data)
end)

RegisterNetEvent('sl-jobs:client:StoreVehicle')
AddEventHandler('sl-jobs:client:StoreVehicle', function()
    StoreJobVehicle()
end)

-- Threads
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local player = SLCore.Functions.GetPlayerData()
        
        if player.job then
            local jobGarage = GarageLocations[player.job.name]
            if jobGarage then
                local distance = #(coords - jobGarage.main)
                
                if distance < 10.0 then
                    DrawMarker(2, jobGarage.main.x, jobGarage.main.y, jobGarage.main.z, 
                        0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
                        0.3, 0.2, 0.15, 200, 0, 0, 222, 
                        false, false, false, true, false, false, false)
                        
                    if distance < 1.5 then
                        if IsPedInAnyVehicle(ped, false) then
                            SLCore.Functions.DrawText3D(jobGarage.main.x, jobGarage.main.y, jobGarage.main.z + 0.2, 
                                '[E] Store Vehicle')
                                
                            if IsControlJustReleased(0, 38) then -- E key
                                StoreJobVehicle()
                            end
                        else
                            SLCore.Functions.DrawText3D(jobGarage.main.x, jobGarage.main.y, jobGarage.main.z + 0.2, 
                                '[E] Open Garage')
                                
                            if IsControlJustReleased(0, 38) then -- E key
                                TriggerEvent('sl-jobs:client:OpenGarage', player.job.name)
                            end
                        end
                    end
                end
            end
        end
    end
end)
