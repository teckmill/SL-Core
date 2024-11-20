local SLCore = exports['sl-core']:GetCoreObject()

local cameraOptions = {
    face = {
        coords = vector3(0.0, 0.6, 0.6),
        point = vector3(0.0, 0.0, 0.6),
        fov = 20.0
    },
    body = {
        coords = vector3(0.0, 2.0, 0.2),
        point = vector3(0.0, 0.0, 0.2),
        fov = 30.0
    },
    legs = {
        coords = vector3(0.0, 1.2, -0.6),
        point = vector3(0.0, 0.0, -0.6),
        fov = 25.0
    }
}

function SwitchCameraView(view)
    if not cam then return end
    
    local option = cameraOptions[view]
    if not option then return end
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    local offset = GetOffsetFromEntityInWorldCoords(ped, option.coords.x, option.coords.y, option.coords.z)
    local pointOffset = GetOffsetFromEntityInWorldCoords(ped, option.point.x, option.point.y, option.point.z)
    
    SetCamCoord(cam, offset.x, offset.y, offset.z)
    PointCamAtCoord(cam, pointOffset.x, pointOffset.y, pointOffset.z)
    SetCamFov(cam, option.fov)
end

RegisterNUICallback('switchCamera', function(data, cb)
    SwitchCameraView(data.view)
    cb('ok')
end) 