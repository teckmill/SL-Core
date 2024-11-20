local SLCore = nil
local CoreReady = false

-- Initialize core
CreateThread(function()
    while SLCore == nil do
        if GetResourceState('sl-core') == 'started' then
            SLCore = exports['sl-core']:GetCoreObject()
            if SLCore then
                CoreReady = true
                break
            end
        end
        Wait(100)
    end
end)

-- Tuning data tables
local VehicleMods = {}
local TuningHistory = {}

-- Tuning Functions
local function SaveVehicleMods(plate, mods)
    if not CoreReady then return false end
    
    MySQL.insert('INSERT INTO vehicle_mods (plate, mods, last_modified) VALUES (?, ?, NOW()) ON DUPLICATE KEY UPDATE mods = ?, last_modified = NOW()',
        {plate, json.encode(mods), json.encode(mods)},
        function(id)
            if id then
                VehicleMods[plate] = mods
                return true
            end
            return false
        end
    )
end

local function GetVehicleMods(plate)
    if not CoreReady then return nil end
    
    if VehicleMods[plate] then
        return VehicleMods[plate]
    end
    
    local result = MySQL.single.await('SELECT mods FROM vehicle_mods WHERE plate = ?', {plate})
    if result and result.mods then
        VehicleMods[plate] = json.decode(result.mods)
        return VehicleMods[plate]
    end
    
    return nil
end

-- Events
RegisterNetEvent('sl-vehicle:server:SaveMods', function(plate, mods)
    local source = source
    local Player = SLCore.Functions.GetPlayer(source)
    
    if Player then
        local success = SaveVehicleMods(plate, mods)
        if success then
            TriggerClientEvent('sl-vehicle:client:ModsSaved', source, plate)
        end
    end
end)

RegisterNetEvent('sl-vehicle:server:GetMods', function(plate)
    local source = source
    local Player = SLCore.Functions.GetPlayer(source)
    
    if Player then
        local mods = GetVehicleMods(plate)
        if mods then
            TriggerClientEvent('sl-vehicle:client:ReceivedMods', source, plate, mods)
        end
    end
end)

-- Exports
exports('GetVehicleMods', function(plate)
    return GetVehicleMods(plate)
end)

exports('SaveVehicleMods', function(plate, mods)
    return SaveVehicleMods(plate, mods)
end)
