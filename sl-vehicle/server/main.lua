local SLCore = nil
local CoreReady = false

-- Register Server Callbacks
local function RegisterCallbacks()
    if not CoreReady then return end

    SLCore.Functions.CreateCallback('sl-vehicle:server:GetVehicles', function(source, cb)
        local Player = SLCore.Functions.GetPlayer(source)
        if not Player then return cb({}) end
        
        local result = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = ?', {
            Player.PlayerData.citizenid
        })
        cb(result)
    end)

    SLCore.Functions.CreateCallback('sl-vehicle:server:GetVehicleTuning', function(source, cb, plate)
        local result = MySQL.Sync.fetchSingle('SELECT * FROM vehicle_tuning WHERE plate = ?', {
            plate
        })
        cb(result)
    end)

    SLCore.Functions.CreateCallback('sl-vehicle:server:GetVehicleByPlate', function(source, cb, plate)
        cb(GetVehicleByPlate(plate))
    end)

    SLCore.Functions.CreateCallback('sl-vehicle:server:GetPlayerVehicles', function(source, cb)
        local Player = SLCore.Functions.GetPlayer(source)
        if Player then
            local vehicles = GetPlayerVehicles(Player.PlayerData.citizenid)
            cb(vehicles)
        else
            cb({})
        end
    end)

    SLCore.Functions.CreateCallback('sl-vehicle:server:GetVehicleLocation', function(source, cb, plate)
        local result = MySQL.Sync.fetchSingle('SELECT garage FROM player_vehicles WHERE plate = ?', {plate})
        if result then
            cb(result.garage)
        else
            cb(nil)
        end
    end)

    print('^2[SL-Vehicle] ^7Callbacks registered successfully')
end

