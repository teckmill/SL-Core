local SLCore = exports['sl-core']:GetCoreObject()
local isFingerprinting = false

-- Function to take fingerprints
local function takeFingerprint(targetId)
    if not IsPoliceJob() then return end
    if isFingerprinting then return end
    
    local player = GetPlayerFromServerId(targetId)
    if not player then return end
    
    isFingerprinting = true
    local ped = PlayerPedId()
    local targetPed = GetPlayerPed(player)
    
    -- Animation
    loadAnimDict("mp_arresting")
    TaskPlayAnim(ped, "mp_arresting", "a_uncuff", 8.0, -8, -1, 49, 0, 0, 0, 0)
    
    SLCore.Functions.Progressbar("taking_fingerprints", Lang:t('info.taking_fingerprint'), 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        isFingerprinting = false
        ClearPedTasks(ped)
        TriggerServerEvent('sl-police:server:TakeFingerprint', targetId)
    end, function() -- Cancel
        isFingerprinting = false
        ClearPedTasks(ped)
        SLCore.Functions.Notify(Lang:t('error.canceled'), 'error')
    end)
end

-- Function to show fingerprint results
RegisterNetEvent('sl-police:client:ShowFingerprint', function(fingerprintData)
    if not IsPoliceJob() then return end
    
    SendNUIMessage({
        type = "showFingerprint",
        data = fingerprintData
    })
    SetNuiFocus(true, true)
end)

-- NUI Callbacks
RegisterNUICallback('closeFingerprint', function()
    SetNuiFocus(false, false)
end)

-- Export functions
exports('TakeFingerprint', takeFingerprint)
exports('IsFingerprinting', function() return isFingerprinting end)
