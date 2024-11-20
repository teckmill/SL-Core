local SLCore = exports['sl-core']:GetCoreObject()
local inCamera = false
local fov_max = 70.0
local fov_min = 5.0
local zoomspeed = 10.0
local speed_lr = 8.0
local speed_ud = 8.0

-- Camera Controls
local function HandleCamera()
    local ped = PlayerPedId()
    local camFov = fov_max
    
    SetNuiFocus(false, false)
    CreateMobilePhone(1)
    CellCamActivate(true, true)
    
    while inCamera do
        Wait(0)
        
        if IsControlJustPressed(1, 177) then -- BACKSPACE
            DestroyMobilePhone()
            CellCamActivate(false, false)
            inCamera = false
            SetNuiFocus(true, true)
            break
        end
        
        if IsControlJustPressed(1, 27) then -- SPACE
            TakePhoto()
        end
        
        -- Zoom controls
        if IsControlPressed(1, 241) then -- SCROLLUP
            camFov = math.max(fov_min, camFov - zoomspeed)
        end
        
        if IsControlPressed(1, 242) then -- SCROLLDOWN
            camFov = math.min(fov_max, camFov + zoomspeed)
        end
        
        SetPhoneLean(true)
        SetCamFov(camFov)
    end
end

local function TakePhoto()
    exports['screenshot-basic']:requestScreenshotUpload(Config.UploadURL, 'files[]', function(data)
        local resp = json.decode(data)
        if resp.url then
            TriggerServerEvent('sl-phone:server:SavePhoto', resp.url)
        end
    end)
end

-- NUI Callbacks
RegisterNUICallback('OpenCamera', function(data, cb)
    inCamera = true
    HandleCamera()
    cb('ok')
end)

RegisterNUICallback('GetPhotos', function(data, cb)
    SLCore.Functions.TriggerCallback('sl-phone:server:GetPhotos', function(photos)
        cb(photos)
    end)
end)

RegisterNUICallback('DeletePhoto', function(data, cb)
    if not data.id then return end
    TriggerServerEvent('sl-phone:server:DeletePhoto', data.id)
    cb('ok')
end)

-- Events
RegisterNetEvent('sl-phone:client:PhotoSaved', function()
    SendNUIMessage({
        action = "RefreshPhotos"
    })
end)

RegisterNetEvent('sl-phone:client:PhotoDeleted', function()
    SendNUIMessage({
        action = "RefreshPhotos"
    })
end)
