local SLCore = exports['sl-core']:GetCoreObject()
local Properties = {}
local CurrentProperty = nil
local InsideProperty = false
local FurnitureMode = false
local SelectedFurniture = nil

-- Initialize
CreateThread(function()
    while not SLCore do
        Wait(100)
    end
    
    -- Create property blips
    for propertyId, property in pairs(Config.Properties) do
        if property.blip then
            local blip = AddBlipForCoord(property.entrance.x, property.entrance.y, property.entrance.z)
            SetBlipSprite(blip, property.blip.sprite or 350)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, property.blip.scale or 0.8)
            SetBlipColour(blip, property.blip.color or 2)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(property.label or "Property")
            EndTextCommandSetBlipName(blip)
        end
    end
end)

-- Property Zones
CreateThread(function()
    while true do
        local wait = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for propertyId, property in pairs(Config.Properties) do
            local distance = #(playerCoords - vector3(property.entrance.x, property.entrance.y, property.entrance.z))
            
            if distance < 50.0 then
                wait = 0
                if distance < 2.0 then
                    if not InsideProperty then
                        DrawText3D(property.entrance.x, property.entrance.y, property.entrance.z, 
                            property.owner and '[E] Enter Property' or '[E] View Property')
                        
                        if IsControlJustPressed(0, 38) then -- E key
                            TriggerServerCallback('sl-housing:server:HasAccess', function(hasAccess)
                                if hasAccess or not property.owner then
                                    EnterProperty(propertyId)
                                else
                                    SLCore.Functions.Notify('You do not have access to this property', 'error')
                                end
                            end, propertyId)
                        end
                    end
                end
            end
        end
        
        Wait(wait)
    end
end)

-- Property Interior Management
function EnterProperty(propertyId)
    local property = Properties[propertyId]
    if not property then return end
    
    -- Load property shell
    local shell = Config.Shells[property.shell]
    if not shell then return end
    
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(10) end
    
    -- Create shell interior
    local interior = CreateObject(GetHashKey(shell.model), shell.coords.x, shell.coords.y, shell.coords.z, false, false, false)
    FreezeEntityPosition(interior, true)
    
    -- Teleport player
    SetEntityCoords(PlayerPedId(), shell.spawn.x, shell.spawn.y, shell.spawn.z)
    SetEntityHeading(PlayerPedId(), shell.spawn.w)
    
    CurrentProperty = propertyId
    InsideProperty = true
    
    -- Load furniture
    if property.furniture then
        for _, item in ipairs(property.furniture) do
            local furnitureObj = CreateObject(GetHashKey(item.model), 
                item.coords.x, item.coords.y, item.coords.z, 
                false, false, false)
            SetEntityRotation(furnitureObj, 
                item.rotation.x, item.rotation.y, item.rotation.z, 
                2, true)
            FreezeEntityPosition(furnitureObj, true)
        end
    end
    
    DoScreenFadeIn(500)
    
    -- Create exit zone
    CreateThread(function()
        while InsideProperty do
            local wait = 1000
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - vector3(shell.exit.x, shell.exit.y, shell.exit.z))
            
            if distance < 2.0 then
                wait = 0
                DrawText3D(shell.exit.x, shell.exit.y, shell.exit.z, '[E] Exit Property')
                
                if IsControlJustPressed(0, 38) then -- E key
                    ExitProperty()
                end
            end
            
            Wait(wait)
        end
    end)
end

function ExitProperty()
    if not CurrentProperty then return end
    
    local property = Properties[CurrentProperty]
    if not property then return end
    
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(10) end
    
    -- Delete interior objects
    local interior = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 100.0, GetHashKey(Config.Shells[property.shell].model))
    if interior ~= 0 then
        DeleteObject(interior)
    end
    
    -- Delete furniture
    local objects = GetGamePool('CObject')
    for _, object in ipairs(objects) do
        if IsEntityAttachedToEntity(PlayerPedId(), object) then
            DeleteObject(object)
        end
    end
    
    -- Teleport player back
    SetEntityCoords(PlayerPedId(), 
        property.entrance.x, property.entrance.y, property.entrance.z)
    
    CurrentProperty = nil
    InsideProperty = false
    FurnitureMode = false
    SelectedFurniture = nil
    
    DoScreenFadeIn(500)
end

-- Furniture Placement
RegisterNetEvent('sl-housing:client:FurnitureMode', function(enabled)
    if not CurrentProperty then return end
    
    FurnitureMode = enabled
    if enabled then
        SLCore.Functions.Notify('Furniture placement mode enabled')
        -- Show furniture catalog UI
        SendNUIMessage({
            action = 'showFurniture',
            furniture = Config.Furniture
        })
        SetNuiFocus(true, true)
    else
        SLCore.Functions.Notify('Furniture placement mode disabled')
        SetNuiFocus(false, false)
    end
end)

