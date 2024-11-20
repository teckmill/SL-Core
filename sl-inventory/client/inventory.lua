local SLCore = exports['sl-core']:GetCoreObject()
local currentSecondaryInventory = nil
local isNearTrunk = false
local isNearGlovebox = false
local currentVehicle = nil

-- Event Handlers
RegisterNetEvent('sl-inventory:client:OpenSecondaryInventory', function(inventoryType, data)
    if not inventoryType then return end
    
    currentSecondaryInventory = {
        type = inventoryType,
        data = data
    }
    
    TriggerEvent('sl-inventory:client:OpenInventory', 'player', {
        secondary = currentSecondaryInventory
    })
end)

-- Vehicle Inventory Functions
function GetVehicleInDirection()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local inDirection = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
    local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(playerCoords.x, playerCoords.y, playerCoords.z, inDirection.x, inDirection.y, inDirection.z, 10, playerPed, 0)
    local _, hit, _, _, vehicle = GetShapeTestResult(rayHandle)
    
    if hit and DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        return vehicle
    end
    
    return nil
end

function GetVehicleInventoryType(vehicle)
    if not DoesEntityExist(vehicle) then return nil end
    
    local vehClass = GetVehicleClass(vehicle)
    local vehModel = GetEntityModel(vehicle)
    
    -- Special vehicle checks can be added here
    -- Example: return 'special_trunk' for specific models
    
    return 'trunk'
end

-- Vehicle Inventory Threads
CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local vehicle = GetVehicleInDirection()
        
        if DoesEntityExist(vehicle) then
            sleep = 0
            local trunkPos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, 'boot'))
            local distanceToTrunk = #(GetEntityCoords(playerPed) - trunkPos)
            
            if distanceToTrunk < 2.0 then
                if not isNearTrunk then
                    isNearTrunk = true
                    currentVehicle = vehicle
                    
                    -- Show interaction text
                    if not IsPedInAnyVehicle(playerPed, true) then
                        SLCore.Functions.DrawText3D(trunkPos.x, trunkPos.y, trunkPos.z, Lang:t('info.press_to_open'))
                    end
                end
            else
                isNearTrunk = false
                if vehicle == currentVehicle then
                    currentVehicle = nil
                end
            end
        end
        
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        
        if IsPedInAnyVehicle(playerPed, false) then
            sleep = 0
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            
            if DoesEntityExist(vehicle) then
                if not isNearGlovebox then
                    isNearGlovebox = true
                    currentVehicle = vehicle
                end
            end
        else
            isNearGlovebox = false
            if not isNearTrunk then
                currentVehicle = nil
            end
        end
        
        Wait(sleep)
    end
end)

-- Key Bindings for Vehicle Inventories
RegisterCommand('trunk', function()
    if isNearTrunk and currentVehicle then
        if IsVehicleLocked(currentVehicle) then
            SLCore.Functions.Notify(Lang:t('error.vehicle_locked'), 'error')
            return
        end
        
        local inventoryType = GetVehicleInventoryType(currentVehicle)
        if inventoryType then
            TriggerServerEvent('sl-inventory:server:OpenTrunk', NetworkGetNetworkIdFromEntity(currentVehicle))
        end
    end
end, false)

RegisterCommand('glovebox', function()
    if isNearGlovebox and currentVehicle then
        if IsVehicleLocked(currentVehicle) then
            SLCore.Functions.Notify(Lang:t('error.vehicle_locked'), 'error')
            return
        end
        
        TriggerServerEvent('sl-inventory:server:OpenGlovebox', NetworkGetNetworkIdFromEntity(currentVehicle))
    end
end, false)

-- Key Mappings
RegisterKeyMapping('trunk', 'Open Vehicle Trunk', 'keyboard', 'L')
RegisterKeyMapping('glovebox', 'Open Vehicle Glovebox', 'keyboard', 'G')

-- Shop Functions
function IsNearShop()
    local playerCoords = GetEntityCoords(PlayerPedId())
    for shopType, shop in pairs(Config.Shops) do
        for _, coords in ipairs(shop.coords) do
            if #(playerCoords - coords) < 2.0 then
                return shopType
            end
        end
    end
    return false
end

-- Shop Thread
CreateThread(function()
    while true do
        local sleep = 1000
        local shopType = IsNearShop()
        
        if shopType then
            sleep = 0
            local shopConfig = Config.Shops[shopType]
            
            -- Show interaction text
            SLCore.Functions.DrawText3D(GetEntityCoords(PlayerPedId()), Lang:t('info.press_to_open'))
            
            if IsControlJustReleased(0, 38) then -- E key
                TriggerServerEvent('sl-inventory:server:OpenShop', shopType)
            end
        end
        
        Wait(sleep)
    end
end)

-- Crafting Functions
function IsNearCraftingStation()
    -- Add crafting station locations and checks here
    return false
end

-- Crafting Thread
CreateThread(function()
    while true do
        local sleep = 1000
        
        if IsNearCraftingStation() then
            sleep = 0
            -- Show interaction text
            SLCore.Functions.DrawText3D(GetEntityCoords(PlayerPedId()), Lang:t('info.press_to_open'))
            
            if IsControlJustReleased(0, 38) then -- E key
                TriggerEvent('sl-inventory:client:OpenInventory', 'crafting')
            end
        end
        
        Wait(sleep)
    end
end)

-- Export functions
exports('GetCurrentSecondaryInventory', function()
    return currentSecondaryInventory
end)

exports('IsNearVehicleInventory', function()
    return isNearTrunk or isNearGlovebox
end)

exports('GetCurrentVehicle', function()
    return currentVehicle
end)
