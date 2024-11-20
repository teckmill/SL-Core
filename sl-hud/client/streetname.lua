local SLCore = exports['sl-core']:GetCoreObject()

-- Street Name Variables
local currentStreetName = ""
local currentZoneName = ""
local isEnabled = true

-- Update Street Name
local function UpdateStreetName()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
    local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
    
    if street ~= currentStreetName or zone ~= currentZoneName then
        currentStreetName = street
        currentZoneName = zone
        
        SendNUIMessage({
            action = "updateStreet",
            street = street,
            zone = zone
        })
    end
end

-- Street Name Update Loop
CreateThread(function()
    while true do
        Wait(500)
        if isEnabled then
            UpdateStreetName()
        end
    end
end)

-- Toggle Street Name Display
RegisterCommand('togglestreet', function()
    isEnabled = not isEnabled
    SendNUIMessage({
        action = "toggleStreet",
        show = isEnabled
    })
end)

RegisterKeyMapping('togglestreet', 'Toggle Street Name', 'keyboard', 'f7')

-- Initialize Street Name
CreateThread(function()
    Wait(1000)
    UpdateStreetName()
end)