-- Initialize Database
local function InitializeDatabase()
    if not CoreReady then 
        print('^1[SL-Vehicle] ^7Failed to initialize database: Core not ready')
        return 
    end

    MySQL.ready(function()
        MySQL.Sync.execute([[
            CREATE TABLE IF NOT EXISTS `player_vehicles` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `license` VARCHAR(50) NOT NULL,
                `citizenid` VARCHAR(50) NOT NULL,
                `vehicle` VARCHAR(50) NOT NULL,
                `hash` VARCHAR(50) NOT NULL,
                `mods` LONGTEXT,
                `plate` VARCHAR(15) NOT NULL,
                `fakeplate` VARCHAR(50) DEFAULT NULL,
                `garage` VARCHAR(50) DEFAULT NULL,
                `fuel` INT(11) DEFAULT 100,
                `engine` FLOAT DEFAULT 1000.0,
                `body` FLOAT DEFAULT 1000.0,
                `state` INT(11) DEFAULT 1,
                `stored` TINYINT(1) DEFAULT 0,
                `damage` LONGTEXT DEFAULT NULL,
                `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (`id`),
                UNIQUE KEY `plate` (`plate`),
                KEY `citizenid` (`citizenid`),
                KEY `license` (`license`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])

        MySQL.Sync.execute([[
            CREATE TABLE IF NOT EXISTS `vehicle_tuning` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `plate` VARCHAR(15) NOT NULL,
                `engine_level` INT(11) DEFAULT 0,
                `brake_level` INT(11) DEFAULT 0,
                `transmission_level` INT(11) DEFAULT 0,
                `suspension_level` INT(11) DEFAULT 0,
                `turbo_enabled` TINYINT(1) DEFAULT 0,
                `neon_enabled` TINYINT(1) DEFAULT 0,
                `neon_color` VARCHAR(50) DEFAULT NULL,
                `window_tint` INT(11) DEFAULT 0,
                `tire_smoke_color` VARCHAR(50) DEFAULT NULL,
                PRIMARY KEY (`id`),
                UNIQUE KEY `plate` (`plate`),
                CONSTRAINT `fk_tuning_vehicles` 
                FOREIGN KEY (`plate`) 
                REFERENCES `player_vehicles` (`plate`) 
                ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])

        MySQL.Sync.execute([[
            CREATE TABLE IF NOT EXISTS `vehicle_categories` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `name` VARCHAR(50) NOT NULL,
                `label` VARCHAR(50) NOT NULL,
                PRIMARY KEY (`id`),
                UNIQUE INDEX `name` (`name`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])

        MySQL.Sync.execute([[
            CREATE TABLE IF NOT EXISTS `vehicle_shops` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `name` VARCHAR(50) NOT NULL,
                `location` VARCHAR(50) NOT NULL,
                `inventory` LONGTEXT,
                PRIMARY KEY (`id`),
                UNIQUE INDEX `name` (`name`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])

        print('^2[SL-Vehicle] ^7Database tables initialized successfully')
    end)
end

-- Wait for core to be ready
CreateThread(function()
    while SLCore == nil do
        if GetResourceState('sl-core') == 'started' then
            SLCore = exports['sl-core']:GetCoreObject()
            if SLCore then
                CoreReady = true
                print('^2[SL-Vehicle] ^7Successfully connected to SL-Core')
                InitializeDatabase()
                RegisterCallbacks()
                break
            end
        end
        Wait(100)
    end
end)

-- Vehicle Functions
function GetVehicleByPlate(plate)
    if not CoreReady then return nil end
    
    local result = MySQL.Sync.fetchSingle('SELECT * FROM player_vehicles WHERE plate = ?', {
        plate
    })
    return result
end

function SaveVehicle(data)
    if not CoreReady then return false end
    
    if not data.license or not data.citizenid or not data.vehicle or not data.plate then
        return false
    end
    
    local success = MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate) VALUES (?, ?, ?, ?, ?, ?)', {
        data.license,
        data.citizenid,
        data.vehicle,
        data.hash,
        json.encode(data.mods or {}),
        data.plate
    })
    
    return success ~= nil
end

function UpdateVehicle(plate, data)
    if not CoreReady then return false end
    
    if not plate or not data then return false end
    
    local updates = {}
    local params = {}
    
    for key, value in pairs(data) do
        if key ~= 'plate' then -- Don't update plate
            table.insert(updates, string.format('%s = ?', key))
            if type(value) == 'table' then
                table.insert(params, json.encode(value))
            else
                table.insert(params, value)
            end
        end
    end
    
    if #updates == 0 then return false end
    
    table.insert(params, plate)
    local success = MySQL.update(string.format('UPDATE player_vehicles SET %s WHERE plate = ?', table.concat(updates, ', ')), params)
    
    return success ~= nil
end

-- Events
RegisterNetEvent('sl-vehicle:server:SaveVehicle', function(vehicleData)
    if not CoreReady then return end
    
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    vehicleData.license = Player.PlayerData.license
    vehicleData.citizenid = Player.PlayerData.citizenid
    
    local success = SaveVehicle(vehicleData)
    if success then
        TriggerClientEvent('SLCore:Notify', src, 'Vehicle saved successfully', 'success')
    else
        TriggerClientEvent('SLCore:Notify', src, 'Failed to save vehicle', 'error')
    end
end)

RegisterNetEvent('sl-vehicle:server:UpdateVehicle', function(plate, vehicleData)
    if not CoreReady then return end
    
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local vehicle = GetVehicleByPlate(plate)
    if not vehicle or vehicle.citizenid ~= Player.PlayerData.citizenid then
        TriggerClientEvent('SLCore:Notify', src, 'You do not own this vehicle', 'error')
        return
    end
    
    local success = UpdateVehicle(plate, vehicleData)
    if success then
        TriggerClientEvent('SLCore:Notify', src, 'Vehicle updated successfully', 'success')
    else
        TriggerClientEvent('SLCore:Notify', src, 'Failed to update vehicle', 'error')
    end
end)

RegisterNetEvent('sl-vehicle:server:UpdateVehicleState', function(plate, state)
    if not CoreReady then return end
    
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end

    MySQL.update('UPDATE player_vehicles SET state = ? WHERE plate = ? AND citizenid = ?', {
        state,
        plate,
        Player.PlayerData.citizenid
    })
end)

-- Exports
exports('GetVehicleByPlate', GetVehicleByPlate)
exports('SaveVehicle', SaveVehicle)
exports('UpdateVehicle', UpdateVehicle)
