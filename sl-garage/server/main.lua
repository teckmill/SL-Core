local SLCore = exports['sl-core']:GetCoreObject()

-- Get Garage Vehicles
SLCore.Functions.CreateCallback('sl-garage:server:GetGarageVehicles', function(source, cb, garage)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end
    
    local vehicles = MySQL.Sync.fetchAll([[
        SELECT v.*, g.garage, g.stored, g.impounded, g.impound_fee, g.parking_fee 
        FROM player_vehicles v 
        LEFT JOIN player_garages g ON v.plate = g.plate 
        WHERE v.citizenid = ? AND (g.garage = ? OR g.garage IS NULL)
    ]], {Player.PlayerData.citizenid, garage})
    
    cb(vehicles)
end)

-- Store Vehicle
RegisterNetEvent('sl-garage:server:StoreVehicle', function(garage, plate)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Check vehicle ownership
    local vehicle = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ?',
        {plate, Player.PlayerData.citizenid})[1]
    
    if vehicle then
        -- Calculate parking fee if applicable
        local parkingFee = 0
        local garageType = Config.GarageTypes[Config.Garages[garage].type]
        if garageType.storageFee > 0 then
            parkingFee = garageType.storageFee
            if not Player.Functions.RemoveMoney('bank', parkingFee, 'garage-parking-fee') then
                TriggerClientEvent('SLCore:Notify', src, 'You cannot afford the parking fee!', 'error')
                return
            end
        end
        
        -- Store vehicle
        MySQL.Async.execute([[
            INSERT INTO player_garages (citizenid, garage, plate, stored, parking_fee)
            VALUES (?, ?, ?, 1, ?)
            ON DUPLICATE KEY UPDATE 
            garage = VALUES(garage),
            stored = VALUES(stored),
            parking_fee = VALUES(parking_fee)
        ]], {Player.PlayerData.citizenid, garage, plate, parkingFee})
        
        TriggerClientEvent('SLCore:Notify', src, 'Vehicle stored!', 'success')
    else
        TriggerClientEvent('SLCore:Notify', src, 'You don\'t own this vehicle!', 'error')
    end
end)

-- Spawn Vehicle
RegisterNetEvent('sl-garage:server:SpawnVehicle', function(plate, coords)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Check vehicle status
    local vehicle = MySQL.Sync.fetchAll([[
        SELECT v.*, g.garage, g.stored, g.impounded, g.impound_fee 
        FROM player_vehicles v 
        LEFT JOIN player_garages g ON v.plate = g.plate 
        WHERE v.plate = ? AND v.citizenid = ?
    ]], {plate, Player.PlayerData.citizenid})[1]
    
    if vehicle then
        if vehicle.impounded == 1 then
            TriggerClientEvent('SLCore:Notify', src, 'This vehicle is impounded!', 'error')
            return
        end
        
        -- Handle spawn fee
        local garageType = Config.GarageTypes[Config.Garages[vehicle.garage].type]
        if garageType.spawnFee > 0 then
            if not Player.Functions.RemoveMoney('bank', garageType.spawnFee, 'garage-spawn-fee') then
                TriggerClientEvent('SLCore:Notify', src, 'You cannot afford the spawn fee!', 'error')
                return
            end
        end
        
        -- Update vehicle status
        MySQL.Async.execute('UPDATE player_garages SET stored = 0 WHERE plate = ?', {plate})
        
        -- Trigger vehicle spawn on client
        TriggerClientEvent('sl-vehicles:client:SpawnVehicle', src, {
            model = vehicle.vehicle,
            plate = plate,
            coords = coords,
            props = json.decode(vehicle.mods)
        })
        
        TriggerClientEvent('SLCore:Notify', src, 'Vehicle retrieved!', 'success')
    else
        TriggerClientEvent('SLCore:Notify', src, 'Vehicle not found!', 'error')
    end
end)

-- Impound Vehicle
RegisterNetEvent('sl-garage:server:ImpoundVehicle', function(plate, fee)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Check job permission
    if not Player.PlayerData.job.name == 'police' and not Player.PlayerData.job.name == 'mechanic' then
        return
    end
    
    MySQL.Async.execute([[
        UPDATE player_garages 
        SET stored = 1, impounded = 1, impound_fee = ?, garage = 'impound'
        WHERE plate = ?
    ]], {fee, plate})
    
    TriggerClientEvent('SLCore:Notify', src, 'Vehicle impounded!', 'success')
end)

-- Initialize
CreateThread(function()
    MySQL.ready(function()
        -- Create tables if they don't exist
        MySQL.Sync.execute(LoadResourceFile(GetCurrentResourceName(), 'sql/garages.sql'))
    end)
end) 