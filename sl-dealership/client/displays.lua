local SLCore = exports['sl-core']:GetCoreObject()
local DisplayVehicles = {}
local CurrentDealership = nil

-- Utility Functions
local function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
end

local function CreateDisplayVehicle(model, coords)
    LoadModel(model)
    
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, false, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleDoorsLocked(vehicle, 2)
    SetVehicleEngineOn(vehicle, false, true, true)
    FreezeEntityPosition(vehicle, true)
    SetEntityInvincible(vehicle, true)
    SetVehicleDirtLevel(vehicle, 0.0)
    
    return vehicle
end

-- Display Management
function InitializeDisplays(dealership)
    CurrentDealership = dealership
    local dealershipConfig = Config.Dealerships[dealership]
    
    -- Clear existing display vehicles
    ClearDisplays()
    
    -- Create new display vehicles
    for i, displayArea in ipairs(dealershipConfig.displayAreas) do
        local category = next(Config.Categories)
        local vehicleConfig = Config.Categories[category].vehicles[1]
        
        local vehicle = CreateDisplayVehicle(vehicleConfig.model, displayArea.coords)
        DisplayVehicles[i] = {
            entity = vehicle,
            model = vehicleConfig.model,
            category = category,
            index = 1
        }
        
        -- Add target interaction
        if Config.UseTarget then
            exports['sl-target']:AddTargetEntity(vehicle, {
                options = {
                    {
                        type = "client",
                        event = "sl-dealership:client:ViewVehicle",
                        icon = "fas fa-car",
                        label = "View Vehicle",
                        displayId = i
                    },
                    {
                        type = "client",
                        event = "sl-dealership:client:ChangeDisplay",
                        icon = "fas fa-exchange-alt",
                        label = "Change Display",
                        displayId = i,
                        job = Config.Commission.jobName
                    }
                },
                distance = 2.5
            })
        end
    end
end

function ClearDisplays()
    for _, display in pairs(DisplayVehicles) do
        if DoesEntityExist(display.entity) then
            DeleteEntity(display.entity)
        end
    end
    DisplayVehicles = {}
end

function ChangeDisplayVehicle(displayId, category, index)
    if not DisplayVehicles[displayId] then return end
    
    local currentDisplay = DisplayVehicles[displayId]
    local vehicleConfig = Config.Categories[category].vehicles[index]
    if not vehicleConfig then return end
    
    -- Delete current vehicle
    if DoesEntityExist(currentDisplay.entity) then
        DeleteEntity(currentDisplay.entity)
    end
    
    -- Create new display vehicle
    local dealershipConfig = Config.Dealerships[CurrentDealership]
    local coords = dealershipConfig.displayAreas[displayId].coords
    local vehicle = CreateDisplayVehicle(vehicleConfig.model, coords)
    
    DisplayVehicles[displayId] = {
        entity = vehicle,
        model = vehicleConfig.model,
        category = category,
        index = index
    }
    
    -- Update target
    if Config.UseTarget then
        exports['sl-target']:AddTargetEntity(vehicle, {
            options = {
                {
                    type = "client",
                    event = "sl-dealership:client:ViewVehicle",
                    icon = "fas fa-car",
                    label = "View Vehicle",
                    displayId = displayId
                },
                {
                    type = "client",
                    event = "sl-dealership:client:ChangeDisplay",
                    icon = "fas fa-exchange-alt",
                    label = "Change Display",
                    displayId = displayId,
                    job = Config.Commission.jobName
                }
            },
            distance = 2.5
        })
    end
end

-- Events
RegisterNetEvent('sl-dealership:client:ViewVehicle', function(data)
    local displayId = data.displayId
    local display = DisplayVehicles[displayId]
    if not display then return end
    
    local vehicleConfig = Config.Categories[display.category].vehicles[display.index]
    OpenVehicleMenu(vehicleConfig, displayId)
end)

RegisterNetEvent('sl-dealership:client:ChangeDisplay', function(data)
    local displayId = data.displayId
    OpenDisplayMenu(displayId)
end)

-- Cleanup
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        ClearDisplays()
    end
end) 