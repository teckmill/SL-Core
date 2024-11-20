local SLCore = nil
local CoreReady = false

-- Initialize core
CreateThread(function()
    while SLCore == nil do
        if GetResourceState('sl-core') == 'started' then
            SLCore = exports['sl-core']:GetCoreObject()
            if SLCore then
                CoreReady = true
                break
            end
        end
        Wait(100)
    end
end)

-- Utility Functions
function FormatMoney(amount)
    local formatted = amount
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

function FormatTime(seconds)
    if seconds <= 0 then
        return "Now"
    end
    
    local days = math.floor(seconds / 86400)
    seconds = seconds % 86400
    local hours = math.floor(seconds / 3600)
    seconds = seconds % 3600
    local minutes = math.floor(seconds / 60)
    seconds = seconds % 60
    
    local timeString = ""
    
    if days > 0 then
        timeString = string.format("%dd ", days)
    end
    
    if hours > 0 then
        timeString = timeString .. string.format("%dh ", hours)
    end
    
    if minutes > 0 then
        timeString = timeString .. string.format("%dm ", minutes)
    end
    
    if seconds > 0 then
        timeString = timeString .. string.format("%ds", seconds)
    end
    
    return timeString
end

function GetClosestPlayer()
    local players = SLCore.Functions.GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    for _, player in ipairs(players) do
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

-- Exports
exports('FormatMoney', FormatMoney)
exports('FormatTime', FormatTime)
exports('GetClosestPlayer', GetClosestPlayer)
exports('DrawText3D', DrawText3D)
