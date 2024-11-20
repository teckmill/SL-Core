local SLCore = exports['sl-core']:GetCoreObject()
local spawnedObjects = {}

-- Function to spawn medical objects
local function spawnObject(objectModel)
    local coords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    
    SLCore.Functions.LoadModel(objectModel)
    
    local obj = CreateObject(objectModel, coords.x, coords.y, coords.z, true, true, true)
    PlaceObjectOnGroundProperly(obj)
    SetEntityHeading(obj, heading)
    FreezeEntityPosition(obj, true)
    
    table.insert(spawnedObjects, obj)
    return obj
end

-- Function to remove spawned objects
local function removeObject(obj)
    SetEntityAsMissionEntity(obj, false, true)
    DeleteObject(obj)
end

-- Function to remove all spawned objects
local function removeAllObjects()
    for i = 1, #spawnedObjects do
        removeObject(spawnedObjects[i])
    end
    spawnedObjects = {}
end

-- Export functions
exports('SpawnMedicalObject', spawnObject)
exports('RemoveMedicalObject', removeObject)
exports('RemoveAllMedicalObjects', removeAllObjects)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        removeAllObjects()
    end
end)
