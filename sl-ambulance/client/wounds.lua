local SLCore = exports['sl-core']:GetCoreObject()
local currentWounds = {}

-- Wound Functions
function AddWound(type, bone)
    local wound = Config.WoundTypes[type]
    if not wound then return end
    
    currentWounds[#currentWounds + 1] = {
        type = type,
        bone = bone,
        time = wound.time,
        treated = false
    }
    
    TriggerServerEvent('sl-ambulance:server:SyncWounds', currentWounds)
end

function TreatWound(index)
    local wound = currentWounds[index]
    if not wound or wound.treated then return end
    
    local woundConfig = Config.WoundTypes[wound.type]
    if not woundConfig then return end
    
    -- Check for required item
    if not SLCore.Functions.HasItem(woundConfig.item) then
        SLCore.Functions.Notify("You need a " .. woundConfig.item .. " to treat this wound!", "error")
        return
    end
    
    -- Play animation
    local ped = PlayerPedId()
    if woundConfig.anim then
        SLCore.Functions.RequestAnimDict(woundConfig.anim)
        TaskPlayAnim(ped, woundConfig.anim, "base", 3.0, 3.0, -1, 1, 0, false, false, false)
    end
    
    SLCore.Functions.Progressbar("treat_wound", "Treating " .. woundConfig.label, woundConfig.time * 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        wound.treated = true
        TriggerServerEvent('sl-ambulance:server:SyncWounds', currentWounds)
        SLCore.Functions.Notify("Successfully treated wound!", "success")
        ClearPedTasks(ped)
    end)
end

-- Events
RegisterNetEvent('sl-ambulance:client:SyncWounds', function(wounds)
    currentWounds = wounds
end)

RegisterNetEvent('sl-ambulance:client:TreatWound', function(index)
    TreatWound(index)
end)

-- Exports
exports('GetWounds', function()
    return currentWounds
end)

exports('AddWound', AddWound) 