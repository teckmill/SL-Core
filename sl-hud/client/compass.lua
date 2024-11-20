local SLCore = exports['sl-core']:GetCoreObject()

-- Compass Variables
local isEnabled = true
local showCompassInCar = true
local compassWidth = 100
local compassAlpha = 255

-- Cardinal Directions
local directions = {
    [0] = "N",
    [45] = "NE",
    [90] = "E",
    [135] = "SE",
    [180] = "S",
    [225] = "SW",
    [270] = "W",
    [315] = "NW",
    [360] = "N"
}

-- Get Cardinal Direction
local function GetCardinalDirection(heading)
    local dir = math.floor((heading + 22.5) / 45.0)
    dir = dir % 8
    return directions[dir * 45]
end

-- Update Compass
local function UpdateCompass()
    if not isEnabled then return end
    
    local ped = PlayerPedId()
    local inVehicle = IsPedInAnyVehicle(ped, false)
    
    if not showCompassInCar and inVehicle then return end
    
    local heading = GetEntityHeading(ped)
    local cardinal = GetCardinalDirection(heading)
    
    SendNUIMessage({
        action = "updateCompass",
        heading = heading,
        cardinal = cardinal,
        show = true,
        width = compassWidth,
        alpha = compassAlpha
    })
end

-- Compass Update Loop
CreateThread(function()
    while true do
        Wait(100)
        UpdateCompass()
    end
end)

-- Toggle Compass Display
RegisterCommand('togglecompass', function()
    isEnabled = not isEnabled
    SendNUIMessage({
        action = "updateCompass",
        show = isEnabled
    })
end)

RegisterKeyMapping('togglecompass', 'Toggle Compass', 'keyboard', 'f6')

-- Compass Width Command
RegisterCommand('compasswidth', function(source, args)
    if not args[1] then return end
    local width = tonumber(args[1])
    if width and width >= 50 and width <= 200 then
        compassWidth = width
    end
end)

-- Compass Alpha Command
RegisterCommand('compassalpha', function(source, args)
    if not args[1] then return end
    local alpha = tonumber(args[1])
    if alpha and alpha >= 0 and alpha <= 255 then
        compassAlpha = alpha
    end
end)

-- Initialize Compass
CreateThread(function()
    Wait(1000)
    UpdateCompass()
end)
