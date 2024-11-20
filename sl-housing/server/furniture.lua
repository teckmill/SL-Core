local SLCore = nil
local CoreReady = false

-- Wait for core to be ready
CreateThread(function()
    while SLCore == nil do
        if GetResourceState('sl-core') == 'started' then
            SLCore = exports['sl-core']:GetCoreObject()
            if SLCore then
                CoreReady = true
                print('^2[SL-Housing:Furniture] ^7Successfully connected to SL-Core')
                break
            end
        end
        Wait(100)
    end
end)

-- Furniture Management Functions
local function UpdateFurniture(house, furniture)
    if not CoreReady then return false end
    
    local success = MySQL.Sync.execute('UPDATE player_houses SET furniture = ? WHERE house = ?', {
        json.encode(furniture),
        house
    })
    
    return success > 0
end

local function GetFurniture(house)
    if not CoreReady then return {} end
    
    local result = MySQL.Sync.fetchScalar('SELECT furniture FROM player_houses WHERE house = ?', {house})
    return result and json.decode(result) or {}
end

-- Events
RegisterNetEvent('sl-housing:server:placeFurniture', function(house, item, position, rotation)
    if not CoreReady then return end
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local furniture = GetFurniture(house)
    table.insert(furniture, {
        item = item,
        position = position,
        rotation = rotation
    })
    
    if UpdateFurniture(house, furniture) then
        TriggerClientEvent('sl-housing:client:updateFurniture', -1, house, furniture)
    end
end)

RegisterNetEvent('sl-housing:server:removeFurniture', function(house, index)
    if not CoreReady then return end
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local furniture = GetFurniture(house)
    if furniture[index] then
        table.remove(furniture, index)
        if UpdateFurniture(house, furniture) then
            TriggerClientEvent('sl-housing:client:updateFurniture', -1, house, furniture)
        end
    end
end)

-- Exports
exports('GetFurniture', GetFurniture)
exports('UpdateFurniture', UpdateFurniture)
