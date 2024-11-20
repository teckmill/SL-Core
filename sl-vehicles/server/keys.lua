local SLCore = exports['sl-core']:GetCoreObject()
local VehicleKeys = {}

-- Load Keys
CreateThread(function()
    MySQL.ready(function()
        local result = MySQL.Sync.fetchAll('SELECT * FROM vehicle_keys')
        for _, key in ipairs(result) do
            VehicleKeys[key.plate] = key.citizenid
        end
    end)
end)

-- Save Key
RegisterNetEvent('sl-vehicles:server:SaveVehicleKey', function(plate)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    MySQL.Async.insert('INSERT INTO vehicle_keys (citizenid, plate) VALUES (?, ?)',
        {Player.PlayerData.citizenid, plate})
    
    VehicleKeys[plate] = Player.PlayerData.citizenid
end)

-- Remove Key
RegisterNetEvent('sl-vehicles:server:RemoveVehicleKey', function(plate)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    MySQL.Async.execute('DELETE FROM vehicle_keys WHERE plate = ? AND citizenid = ?',
        {plate, Player.PlayerData.citizenid})
    
    if VehicleKeys[plate] == Player.PlayerData.citizenid then
        VehicleKeys[plate] = nil
    end
end)

-- Give Keys
RegisterNetEvent('sl-vehicles:server:GiveKeys', function(target, plate)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    local TargetPlayer = SLCore.Functions.GetPlayer(target)
    
    if not Player or not TargetPlayer then return end
    if VehicleKeys[plate] ~= Player.PlayerData.citizenid then return end
    
    TriggerClientEvent('sl-vehicles:client:GiveKeys', target, plate)
end)

-- Check Keys
SLCore.Functions.CreateCallback('sl-vehicles:server:CheckVehicleOwner', function(source, cb, plate)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb(false) end
    
    cb(VehicleKeys[plate] == Player.PlayerData.citizenid)
end) 