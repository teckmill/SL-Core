local SLCore = nil
local CoreReady = false

-- Wait for core to be ready
CreateThread(function()
    while SLCore == nil do
        if GetResourceState('sl-core') == 'started' then
            SLCore = exports['sl-core']:GetCoreObject()
            if SLCore then
                CoreReady = true
                print('^2[SL-Housing:Interactions] ^7Successfully connected to SL-Core')
                break
            end
        end
        Wait(100)
    end
end)

-- House Interaction Functions
local function ToggleDoorLock(house)
    if not CoreReady then return false end
    
    local success = MySQL.Sync.execute('UPDATE player_houses SET locked = NOT locked WHERE house = ?', {house})
    return success > 0
end

local function AddKeyholder(house, citizenid)
    if not CoreReady then return false end
    
    local result = MySQL.Sync.fetchAll('SELECT keyholders FROM player_houses WHERE house = ?', {house})
    if not result[1] then return false end
    
    local keyholders = json.decode(result[1].keyholders or '[]')
    if not table.contains(keyholders, citizenid) then
        table.insert(keyholders, citizenid)
        local success = MySQL.Sync.execute('UPDATE player_houses SET keyholders = ? WHERE house = ?', {
            json.encode(keyholders),
            house
        })
        return success > 0
    end
    return false
end

local function RemoveKeyholder(house, citizenid)
    if not CoreReady then return false end
    
    local result = MySQL.Sync.fetchAll('SELECT keyholders FROM player_houses WHERE house = ?', {house})
    if not result[1] then return false end
    
    local keyholders = json.decode(result[1].keyholders or '[]')
    for i, id in ipairs(keyholders) do
        if id == citizenid then
            table.remove(keyholders, i)
            local success = MySQL.Sync.execute('UPDATE player_houses SET keyholders = ? WHERE house = ?', {
                json.encode(keyholders),
                house
            })
            return success > 0
        end
    end
    return false
end

-- Events
RegisterNetEvent('sl-housing:server:toggleDoorLock', function(house)
    if not CoreReady then return end
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    if ToggleDoorLock(house) then
        local houseData = exports['sl-housing']:GetHouse(house)
        TriggerClientEvent('sl-housing:client:updateDoorLock', -1, house, not houseData.locked)
    end
end)

RegisterNetEvent('sl-housing:server:giveKeys', function(house, target)
    if not CoreReady then return end
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    local TargetPlayer = SLCore.Functions.GetPlayer(target)
    if not Player or not TargetPlayer then return end
    
    if AddKeyholder(house, TargetPlayer.PlayerData.citizenid) then
        TriggerClientEvent('sl-core:client:notify', src, 'Keys given to ' .. TargetPlayer.PlayerData.charinfo.firstname, 'success')
        TriggerClientEvent('sl-core:client:notify', target, 'Received keys to a house', 'success')
    end
end)

-- Exports
exports('ToggleDoorLock', ToggleDoorLock)
exports('AddKeyholder', AddKeyholder)
exports('RemoveKeyholder', RemoveKeyholder)
