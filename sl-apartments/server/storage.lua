local SLCore = exports['sl-core']:GetCoreObject()

-- Core Ready Check
local CoreReady = false
AddEventHandler('SLCore:Server:OnCoreReady', function()
    CoreReady = true
end)

-- Storage Management
RegisterNetEvent('sl-apartments:server:SaveStorage', function(apartment, items)
    if not CoreReady then return end
    
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Check if player owns this apartment
    local owned = MySQL.Sync.fetchAll('SELECT * FROM player_apartments WHERE citizenid = ? AND apartment = ?',
        {Player.PlayerData.citizenid, apartment})
    
    if #owned == 0 then
        TriggerClientEvent('SLCore:Notify', src, 'You don\'t own this apartment', 'error')
        return
    end
    
    -- Save storage items
    MySQL.Async.execute('UPDATE player_apartments SET storage = ? WHERE citizenid = ? AND apartment = ?',
        {json.encode(items), Player.PlayerData.citizenid, apartment})
end)

RegisterNetEvent('sl-apartments:server:GetStorage', function(apartment)
    if not CoreReady then return end
    
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Check if player owns this apartment
    local owned = MySQL.Sync.fetchAll('SELECT * FROM player_apartments WHERE citizenid = ? AND apartment = ?',
        {Player.PlayerData.citizenid, apartment})
    
    if #owned == 0 then
        TriggerClientEvent('SLCore:Notify', src, 'You don\'t own this apartment', 'error')
        return
    end
    
    -- Get storage items
    local items = json.decode(owned[1].storage or '[]')
    TriggerClientEvent('sl-apartments:client:SetStorage', src, items)
end)

-- Initialize
CreateThread(function()
    Wait(1000)
    -- Add storage column if it doesn't exist
    MySQL.Async.execute([[
        ALTER TABLE player_apartments
        ADD COLUMN IF NOT EXISTS storage TEXT DEFAULT '[]'
    ]])
end)
