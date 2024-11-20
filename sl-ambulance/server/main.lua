local SLCore = exports['sl-core']:GetCoreObject()
local deadPlayers = {}

-- Death Status
RegisterNetEvent('sl-ambulance:server:SetDeathStatus', function(isDead)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    if isDead then
        deadPlayers[Player.PlayerData.citizenid] = true
    else
        deadPlayers[Player.PlayerData.citizenid] = nil
    end
end)

-- Revive
RegisterNetEvent('sl-ambulance:server:RevivePlayer', function(playerId)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    local Target = SLCore.Functions.GetPlayer(playerId)
    if not Player or not Target then return end
    
    if Player.PlayerData.job.name == "ambulance" and Player.PlayerData.job.onduty then
        TriggerClientEvent('sl-ambulance:client:Revive', Target.PlayerData.source)
        Player.Functions.AddMoney('bank', Config.ReviveReward, "ems-revive")
    end
end)

-- Wounds
RegisterNetEvent('sl-ambulance:server:SyncWounds', function(wounds)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Store wounds in database
    MySQL.Async.execute('UPDATE patient_records SET wounds = ? WHERE citizenid = ?',
        {json.encode(wounds), Player.PlayerData.citizenid})
end)

-- Patient Records
SLCore.Functions.CreateCallback('sl-ambulance:server:GetPatientRecord', function(source, cb, citizenid)
    local result = MySQL.Sync.fetchAll('SELECT * FROM patient_records WHERE citizenid = ?', {citizenid})
    if result[1] then
        cb(result[1])
    else
        cb(nil)
    end
end)

RegisterNetEvent('sl-ambulance:server:UpdatePatientRecord', function(citizenid, data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player or Player.PlayerData.job.name ~= "ambulance" then return end
    
    MySQL.Async.execute([[
        INSERT INTO patient_records (citizenid, blood_type, allergies, medications, notes, updated_by)
        VALUES (?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE
        blood_type = VALUES(blood_type),
        allergies = VALUES(allergies),
        medications = VALUES(medications),
        notes = VALUES(notes),
        updated_by = VALUES(updated_by)
    ]], {
        citizenid,
        data.blood_type,
        data.allergies,
        data.medications,
        data.notes,
        Player.PlayerData.citizenid
    })
end)

-- Exports
exports('IsPlayerDead', function(citizenid)
    return deadPlayers[citizenid] == true
end) 