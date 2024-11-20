local SLCore = exports['sl-core']:GetCoreObject()

-- Interaction Functions
local function KnockOnDoor(house)
    if not house then return end
    
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)
    
    -- Play knock sound
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'knock', 0.4)
    
    -- Notify house owner
    TriggerServerEvent('sl-housing:server:NotifyOwner', house.id, 'knock')
    
    Wait(3000)
    ClearPedTasks(ped)
end

local function RaidHouse(house)
    if not house then return end
    
    -- Check if player is police
    SLCore.Functions.TriggerCallback('sl-housing:server:IsPolice', function(isPolice)
        if not isPolice then
            SLCore.Functions.Notify(Lang:t('error.not_police'), 'error')
            return
        end
        
        local ped = PlayerPedId()
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)
        
        SLCore.Functions.Progressbar("raid_house", Lang:t('info.raiding'), 10000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            ClearPedTasks(ped)
            TriggerServerEvent('sl-housing:server:RaidHouse', house.id)
        end, function() -- Cancel
            ClearPedTasks(ped)
        end)
    end)
end

local function LockHouse(house)
    if not house then return end
    
    -- Check if player has keys
    SLCore.Functions.TriggerCallback('sl-housing:server:HasKeys', function(hasKeys)
        if not hasKeys then
            SLCore.Functions.Notify(Lang:t('error.no_keys'), 'error')
            return
        end
        
        TriggerServerEvent('sl-housing:server:ToggleDoorLock', house.id)
    end, house.id)
end

local function GiveKeys(house, targetId)
    if not house then return end
    
    -- Check if player is owner
    SLCore.Functions.TriggerCallback('sl-housing:server:IsOwner', function(isOwner)
        if not isOwner then
            SLCore.Functions.Notify(Lang:t('error.not_owner'), 'error')
            return
        end
        
        TriggerServerEvent('sl-housing:server:GiveKeys', house.id, targetId)
    end, house.id)
end

local function RemoveKeys(house, targetId)
    if not house then return end
    
    -- Check if player is owner
    SLCore.Functions.TriggerCallback('sl-housing:server:IsOwner', function(isOwner)
        if not isOwner then
            SLCore.Functions.Notify(Lang:t('error.not_owner'), 'error')
            return
        end
        
        TriggerServerEvent('sl-housing:server:RemoveKeys', house.id, targetId)
    end, house.id)
end

local function OpenStorage(house)
    if not house then return end
    
    -- Check if player has access
    SLCore.Functions.TriggerCallback('sl-housing:server:HasAccess', function(hasAccess)
        if not hasAccess then
            SLCore.Functions.Notify(Lang:t('error.no_access'), 'error')
            return
        end
        
        TriggerServerEvent('inventory:server:OpenInventory', 'house', house.id)
    end, house.id)
end

local function OpenWardrobe(house)
    if not house then return end
    
    -- Check if player has access
    SLCore.Functions.TriggerCallback('sl-housing:server:HasAccess', function(hasAccess)
        if not hasAccess then
            SLCore.Functions.Notify(Lang:t('error.no_access'), 'error')
            return
        end
        
        TriggerEvent('sl-clothing:client:openOutfitMenu')
    end, house.id)
end

-- Events
RegisterNetEvent('sl-housing:client:KnockOnDoor', function(house)
    KnockOnDoor(house)
end)

RegisterNetEvent('sl-housing:client:RaidHouse', function(house)
    RaidHouse(house)
end)

RegisterNetEvent('sl-housing:client:LockHouse', function(house)
    LockHouse(house)
end)

RegisterNetEvent('sl-housing:client:GiveKeys', function(house, targetId)
    GiveKeys(house, targetId)
end)

RegisterNetEvent('sl-housing:client:RemoveKeys', function(house, targetId)
    RemoveKeys(house, targetId)
end)

RegisterNetEvent('sl-housing:client:OpenStorage', function(house)
    OpenStorage(house)
end)

RegisterNetEvent('sl-housing:client:OpenWardrobe', function(house)
    OpenWardrobe(house)
end)

-- Exports
exports('KnockOnDoor', KnockOnDoor)
exports('RaidHouse', RaidHouse)
exports('LockHouse', LockHouse)
exports('GiveKeys', GiveKeys)
exports('RemoveKeys', RemoveKeys)
exports('OpenStorage', OpenStorage)
exports('OpenWardrobe', OpenWardrobe)
