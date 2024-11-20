local SLCore = exports['sl-core']:GetCoreObject()

-- Shell Management
local loadedShells = {}
local shellModels = {}

-- Initialize Shell Models
CreateThread(function()
    for interiorType, data in pairs(Config.InteriorTypes) do
        for shellType, shellData in pairs(data.shells) do
            local model = shellData.model
            if not shellModels[model] then
                shellModels[model] = GetHashKey(model)
            end
        end
    end
end)

-- Shell Loading Functions
function PreloadShellModel(model)
    if not IsModelInCdimage(model) then return false end
    
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
    return true
end

function UnloadShellModel(model)
    if HasModelLoaded(model) then
        SetModelAsNoLongerNeeded(model)
    end
end

function CreateShellInstance(shellData, coords)
    if not shellData or not coords then return nil end
    
    local model = GetHashKey(shellData.model)
    if not PreloadShellModel(model) then
        print("Failed to load shell model: " .. shellData.model)
        return nil
    end
    
    local shell = CreateObject(model,
        coords.x + shellData.offset.x,
        coords.y + shellData.offset.y,
        coords.z + shellData.offset.z,
        false, false, false)
    
    if not DoesEntityExist(shell) then
        print("Failed to create shell instance")
        return nil
    end
    
    FreezeEntityPosition(shell, true)
    SetEntityInvincible(shell, true)
    SetEntityCollision(shell, true, false)
    
    UnloadShellModel(model)
    return shell
end

function DestroyShellInstance(shell)
    if DoesEntityExist(shell) then
        DeleteObject(shell)
    end
end

-- Shell Streaming
CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        -- Check loaded shells
        for id, shellData in pairs(loadedShells) do
            local distance = #(playerCoords - shellData.coords)
            if distance > Config.ShellSpawnDistance then
                DestroyShellInstance(shellData.object)
                loadedShells[id] = nil
            end
        end
        
        Wait(1000)
    end
end)

-- Shell Instance Management
function CreateShellInstanceWithID(shellType, coords, id)
    if loadedShells[id] then
        DestroyShellInstance(loadedShells[id].object)
        loadedShells[id] = nil
    end
    
    local shellData = nil
    for _, interiorData in pairs(Config.InteriorTypes) do
        if interiorData.shells[shellType] then
            shellData = interiorData.shells[shellType]
            break
        end
    end
    
    if not shellData then return false end
    
    local shellObject = CreateShellInstance(shellData, coords)
    if not shellObject then return false end
    
    loadedShells[id] = {
        object = shellObject,
        coords = coords,
        type = shellType
    }
    
    return true
end

function RemoveShellInstance(id)
    if loadedShells[id] then
        DestroyShellInstance(loadedShells[id].object)
        loadedShells[id] = nil
        return true
    end
    return false
end

-- Exports
exports('CreateShellInstance', CreateShellInstanceWithID)
exports('RemoveShellInstance', RemoveShellInstance)
exports('GetLoadedShells', function() return loadedShells end)
