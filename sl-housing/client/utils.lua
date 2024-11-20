local SLCore = exports['sl-core']:GetCoreObject()

local function DrawText3D(x, y, z, text)
    -- Find screen coords
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen then return end
    
    -- Calculate text scale based on distance
    local dist = #(GetGameplayCamCoords() - vector3(x, y, z))
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    
    -- Draw text
    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

local function ShowHelpNotification(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local function ShowNotification(msg, type)
    SLCore.Functions.Notify(msg, type)
end

local function PlayAnimation(ped, dict, anim, flags)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
    TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, flags, 0, false, false, false)
    RemoveAnimDict(dict)
end

local function LoadModel(model)
    if type(model) == 'string' then model = GetHashKey(model) end
    
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
end

local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

local function GetClosestPlayer()
    local closestDistance = -1
    local closestPlayer = -1
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    for _, player in ipairs(GetActivePlayers()) do
        local target = GetPlayerPed(player)
        if target ~= ped then
            local targetCoords = GetEntityCoords(target)
            local distance = #(coords - targetCoords)
            
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = player
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
end

local function GetStreetName()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local streetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local streetName = GetStreetNameFromHashKey(streetHash)
    return streetName
end

local function Round(value, numDecimals)
    numDecimals = numDecimals or 0
    local mult = 10^numDecimals
    return math.floor(value * mult + 0.5) / mult
end

-- Exports
exports('DrawText3D', DrawText3D)
exports('ShowHelpNotification', ShowHelpNotification)
exports('ShowNotification', ShowNotification)
exports('PlayAnimation', PlayAnimation)
exports('LoadModel', LoadModel)
exports('LoadAnimDict', LoadAnimDict)
exports('GetClosestPlayer', GetClosestPlayer)
exports('GetStreetName', GetStreetName)
exports('Round', Round)
