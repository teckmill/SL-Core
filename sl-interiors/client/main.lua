local SLCore = exports['sl-core']:GetCoreObject()

-- Core Ready Check
local CoreReady = false
AddEventHandler('SLCore:Client:OnPlayerLoaded', function()
    CoreReady = true
    LoadRequiredIPLs()
end)

-- Variables
local currentInterior = nil
local currentShell = nil
local currentFurniture = {}

-- IPL Management
function LoadRequiredIPLs()
    for _, ipl in pairs(Config.RequiredIPLs) do
        if not IsIplActive(ipl) then
            RequestIpl(ipl)
        end
    end
end

-- Interior Management
function LoadInterior(interiorType, shellType)
    if not Config.InteriorTypes[interiorType] then return end
    if not Config.InteriorTypes[interiorType].shells[shellType] then return end
    
    local shellData = Config.InteriorTypes[interiorType].shells[shellType]
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    -- Create shell
    currentShell = CreateObject(GetHashKey(shellData.model), 
        coords.x + shellData.offset.x,
        coords.y + shellData.offset.y,
        coords.z + shellData.offset.z,
        false, false, false)
    
    FreezeEntityPosition(currentShell, true)
    SetEntityHeading(currentShell, 0.0)
    
    -- Load furniture if enabled
    if Config.EnableFurniture then
        LoadFurniture(shellData.furniture)
    end
    
    -- Set interior data
    currentInterior = {
        type = interiorType,
        shell = shellType,
        coords = coords,
        offset = shellData.offset
    }
    
    -- Teleport player inside
    local enterOffset = shellData.offset
    SetEntityCoords(ped, 
        coords.x + enterOffset.x,
        coords.y + enterOffset.y,
        coords.z + enterOffset.z + 1.0)
end

function UnloadInterior()
    if currentShell then
        DeleteObject(currentShell)
        currentShell = nil
    end
    
    if Config.EnableFurniture then
        UnloadFurniture()
    end
    
    currentInterior = nil
end

-- Furniture Management
function LoadFurniture(furniture)
    if not furniture then return end
    
    for _, item in pairs(furniture) do
        if #currentFurniture < Config.FurnitureLimit then
            local furnitureObj = CreateObject(
                GetHashKey(item.model),
                currentInterior.coords.x + item.pos.x,
                currentInterior.coords.y + item.pos.y,
                currentInterior.coords.z + item.pos.z,
                false, false, false)
            
            SetEntityRotation(furnitureObj,
                item.rot.x,
                item.rot.y,
                item.rot.z,
                2, true)
            
            FreezeEntityPosition(furnitureObj, true)
            table.insert(currentFurniture, furnitureObj)
        end
    end
end

function UnloadFurniture()
    for _, furniture in pairs(currentFurniture) do
        DeleteObject(furniture)
    end
    currentFurniture = {}
end

-- Events
RegisterNetEvent('sl-interiors:client:LoadInterior', function(interiorType, shellType)
    if not CoreReady then return end
    LoadInterior(interiorType, shellType)
end)

RegisterNetEvent('sl-interiors:client:UnloadInterior', function()
    if not CoreReady then return end
    UnloadInterior()
end)

-- Commands
RegisterCommand('enterinterior', function(source, args)
    if not CoreReady then return end
    if not args[1] or not args[2] then
        SLCore.Functions.Notify('Usage: /enterinterior [type] [shell]', 'error')
        return
    end
    
    local interiorType = args[1]
    local shellType = args[2]
    
    if not Config.InteriorTypes[interiorType] or not Config.InteriorTypes[interiorType].shells[shellType] then
        SLCore.Functions.Notify('Invalid interior or shell type', 'error')
        return
    end
    
    LoadInterior(interiorType, shellType)
end)

RegisterCommand('exitinterior', function()
    if not CoreReady then return end
    if not currentInterior then return end
    
    local ped = PlayerPedId()
    local exitOffset = Config.DefaultExitOffset
    local exitCoords = vector3(
        currentInterior.coords.x + exitOffset.x,
        currentInterior.coords.y + exitOffset.y,
        currentInterior.coords.z + exitOffset.z
    )
    
    SetEntityCoords(ped, exitCoords.x, exitCoords.y, exitCoords.z)
    UnloadInterior()
end)

-- Exports
exports('LoadInterior', LoadInterior)
exports('UnloadInterior', UnloadInterior)
exports('GetCurrentInterior', function() return currentInterior end)
exports('IsInInterior', function() return currentInterior ~= nil end)
