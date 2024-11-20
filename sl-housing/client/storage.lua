local SLCore = exports['sl-core']:GetCoreObject()

local currentStash = nil

local function OpenStorage(house)
    if not house then return end
    if not house.id then return end
    
    currentStash = house.id
    
    -- Open stash using inventory system
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "house_" .. house.id, {
        maxweight = 4000000,
        slots = 50,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "house_" .. house.id)
end

local function OpenWardrobe(house)
    if not house then return end
    
    -- Open clothing menu
    TriggerEvent('sl-clothing:client:openOutfitMenu')
end

-- Events
RegisterNetEvent('sl-housing:client:OpenStorage', function(house)
    OpenStorage(house)
end)

RegisterNetEvent('sl-housing:client:OpenWardrobe', function(house)
    OpenWardrobe(house)
end)

-- Cleanup stash reference when inventory closes
RegisterNetEvent('inventory:client:closed', function()
    currentStash = nil
end)

-- Exports
exports('GetCurrentStash', function()
    return currentStash
end)
