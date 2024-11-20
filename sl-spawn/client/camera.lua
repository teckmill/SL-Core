local cam = nil
local startedTransition = false
local transitioning = false

local function StartCam()
    local coords = Config.StartingCam
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cam, coords.x, coords.y, coords.z)
    SetCamRot(cam, -10.0, 0.0, coords.w)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, true)
    DisplayRadar(false)
end

local function EndCam()
    if cam then
        RenderScriptCams(false, true, 500, true, true)
        NetworkSetInSpectatorMode(false, PlayerPedId())
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        cam = nil
        DisplayRadar(true)
    end
end

local function SetCamFocus(coords, instant)
    if not cam then return end
    
    transitioning = true
    local camCoords = GetCamCoord(cam)
    local distance = Config.CameraHeight
    local focusCoords = vector3(coords.x, coords.y, coords.z + distance)
    local timing = instant and 1 or math.floor(1000 * Config.CameraTransitionSpeed)

    if instant then
        SetCamCoord(cam, focusCoords.x, focusCoords.y, focusCoords.z)
        PointCamAtCoord(cam, coords.x, coords.y, coords.z)
        transitioning = false
        return
    end

    local steps = timing / 16 -- 16ms per frame
    local currentStep = 0
    local stepX = (focusCoords.x - camCoords.x) / steps
    local stepY = (focusCoords.y - camCoords.y) / steps
    local stepZ = (focusCoords.z - camCoords.z) / steps

    CreateThread(function()
        while currentStep < steps do
            currentStep = currentStep + 1
            local newX = camCoords.x + (stepX * currentStep)
            local newY = camCoords.y + (stepY * currentStep)
            local newZ = camCoords.z + (stepZ * currentStep)
            
            SetCamCoord(cam, newX, newY, newZ)
            PointCamAtCoord(cam, coords.x, coords.y, coords.z)
            Wait(16)
        end
        transitioning = false
    end)
end

local function TransitionToSpawn(coords)
    if startedTransition then return end
    startedTransition = true

    local targetCoords = vector3(coords.x, coords.y, coords.z + 15.0)
    SetCamFocus(targetCoords, false)
    
    Wait(1000)
    
    DoScreenFadeOut(500)
    Wait(500)
    
    EndCam()
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
    SetEntityHeading(PlayerPedId(), coords.w)
    
    Wait(500)
    DoScreenFadeIn(500)
    startedTransition = false
end

-- Exports
exports('StartCam', StartCam)
exports('EndCam', EndCam)
exports('SetCamFocus', SetCamFocus)
exports('TransitionToSpawn', TransitionToSpawn)
exports('IsCamTransitioning', function() return transitioning end)
