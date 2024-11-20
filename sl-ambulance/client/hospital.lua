local SLCore = exports['sl-core']:GetCoreObject()
local currentBed = nil
local bedCam = nil

-- Hospital Functions
function AdmitToBed(bedId)
    local ped = PlayerPedId()
    local bedData = GetBedById(bedId)
    if not bedData then return end
    
    currentBed = bedId
    
    -- Set ped position
    SetEntityCoords(ped, bedData.coords.x, bedData.coords.y, bedData.coords.z)
    SetEntityHeading(ped, bedData.coords.w)
    
    -- Play animation
    RequestAnimDict("anim@gangops@morgue@table@")
    while not HasAnimDictLoaded("anim@gangops@morgue@table@") do Wait(0) end
    TaskPlayAnim(ped, "anim@gangops@morgue@table@", "ko_front", 8.0, -8.0, -1, 1, 0, false, false, false)
    
    -- Create camera
    CreateBedCam()
    
    TriggerServerEvent('sl-ambulance:server:SetBedData', bedId, true)
end

function LeaveBed()
    if not currentBed then return end
    
    local ped = PlayerPedId()
    local bedData = GetBedById(currentBed)
    
    -- Clear animation
    ClearPedTasks(ped)
    
    -- Set ped position
    local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, 0.0)
    SetEntityCoords(ped, offset.x, offset.y, offset.z)
    
    -- Destroy camera
    if bedCam then
        DestroyCam(bedCam, true)
        RenderScriptCams(false, false, 1, true, true)
        bedCam = nil
    end
    
    TriggerServerEvent('sl-ambulance:server:SetBedData', currentBed, false)
    currentBed = nil
end

function CreateBedCam()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    bedCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(bedCam, coords.x + 1.0, coords.y, coords.z + 1.0)
    SetCamRot(bedCam, -30.0, 0.0, GetEntityHeading(ped) + 90.0)
    SetCamActive(bedCam, true)
    RenderScriptCams(true, false, 1, true, true)
end

function GetBedById(bedId)
    for k, v in pairs(Config.Hospitals) do
        for i, bed in ipairs(v.beds) do
            if i == bedId then
                return bed
            end
        end
    end
    return nil
end

-- Events
RegisterNetEvent('sl-ambulance:client:UseBed', function(bedId)
    AdmitToBed(bedId)
end)

RegisterNetEvent('sl-ambulance:client:LeaveBed', function()
    LeaveBed()
end)

-- Key Controls
CreateThread(function()
    while true do
        Wait(0)
        if currentBed then
            if IsControlJustPressed(0, 38) then -- E key
                LeaveBed()
            end
            
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true) -- Mouse look
            EnableControlAction(0, 2, true) -- Mouse move
        end
    end
end) 