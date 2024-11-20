local SLCore = exports['sl-core']:GetCoreObject()
local spawnedObjects = {}
local objectList = {
    ["cone"] = {model = `prop_roadcone02a`, freeze = false},
    ["barrier"] = {model = `prop_barrier_work06a`, freeze = true},
    ["spike"] = {model = `p_ld_stinger_s`, freeze = true},
    ["tent"] = {model = `prop_gazebo_02`, freeze = true},
    ["light"] = {model = `prop_worklight_03b`, freeze = false}
}

-- Function to spawn police objects
local function spawnObject(type)
    local objectData = objectList[type]
    if not objectData then return end
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    SLCore.Functions.LoadModel(objectData.model)
    
    local obj = CreateObject(objectData.model, coords.x, coords.y, coords.z, true, true, true)
    PlaceObjectOnGroundProperly(obj)
    SetEntityHeading(obj, heading)
    FreezeEntityPosition(obj, objectData.freeze)
    
    table.insert(spawnedObjects, obj)
    return obj
end

-- Function to remove closest object
local function removeClosestObject()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local closestObject = nil
    local closestDistance = 5.0
    
    for i = 1, #spawnedObjects do
        local object = spawnedObjects[i]
        if DoesEntityExist(object) then
            local objectCoords = GetEntityCoords(object)
            local distance = #(coords - objectCoords)
            
            if distance < closestDistance then
                closestObject = object
                closestDistance = distance
            end
        end
    end
    
    if closestObject and DoesEntityExist(closestObject) then
        for i = 1, #spawnedObjects do
            if spawnedObjects[i] == closestObject then
                table.remove(spawnedObjects, i)
                break
            end
        end
        DeleteObject(closestObject)
        return true
    end
    
    return false
end

-- Function to remove all objects
local function removeAllObjects()
    for i = 1, #spawnedObjects do
        if DoesEntityExist(spawnedObjects[i]) then
            DeleteObject(spawnedObjects[i])
        end
    end
    spawnedObjects = {}
end

-- Register events
RegisterNetEvent('sl-police:client:SpawnObject', function(type)
    if not IsPoliceJob() then return end
    spawnObject(type)
end)

RegisterNetEvent('sl-police:client:RemoveObject', function()
    if not IsPoliceJob() then return end
    removeClosestObject()
end)

-- Export functions
exports('SpawnPoliceObject', spawnObject)
exports('RemoveClosestObject', removeClosestObject)
exports('RemoveAllObjects', removeAllObjects)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        removeAllObjects()
    end
end)
