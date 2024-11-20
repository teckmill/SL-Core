local SLCore = nil
local CoreReady = false

-- Initialize core
CreateThread(function()
    while SLCore == nil do
        if GetResourceState('sl-core') == 'started' then
            SLCore = exports['sl-core']:GetCoreObject()
            if SLCore then
                CoreReady = true
                break
            end
        end
        Wait(100)
    end
end)

-- Dealership Configuration
local Config = {
    Locations = {
        {
            name = "Premium Deluxe Motorsport",
            coords = vector3(-33.7, -1102.0, 26.4),
            blipSprite = 326,
            blipColor = 3
        }
    },
    TestDriveArea = {
        start = vector3(-11.87, -1080.87, 26.67),
        radius = 100.0
    }
}

-- Local Variables
local isInDealership = false
local selectedVehicle = nil
local testDriveActive = false
local displayVehicle = nil

-- Functions
local function SetupDealershipBlips()
    for _, location in pairs(Config.Locations) do
        local blip = AddBlipForCoord(location.coords)
        SetBlipSprite(blip, location.blipSprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, location.blipColor)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(location.name)
        EndTextCommandSetBlipName(blip)
    end
end

local function SpawnDisplayVehicle(model, coords)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, false, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleDoorsLocked(vehicle, 2)
    SetVehicleEngineOn(vehicle, false, false, true)
    FreezeEntityPosition(vehicle, true)
    SetVehicleDirtLevel(vehicle, 0.0)
    
    return vehicle
end

local function OpenDealershipMenu()
    if not CoreReady then return end
    
    local menu = {
        {
            header = "Premium Deluxe Motorsport",
            isMenuHeader = true
        }
    }
    
    -- Get vehicle categories
    SLCore.Functions.TriggerCallback('sl-dealership:server:GetCategories', function(categories)
        for _, category in pairs(categories) do
            menu[#menu + 1] = {
                header = category.label,
                params = {
                    event = "sl-dealership:client:ShowVehicles",
                    args = {
                        category = category.name
                    }
                }
            }
        end
        
        menu[#menu + 1] = {
            header = "Close Menu",
            params = {
                event = "sl-menu:client:closeMenu"
            }
        }
        
        exports['sl-menu']:openMenu(menu)
    end)
end

-- Events
RegisterNetEvent('sl-dealership:client:ShowVehicles', function(data)
    if not CoreReady then return end
    
    SLCore.Functions.TriggerCallback('sl-dealership:server:GetVehicles', function(vehicles)
        local menu = {
            {
                header = "← Go Back",
                params = {
                    event = "sl-dealership:client:OpenMenu"
                }
            }
        }
        
        for _, vehicle in pairs(vehicles) do
            if vehicle.category == data.category then
                menu[#menu + 1] = {
                    header = vehicle.name,
                    txt = "Price: $" .. SLCore.Functions.FormatNumber(vehicle.price),
                    params = {
                        event = "sl-dealership:client:ShowVehicleInfo",
                        args = {
                            vehicle = vehicle
                        }
                    }
                }
            end
        end
        
        exports['sl-menu']:openMenu(menu)
    end)
end)

RegisterNetEvent('sl-dealership:client:ShowVehicleInfo', function(data)
    if displayVehicle then
        DeleteEntity(displayVehicle)
        displayVehicle = nil
    end
    
    selectedVehicle = data.vehicle
    displayVehicle = SpawnDisplayVehicle(GetHashKey(data.vehicle.model), Config.Locations[1].coords)
    
    local menu = {
        {
            header = "← Go Back",
            params = {
                event = "sl-dealership:client:ShowVehicles",
                args = {
                    category = data.vehicle.category
                }
            }
        },
        {
            header = "Test Drive",
            txt = "Take the vehicle for a test drive",
            params = {
                event = "sl-dealership:client:TestDrive",
                args = {
                    vehicle = data.vehicle
                }
            }
        },
        {
            header = "Purchase Vehicle",
            txt = "Price: $" .. SLCore.Functions.FormatNumber(data.vehicle.price),
            params = {
                event = "sl-dealership:client:PurchaseVehicle",
                args = {
                    vehicle = data.vehicle
                }
            }
        }
    }
    
    exports['sl-menu']:openMenu(menu)
end)

-- Initialize
CreateThread(function()
    SetupDealershipBlips()
    
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for _, location in pairs(Config.Locations) do
            local distance = #(playerCoords - location.coords)
            
            if distance < 10.0 then
                sleep = 0
                DrawMarker(1, location.coords.x, location.coords.y, location.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 150, 150, 100, false, true, 2, false, nil, nil, false)
                
                if distance < 2.0 and not isInDealership then
                    SLCore.Functions.DrawText3D(location.coords.x, location.coords.y, location.coords.z, "[E] Open Dealership")
                    
                    if IsControlJustReleased(0, 38) then -- E key
                        isInDealership = true
                        OpenDealershipMenu()
                    end
                end
            end
        end
        
        Wait(sleep)
    end
end)