RegisterNUICallback('selectFurniture', function(data, cb)
    SelectedFurniture = data.model
    -- Preview furniture placement
    local furnitureData = Config.Furniture[data.model]
    if furnitureData then
        local playerCoords = GetEntityCoords(PlayerPedId())
        local furnitureObj = CreateObject(GetHashKey(data.model), 
            playerCoords.x, playerCoords.y, playerCoords.z, 
            false, false, false)
        SetEntityAlpha(furnitureObj, 200)
        SetEntityCollision(furnitureObj, false, false)
        
        -- Furniture placement preview thread
        CreateThread(function()
            while SelectedFurniture do
                local hit, coords, normal = RaycastGamePlayCamera(5.0)
                if hit then
                    SetEntityCoords(furnitureObj, coords.x, coords.y, coords.z)
                    
                    if IsControlPressed(0, 174) then -- Left Arrow
                        SetEntityRotation(furnitureObj, 
                            GetEntityRotation(furnitureObj) + vector3(0, 0, 1))
                    elseif IsControlPressed(0, 175) then -- Right Arrow
                        SetEntityRotation(furnitureObj, 
                            GetEntityRotation(furnitureObj) - vector3(0, 0, 1))
                    end
                    
                    if IsControlJustPressed(0, 38) then -- E key
                        -- Place furniture
                        local rotation = GetEntityRotation(furnitureObj)
                        DeleteObject(furnitureObj)
                        
                        TriggerServerEvent('sl-housing:server:PlaceFurniture', CurrentProperty, {
                            model = data.model,
                            coords = coords,
                            rotation = rotation
                        })
                        
                        SelectedFurniture = nil
                        break
                    end
                end
                Wait(0)
            end
            
            if DoesEntityExist(furnitureObj) then
                DeleteObject(furnitureObj)
            end
        end)
    end
    cb('ok')
end)

-- Property Updates
RegisterNetEvent('sl-housing:client:UpdateProperties', function(propertyData)
    Properties = propertyData
end)

RegisterNetEvent('sl-housing:client:UpdateFurniture', function(propertyId, furniture)
    if Properties[propertyId] then
        Properties[propertyId].furniture = furniture
        
        if CurrentProperty == propertyId then
            -- Refresh furniture in current property
            local objects = GetGamePool('CObject')
            for _, object in ipairs(objects) do
                if not IsEntityAttachedToEntity(PlayerPedId(), object) then
                    DeleteObject(object)
                end
            end
            
            for _, item in ipairs(furniture) do
                local furnitureObj = CreateObject(GetHashKey(item.model), 
                    item.coords.x, item.coords.y, item.coords.z, 
                    false, false, false)
                SetEntityRotation(furnitureObj, 
                    item.rotation.x, item.rotation.y, item.rotation.z, 
                    2, true)
                FreezeEntityPosition(furnitureObj, true)
            end
        end
    end
end)

-- Utility Functions
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px, py, pz) - vector3(x, y, z))
    
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    
    if onScreen then
        SetTextScale(0.0 * scale, 0.35 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function RaycastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination = vector3(
        cameraCoord.x + direction.x * distance,
        cameraCoord.y + direction.y * distance,
        cameraCoord.z + direction.z * distance
    )
    local ray = StartExpensiveSynchronousShapeTestLosProbe(
        cameraCoord.x, cameraCoord.y, cameraCoord.z,
        destination.x, destination.y, destination.z,
        1, PlayerPedId(), 0
    )
    local _, hit, endCoords, _, _ = GetShapeTestResult(ray)
    return hit, endCoords, direction
end

function RotationToDirection(rotation)
    local adjustedRotation = vector3(
        (math.pi / 180) * rotation.x,
        (math.pi / 180) * rotation.y,
        (math.pi / 180) * rotation.z
    )
    local direction = vector3(
        -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.sin(adjustedRotation.x)
    )
    return direction
end

-- Notifications
RegisterNetEvent('sl-housing:client:PaymentDue', function(propertyId)
    SLCore.Functions.Notify('Payment due for your property!', 'error')
end)

RegisterNetEvent('sl-housing:client:MaintenanceNeeded', function(propertyId)
    SLCore.Functions.Notify('Your property requires maintenance!', 'error')
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if InsideProperty then
            ExitProperty()
        end
    end
end)
