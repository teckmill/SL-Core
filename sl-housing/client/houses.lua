local SLCore = exports['sl-core']:GetCoreObject()
local spawnedHouses = {}
local currentHouse = nil
local isInside = false
local hasKeys = false

-- House Zone Functions
local function CreateHouseZone(house)
    if spawnedHouses[house.id] then return end
    
    local coords = json.decode(house.coords)
    local zone = BoxZone:Create(
        vector3(coords.x, coords.y, coords.z),
        house.width or 2.0,
        house.length or 2.0,
        {
            name = "house_" .. house.id,
            heading = coords.w,
            minZ = coords.z - 1.0,
            maxZ = coords.z + 3.0,
            debugPoly = false
        }
    )
    
    zone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            if hasKeys then
                exports['sl-core']:DrawText(Lang:t('info.enter_house'), 'left')
            else
                exports['sl-core']:DrawText(Lang:t('info.knock_house'), 'left')
            end
        else
            exports['sl-core']:HideText()
        end
    end)
    
    spawnedHouses[house.id] = {
        zone = zone,
        data = house
    }
end

local function RemoveHouseZone(houseId)
    if not spawnedHouses[houseId] then return end
    
    spawnedHouses[houseId].zone:destroy()
    spawnedHouses[houseId] = nil
end

-- House Interaction Functions
local function EnterHouse(house)
    if isInside then return end
    
    SLCore.Functions.TriggerCallback('sl-housing:server:CanEnterHouse', function(canEnter)
        if canEnter then
            DoScreenFadeOut(500)
            while not IsScreenFadedOut() do Wait(10) end
            
            currentHouse = house
            isInside = true
            
            -- Load house interior
            local interior = exports['sl-interior']:CreateHouseInterior(house.shell)
            SetEntityCoords(PlayerPedId(), interior.entrance.x, interior.entrance.y, interior.entrance.z)
            
            -- Load furniture
            TriggerEvent('sl-housing:client:LoadFurniture', house.id)
            
            DoScreenFadeIn(500)
            exports['sl-core']:DrawText(Lang:t('info.leave_house'), 'left')
        else
            SLCore.Functions.Notify(Lang:t('error.cannot_enter'), 'error')
        end
    end, house.id)
end

local function LeaveHouse()
    if not isInside or not currentHouse then return end
    
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(10) end
    
    -- Cleanup interior
    exports['sl-interior']:DestroyInterior()
    
    -- Remove furniture
    TriggerEvent('sl-housing:client:UnloadFurniture')
    
    -- Teleport outside
    local coords = json.decode(currentHouse.coords)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
    
    currentHouse = nil
    isInside = false
    
    DoScreenFadeIn(500)
end

-- Events
RegisterNetEvent('sl-housing:client:SyncHouse', function(houseData, delete)
    if delete then
        RemoveHouseZone(houseData.id)
    else
        CreateHouseZone(houseData)
    end
end)

RegisterNetEvent('sl-housing:client:UpdateKeys', function(houseId, hasAccess)
    if spawnedHouses[houseId] then
        hasKeys = hasAccess
    end
end)

-- Commands
RegisterCommand('enterhouse', function()
    if isInside or not currentHouse then return end
    EnterHouse(currentHouse)
end)

RegisterCommand('leavehouse', function()
    if not isInside or not currentHouse then return end
    LeaveHouse()
end)

-- Initialize
CreateThread(function()
    -- Get all houses from server
    SLCore.Functions.TriggerCallback('sl-housing:server:GetAllHouses', function(houses)
        for _, house in pairs(houses) do
            CreateHouseZone(house)
        end
    end)
end)

-- Exports
exports('IsInside', function()
    return isInside
end)

exports('GetCurrentHouse', function()
    return currentHouse
end)

exports('HasKeys', function()
    return hasKeys
end)
