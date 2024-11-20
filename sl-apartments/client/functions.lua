local SLCore = exports['sl-core']:GetCoreObject()

-- Utility Functions
function GetClosestApartment()
    local pos = GetEntityCoords(PlayerPedId())
    local closest = nil
    local closestDist = nil

    for k, v in pairs(Config.Locations) do
        local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
        if not closestDist or dist < closestDist then
            closest = k
            closestDist = dist
        end
    end

    return closest, closestDist
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local scale = 0.35
    
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function ShowNotification(msg, type)
    SLCore.Functions.Notify(msg, type)
end

function ShowHelpNotification(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function RequestAnimDict(animDict)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(0)
    end
end

function PlayAnimation(ped, dict, anim, settings)
    if dict then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end

        if settings == nil then
            TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
        else 
            local speed = 1.0
            local speedMultiplier = -1.0
            local duration = 1.0
            local flag = 0
            local playbackRate = 0

            if settings["speed"] then
                speed = settings["speed"]
            end

            if settings["speedMultiplier"] then
                speedMultiplier = settings["speedMultiplier"]
            end

            if settings["duration"] then
                duration = settings["duration"]
            end

            if settings["flag"] then
                flag = settings["flag"]
            end

            if settings["playbackRate"] then
                playbackRate = settings["playbackRate"]
            end

            TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
        end
    end
end

-- Apartment Functions
function IsNearApartment()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local closest, dist = GetClosestApartment()
    
    if dist and dist < 3.0 then
        return true, closest
    end
    
    return false, nil
end

function GetApartmentData(apartment)
    return Config.Locations[apartment]
end

function GetInteriorData(interior)
    return Config.Interiors[interior]
end

-- Export the functions
exports('GetClosestApartment', GetClosestApartment)
exports('IsNearApartment', IsNearApartment)
exports('GetApartmentData', GetApartmentData)
exports('GetInteriorData', GetInteriorData)
