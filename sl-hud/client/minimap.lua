local SLCore = exports['sl-core']:GetCoreObject()

-- Minimap Variables
local minimapEnabled = true
local isRadarRounded = true
local minimapZoom = 1.0

-- Minimap Configuration
local function ConfigureMinimap()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
    
    if isRadarRounded then
        RequestStreamedTextureDict("circlemap", false)
        while not HasStreamedTextureDictLoaded("circlemap") do
            Wait(100)
        end
        
        AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
        AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "circlemap", "radarmasksm")
        
        SetMinimapClipType(1)
    else
        SetMinimapClipType(0)
    end
    
    SetRadarZoom(minimapZoom)
end

-- Toggle Minimap
RegisterCommand('togglemap', function()
    minimapEnabled = not minimapEnabled
    DisplayRadar(minimapEnabled)
end)

-- Initialize Minimap
CreateThread(function()
    Wait(100)
    ConfigureMinimap()
    
    -- Only show radar when in vehicle
    local lastInVehicle = false
    
    while true do
        Wait(500)
        local ped = PlayerPedId()
        local inVehicle = IsPedInAnyVehicle(ped, false)
        
        if inVehicle ~= lastInVehicle then
            lastInVehicle = inVehicle
            DisplayRadar(minimapEnabled and inVehicle)
        end
    end
end)

-- Minimap Zoom Control
RegisterCommand('mapzoom', function(source, args)
    if not args[1] then return end
    local zoom = tonumber(args[1])
    if zoom and zoom >= 0.0 and zoom <= 2.0 then
        minimapZoom = zoom
        SetRadarZoom(minimapZoom)
    end
end)

-- Reset Minimap
RegisterNetEvent('sl-hud:client:ResetMinimap')
AddEventHandler('sl-hud:client:ResetMinimap', function()
    ConfigureMinimap()
end)
