local function loadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

local function PlayAnimation()
    loadAnimDict(Config.AnimDict)
    TaskPlayAnim(PlayerPedId(), Config.AnimDict, Config.AnimName, 4.0, -1, -1, 49, 0, false, false, false)
    Wait(Config.AnimTime)
    StopAnimTask(PlayerPedId(), Config.AnimDict, Config.AnimName, 1.0)
end

exports('PlayRadioAnimation', PlayAnimation)
