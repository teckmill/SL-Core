local SLCore = exports['sl-core']:GetCoreObject()
local OwnedVehicles = {}

-- Load Owned Vehicles
CreateThread(function()
    MySQL.ready(function()
        local result = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles')
        for _, vehicle in ipairs(result) do
            OwnedVehicles[vehicle.plate] = {
                owner = vehicle.citizenid,
                vehicle = vehicle.vehicle,
                stored = vehicle.stored,
                state = vehicle.state
            }
        end
    end)
end)

-- Vehicle Ownership Functions
local function AddVehicleOwnership(source, plate, vehicle, props)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    -- Check vehicle limit
    local count = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM player_vehicles WHERE citizenid = ?', 
        {Player.PlayerData.citizenid})
    
    if count >= Config.MaxVehicles then
        TriggerClientEvent('SLCore:Notify', source, 'You cannot own more vehicles!', 'error')
        return false
    end
    
    -- Add vehicle to database
    local success = MySQL.Sync.insert('INSERT INTO player_vehicles (citizenid, plate, vehicle, hash, mods) VALUES (?, ?, ?, ?, ?)',
        {Player.PlayerData.citizenid, plate, vehicle, GetHashKey(vehicle), json.encode(props)})
    
    if success then
        OwnedVehicles[plate] = {
            owner = Player.PlayerData.citizenid,
            vehicle = vehicle,
            stored = 'garage',
            state = 1
        }
        
        -- Give keys to owner
        TriggerClientEvent('sl-vehicles:client:GiveKeys', source, plate)
        return true
    end
    
    return false
end

-- Server Callbacks
SLCore.Functions.CreateCallback('sl-vehicles:server:GetOwnedVehicles', function(source, cb)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end
    
    local vehicles = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = ?',
        {Player.PlayerData.citizenid})
    cb(vehicles)
end)

SLCore.Functions.CreateCallback('sl-vehicles:server:IsVehicleOwned', function(source, cb, plate)
    cb(OwnedVehicles[plate] ~= nil)
end)

-- Events
RegisterNetEvent('sl-vehicles:server:SaveVehicle', function(plate, props)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    if OwnedVehicles[plate] and OwnedVehicles[plate].owner == Player.PlayerData.citizenid then
        MySQL.Async.execute('UPDATE player_vehicles SET mods = ?, damage = ?, fuel = ? WHERE plate = ?',
            {json.encode(props.mods), json.encode(props.damage), props.fuel, plate})
    end
end)

RegisterNetEvent('sl-vehicles:server:SetVehicleState', function(plate, state, stored)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    if OwnedVehicles[plate] and OwnedVehicles[plate].owner == Player.PlayerData.citizenid then
        MySQL.Async.execute('UPDATE player_vehicles SET state = ?, stored = ? WHERE plate = ?',
            {state, stored, plate})
        
        OwnedVehicles[plate].state = state
        OwnedVehicles[plate].stored = stored
    end
end)

-- Exports
exports('AddVehicleOwnership', AddVehicleOwnership)
exports('GetVehicleOwner', function(plate)
    return OwnedVehicles[plate] and OwnedVehicles[plate].owner or nil
end) 