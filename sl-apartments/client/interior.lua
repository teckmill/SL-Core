local SLCore = exports['sl-core']:GetCoreObject()
local currentInterior = nil
local currentShell = nil
local currentFurniture = {}

-- Interior Management
function LoadInterior(interior)
    if not Config.Interiors[interior] then return end
    
    local interiorData = Config.Interiors[interior]
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    -- Create shell
    currentShell = CreateObject(GetHashKey(interiorData.shell), coords.x, coords.y, coords.z, false, false, false)
    FreezeEntityPosition(currentShell, true)
    SetEntityHeading(currentShell, 0.0)
    
    -- Load furniture
    for _, furniture in pairs(interiorData.furniture) do
        local furnitureObj = CreateObject(
            GetHashKey(furniture.prop),
            coords.x + furniture.pos.x,
            coords.y + furniture.pos.y,
            coords.z + furniture.pos.z,
            false, false, false
        )
        FreezeEntityPosition(furnitureObj, true)
        table.insert(currentFurniture, furnitureObj)
    end
    
    currentInterior = interior
    SetEntityCoords(ped, coords.x, coords.y, coords.z + 1.0)
end

function UnloadInterior()
    if currentShell then
        DeleteObject(currentShell)
        currentShell = nil
    end
    
    for _, furniture in pairs(currentFurniture) do
        DeleteObject(furniture)
    end
    currentFurniture = {}
    currentInterior = nil
end

function GetInteriorOffset(interior)
    if not Config.Interiors[interior] then return vector3(0.0, 0.0, 0.0) end
    return Config.Interiors[interior].offset or vector3(0.0, 0.0, 0.0)
end

-- Events
RegisterNetEvent('sl-apartments:client:LoadInterior', function(interior)
    LoadInterior(interior)
end)

RegisterNetEvent('sl-apartments:client:UnloadInterior', function()
    UnloadInterior()
end)

-- Export functions
exports('LoadInterior', LoadInterior)
exports('UnloadInterior', UnloadInterior)
exports('GetInteriorOffset', GetInteriorOffset)
exports('GetCurrentInterior', function() return currentInterior end)
