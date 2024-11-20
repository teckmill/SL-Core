local SLCore = exports['sl-core']:GetCoreObject()

-- Spawn Vehicle Request
RegisterNetEvent('sl-vehicles:server:RequestVehicle', function(plate)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Check ownership
    local vehicle = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ?',
        {plate, Player.PlayerData.citizenid})[1]
    
    if vehicle then
        if vehicle.state == 1 then -- Vehicle is already spawned
            TriggerClientEvent('SLCore:Notify', src, 'Vehicle is already out!', 'error')
            return
        end
        
        -- Get vehicle data
        local coords = GetEntityCoords(GetPlayerPed(src))
        local props = json.decode(vehicle.mods)
        
        -- Spawn vehicle
        TriggerClientEvent('sl-vehicles:client:SpawnVehicle', src, {
            model = vehicle.vehicle,
            coords = coords,
            plate = plate,
            props = props
        })
        
        -- Update state
        MySQL.Async.execute('UPDATE player_vehicles SET state = 1, stored = NULL WHERE plate = ?', {plate})
    else
        TriggerClientEvent('SLCore:Notify', src, 'You don\'t own this vehicle!', 'error')
    end
end)

-- Store Vehicle Request
RegisterNetEvent('sl-vehicles:server:StoreVehicle', function(plate, garage)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Check ownership
    local vehicle = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ?',
        {plate, Player.PlayerData.citizenid})[1]
    
    if vehicle then
        -- Update state
        MySQL.Async.execute('UPDATE player_vehicles SET state = 0, stored = ? WHERE plate = ?', {garage, plate})
        
        -- Despawn vehicle
        TriggerClientEvent('sl-vehicles:client:DespawnVehicle', src, plate)
    end
end) 