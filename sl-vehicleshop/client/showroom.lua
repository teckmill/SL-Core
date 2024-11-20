local SLCore = exports['sl-core']:GetCoreObject()
local currentVehicle = nil
local inShowroom = false
local showroomVehicles = {}

-- Core Functions
function SetupShowroom(shop)
    local shopConfig = Config.Shops[shop]
    if not shopConfig then return end

    -- Create showroom zone
    exports['sl-target']:AddBoxZone("vehicleshop_showroom_"..shop, 
        vector3(shopConfig.showRoom.coords.x, shopConfig.showRoom.coords.y, shopConfig.showRoom.coords.z), 
        shopConfig.showRoom.radius * 2, shopConfig.showRoom.radius * 2,
        {
            name = "vehicleshop_showroom_"..shop,
            heading = shopConfig.showRoom.coords.w,
            debugPoly = Config.Debug,
            minZ = shopConfig.showRoom.coords.z - 2,
            maxZ = shopConfig.showRoom.coords.z + 5
        }
    )

    -- Spawn showroom vehicles
    for i = 1, #Config.ShowroomVehicles do
        local vehicle = Config.ShowroomVehicles[i]
        if not vehicle.inUse then
            SpawnShowroomVehicle(vehicle)
        end
    end
end

function SpawnShowroomVehicle(vehicle)
    if vehicle.inUse then return end
    
    SLCore.Functions.SpawnVehicle(vehicle.chosenVehicle or vehicle.defaultVehicle, function(veh)
        SetEntityCoords(veh, vehicle.coords.x, vehicle.coords.y, vehicle.coords.z)
        SetEntityHeading(veh, vehicle.coords.w)
        SetVehicleOnGroundProperly(veh)
        SetEntityInvincible(veh, true)
        SetVehicleDirtLevel(veh, 0.0)
        SetVehicleDoorsLocked(veh, 2)
        FreezeEntityPosition(veh, true)
        SetVehicleNumberPlateText(veh, 'SHOW')
        vehicle.inUse = true
        showroomVehicles[#showroomVehicles + 1] = {
            vehicle = veh,
            displayData = vehicle
        }
    end, vehicle.coords, true)
end

function DeleteShowroomVehicle(index)
    if not showroomVehicles[index] then return end
    
    local vehData = showroomVehicles[index]
    SLCore.Functions.DeleteVehicle(vehData.vehicle)
    vehData.displayData.inUse = false
    table.remove(showroomVehicles, index)
end

function UpdateShowroomVehicle(index, model)
    if not showroomVehicles[index] then return end
    
    local vehData = showroomVehicles[index]
    DeleteShowroomVehicle(index)
    
    vehData.displayData.chosenVehicle = model
    SpawnShowroomVehicle(vehData.displayData)
end

function SetShowroomVehicle(model)
    if not currentVehicle then return end
    
    for i = 1, #showroomVehicles do
        if showroomVehicles[i].vehicle == currentVehicle then
            UpdateShowroomVehicle(i, model)
            break
        end
    end
end

-- Events
RegisterNetEvent('sl-vehicleshop:client:setShowroomVehicle', function(model)
    SetShowroomVehicle(model)
end)

-- Initialize
CreateThread(function()
    Wait(1000)
    for shop, _ in pairs(Config.Shops) do
        SetupShowroom(shop)
    end
end)

-- Cleanup
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    for i = #showroomVehicles, 1, -1 do
        DeleteShowroomVehicle(i)
    end
end)
