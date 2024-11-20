local SLCore = exports['sl-core']:GetCoreObject()
local spawnedFurniture = {}
local selectedObject = nil
local isEditing = false
local isPlacing = false

local function LoadModel(model)
    if not IsModelInCdimage(model) then return false end
    
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
    
    return true
end

local function CreateFurniture(data)
    if not data.model or not LoadModel(data.model) then return end
    
    local coords = json.decode(data.coords)
    local object = CreateObject(data.model, coords.x, coords.y, coords.z, false, false, false)
    
    SetEntityRotation(object, coords.rx or 0.0, coords.ry or 0.0, coords.rz or 0.0, 2, true)
    FreezeEntityPosition(object, true)
    SetModelAsNoLongerNeeded(data.model)
    
    return object
end

local function PlaceFurniture(model, price)
    if isPlacing then return end
    isPlacing = true
    
    -- Check if player can afford furniture
    SLCore.Functions.TriggerCallback('sl-housing:server:CanAffordFurniture', function(canAfford)
        if not canAfford then
            SLCore.Functions.Notify(Lang:t('error.cannot_afford'), 'error')
            isPlacing = false
            return
        end
        
        if not LoadModel(model) then
            SLCore.Functions.Notify(Lang:t('error.invalid_model'), 'error')
            isPlacing = false
            return
        end
        
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local object = CreateObject(model, coords.x, coords.y, coords.z, false, false, false)
        
        SetEntityAlpha(object, 200, false)
        SetEntityCollision(object, false, false)
        
        while isPlacing do
            Wait(0)
            DisableControlActions()
            
            local hit, _, endCoords, _, _ = RayCastGamePlayCamera(10.0)
            if hit then
                SetEntityCoords(object, endCoords.x, endCoords.y, endCoords.z)
                
                if IsControlPressed(0, 174) then -- Left Arrow
                    SetEntityRotation(object, 0.0, 0.0, GetEntityHeading(object) + 1.0, 2, true)
                elseif IsControlPressed(0, 175) then -- Right Arrow
                    SetEntityRotation(object, 0.0, 0.0, GetEntityHeading(object) - 1.0, 2, true)
                end
                
                if IsControlJustPressed(0, 38) then -- E
                    local coords = GetEntityCoords(object)
                    local rotation = GetEntityRotation(object)
                    
                    -- Save furniture to database
                    TriggerServerEvent('sl-housing:server:SaveFurniture', {
                        model = model,
                        coords = json.encode({
                            x = coords.x,
                            y = coords.y,
                            z = coords.z,
                            rx = rotation.x,
                            ry = rotation.y,
                            rz = rotation.z
                        }),
                        price = price
                    })
                    
                    isPlacing = false
                    break
                elseif IsControlJustPressed(0, 177) then -- BACKSPACE
                    isPlacing = false
                    break
                end
            end
        end
        
        DeleteObject(object)
        SetModelAsNoLongerNeeded(model)
    end, price)
end

local function EditFurniture(object)
    if not object or isEditing then return end
    isEditing = true
    selectedObject = object
    
    FreezeEntityPosition(object, false)
    SetEntityAlpha(object, 200, false)
    
    while isEditing do
        Wait(0)
        DisableControlActions()
        
        if IsControlPressed(0, 174) then -- Left Arrow
            SetEntityRotation(object, 0.0, 0.0, GetEntityHeading(object) + 1.0, 2, true)
        elseif IsControlPressed(0, 175) then -- Right Arrow
            SetEntityRotation(object, 0.0, 0.0, GetEntityHeading(object) - 1.0, 2, true)
        elseif IsControlPressed(0, 172) then -- Up Arrow
            local coords = GetEntityCoords(object)
            SetEntityCoords(object, coords.x, coords.y, coords.z + 0.01)
        elseif IsControlPressed(0, 173) then -- Down Arrow
            local coords = GetEntityCoords(object)
            SetEntityCoords(object, coords.x, coords.y, coords.z - 0.01)
        end
        
        if IsControlJustPressed(0, 38) then -- E
            local coords = GetEntityCoords(object)
            local rotation = GetEntityRotation(object)
            
            -- Update furniture position in database
            TriggerServerEvent('sl-housing:server:UpdateFurniture', NetworkGetNetworkIdFromEntity(object), {
                coords = json.encode({
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                    rx = rotation.x,
                    ry = rotation.y,
                    rz = rotation.z
                })
            })
            
            isEditing = false
            break
        elseif IsControlJustPressed(0, 177) then -- BACKSPACE
            isEditing = false
            break
        end
    end
    
    if DoesEntityExist(object) then
        FreezeEntityPosition(object, true)
        SetEntityAlpha(object, 255, false)
    end
    
    selectedObject = nil
end

-- Events
RegisterNetEvent('sl-housing:client:LoadFurniture', function(houseId)
    -- Get furniture from server
    SLCore.Functions.TriggerCallback('sl-housing:server:GetFurniture', function(furniture)
        for _, item in pairs(furniture) do
            local object = CreateFurniture(item)
            if object then
                spawnedFurniture[item.id] = object
            end
        end
    end, houseId)
end)

RegisterNetEvent('sl-housing:client:UnloadFurniture', function()
    for _, object in pairs(spawnedFurniture) do
        if DoesEntityExist(object) then
            DeleteObject(object)
        end
    end
    spawnedFurniture = {}
end)

RegisterNetEvent('sl-housing:client:SyncFurniture', function(furnitureId, data, delete)
    if delete then
        if spawnedFurniture[furnitureId] and DoesEntityExist(spawnedFurniture[furnitureId]) then
            DeleteObject(spawnedFurniture[furnitureId])
            spawnedFurniture[furnitureId] = nil
        end
    else
        if spawnedFurniture[furnitureId] and DoesEntityExist(spawnedFurniture[furnitureId]) then
            DeleteObject(spawnedFurniture[furnitureId])
        end
        
        local object = CreateFurniture(data)
        if object then
            spawnedFurniture[furnitureId] = object
        end
    end
end)

-- Exports
exports('PlaceFurniture', PlaceFurniture)
exports('EditFurniture', EditFurniture)
exports('GetSpawnedFurniture', function()
    return spawnedFurniture
end)
