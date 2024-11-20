local SLCore = exports['sl-core']:GetCoreObject()

-- Wound Management
RegisterNetEvent('sl-ambulance:server:AddWound', function(type, bone)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Log wound
    MySQL.Async.execute('INSERT INTO ambulance_reports (citizenid, title, description, wounds) VALUES (?, ?, ?, ?)',
        {Player.PlayerData.citizenid, "Injury Report", "Automatic injury report", json.encode({type = type, bone = bone})})
end)

-- Treatment
RegisterNetEvent('sl-ambulance:server:TreatWound', function(targetId, woundIndex)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    local Target = SLCore.Functions.GetPlayer(targetId)
    if not Player or not Target then return end
    
    if Player.PlayerData.job.name == "ambulance" and Player.PlayerData.job.onduty then
        TriggerClientEvent('sl-ambulance:client:TreatWound', Target.PlayerData.source, woundIndex)
    end
end)

-- Callbacks
SLCore.Functions.CreateCallback('sl-ambulance:server:GetWounds', function(source, cb, citizenid)
    local result = MySQL.Sync.fetchAll('SELECT wounds FROM patient_records WHERE citizenid = ?', {citizenid})
    if result[1] and result[1].wounds then
        cb(json.decode(result[1].wounds))
    else
        cb({})
    end
end) 