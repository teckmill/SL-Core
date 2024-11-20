local SLCore = exports['sl-core']:GetCoreObject()
local currentEvidence = {}
local evidenceLoaded = false

-- Evidence Functions
function CreateEvidence(type, data)
    local coords = GetEntityCoords(PlayerPedId())
    local evidenceId = GenerateEvidenceId()
    
    currentEvidence[evidenceId] = {
        id = evidenceId,
        type = type,
        data = data,
        coords = coords,
        time = GetGameTimer()
    }
    
    TriggerServerEvent('sl-police:server:CreateEvidence', currentEvidence[evidenceId])
    return evidenceId
end

function CollectEvidence(evidenceId)
    if currentEvidence[evidenceId] then
        local evidence = currentEvidence[evidenceId]
        TriggerServerEvent('sl-police:server:CollectEvidence', evidence)
        currentEvidence[evidenceId] = nil
    end
end

function LoadEvidence()
    if evidenceLoaded then return end
    
    SLCore.Functions.TriggerCallback('sl-police:server:GetEvidence', function(evidence)
        currentEvidence = evidence
        evidenceLoaded = true
    end)
end

-- Evidence Types
local evidenceTypes = {
    ['blood'] = function(coords)
        CreateEvidence('blood', {
            coords = coords,
            sample = true
        })
    end,
    ['casing'] = function(coords, weapon)
        CreateEvidence('casing', {
            coords = coords,
            weapon = weapon
        })
    end,
    ['fingerprint'] = function(coords)
        CreateEvidence('fingerprint', {
            coords = coords,
            print = true
        })
    end
}

-- Events
RegisterNetEvent('sl-police:client:AddEvidence', function(type, data)
    if evidenceTypes[type] then
        evidenceTypes[type](data)
    end
end)

-- Exports
exports('CreateEvidence', CreateEvidence)
exports('CollectEvidence', CollectEvidence) 