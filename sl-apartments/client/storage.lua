local SLCore = exports['sl-core']:GetCoreObject()
local currentStorage = nil

-- Storage Management
function OpenStorage(apartment)
    if not apartment then return end
    
    local apartmentData = Config.Locations[apartment]
    if not apartmentData then return end
    
    local storageSize = Config.StorageSize[apartmentData.interiors[1].label] or 100
    
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "apartment_"..apartment, {
        maxweight = storageSize * 1000,
        slots = storageSize,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "apartment_"..apartment)
    currentStorage = apartment
end

function CloseStorage()
    currentStorage = nil
end

-- Events
RegisterNetEvent('sl-apartments:client:OpenStorage', function(apartment)
    OpenStorage(apartment)
end)

RegisterNetEvent('sl-apartments:client:CloseStorage', function()
    CloseStorage()
end)

-- Export functions
exports('OpenStorage', OpenStorage)
exports('CloseStorage', CloseStorage)
exports('GetCurrentStorage', function() return currentStorage end)
