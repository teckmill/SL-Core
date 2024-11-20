local SLCore = exports['sl-core']:GetCoreObject()
local Evidence = {}

-- Evidence Functions
RegisterNetEvent('sl-police:server:CreateEvidence', function(evidence)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    Evidence[evidence.id] = evidence
    TriggerClientEvent('sl-police:client:SyncEvidence', -1, Evidence)
end)

RegisterNetEvent('sl-police:server:CollectEvidence', function(evidence)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    if Evidence[evidence.id] then
        MySQL.Async.insert('INSERT INTO police_evidence (identifier, type, description, evidence) VALUES (?, ?, ?, ?)',
            {evidence.id, evidence.type, evidence.description or '', json.encode(evidence.data)})
        
        Evidence[evidence.id] = nil
        TriggerClientEvent('sl-police:client:SyncEvidence', -1, Evidence)
    end
end)

-- Evidence Callbacks
SLCore.Functions.CreateCallback('sl-police:server:GetEvidence', function(source, cb)
    cb(Evidence)
end)

-- Evidence Cleanup
CreateThread(function()
    while true do
        Wait(300000) -- 5 minutes
        for id, evidence in pairs(Evidence) do
            if (GetGameTimer() - evidence.time) > (Config.Evidence[evidence.type].expire * 86400000) then
                Evidence[id] = nil
            end
        end
        TriggerClientEvent('sl-police:client:SyncEvidence', -1, Evidence)
    end
end) 