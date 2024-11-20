local SLCore = exports['sl-core']:GetCoreObject()

-- Utility Functions
function DrawText3D(x, y, z, text)
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

function TableContains(table, element)
    if not table or not element then return false end
    
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function GetClosestDoor()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local closestDoor = nil
    local closestDistance = Config.LockRange + 1.0
    
    for doorId, door in pairs(Config.Doors) do
        local distance = #(playerCoords - door.coords)
        if distance < closestDistance then
            closestDoor = doorId
            closestDistance = distance
        end
    end
    
    return closestDoor, closestDistance
end

function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

function PlayDoorSound(doorId, state)
    local door = Config.Doors[doorId]
    if not door then return end
    
    local soundFile = state and "door_open" or "door_close"
    local coords = door.coords
    
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, soundFile, 0.4)
end

function ShowHelpNotification(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

-- Export Functions
exports('DrawText3D', DrawText3D)
exports('GetClosestDoor', GetClosestDoor)
exports('TableContains', TableContains)
exports('LoadAnimDict', LoadAnimDict)
exports('PlayDoorSound', PlayDoorSound)
exports('ShowHelpNotification', ShowHelpNotification)
