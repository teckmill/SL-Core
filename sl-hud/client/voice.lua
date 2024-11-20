local SLCore = exports['sl-core']:GetCoreObject()

-- Voice Variables
local voiceLevel = 2 -- Normal speaking distance
local voiceLevels = {
    [1] = { name = "Whisper", range = 2.0 },
    [2] = { name = "Normal", range = 5.0 },
    [3] = { name = "Shouting", range = 12.0 }
}

-- Voice State
local isTalking = false
local voiceTarget = 1

-- Update Voice UI
local function UpdateVoiceUI()
    SendNUIMessage({
        action = "updateVoice",
        isTalking = isTalking,
        voiceLevel = voiceLevel,
        voiceLevelName = voiceLevels[voiceLevel].name
    })
end

-- Voice Level Cycling
RegisterCommand('+cycleproximity', function()
    voiceLevel = voiceLevel + 1
    if voiceLevel > #voiceLevels then voiceLevel = 1 end
    
    TriggerEvent("sl-hud:client:ProximityChanged", voiceLevels[voiceLevel].range)
    UpdateVoiceUI()
end, false)

RegisterKeyMapping('+cycleproximity', 'Cycle Voice Distance', 'keyboard', 'z')

-- Talking State
CreateThread(function()
    while true do
        Wait(200)
        if NetworkIsPlayerTalking(PlayerId()) ~= isTalking then
            isTalking = NetworkIsPlayerTalking(PlayerId())
            UpdateVoiceUI()
        end
    end
end)

-- Initialize Voice UI
CreateThread(function()
    Wait(1000)
    UpdateVoiceUI()
end)
