local SLCore = exports['sl-core']:GetCoreObject()

-- State Management
local showCoords = false
local showNames = false
local showAreas = false
local showDebugInfo = false
local entityMode = false
local selectedEntity = nil

-- Utility Functions
local function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

local function GetEntityInfo(entity)
    if not DoesEntityExist(entity) then return "Invalid Entity" end
    
    local type = GetEntityType(entity)
    local model = GetEntityModel(entity)
    local health = GetEntityHealth(entity)
    local coords = GetEntityCoords(entity)
    local heading = GetEntityHeading(entity)
    local velocity = GetEntityVelocity(entity)
    local speed = #velocity
    
    local typeStr = "Unknown"
    if type == 1 then typeStr = "Ped"
    elseif type == 2 then typeStr = "Vehicle"
    elseif type == 3 then typeStr = "Object"
    end
    
    return string.format([[
Type: %s
Model: %s
Health: %s
Coords: vector3(%s, %s, %s)
Heading: %s
Speed: %s
Network ID: %s
    ]], typeStr, model, health,
    string.format("%.2f", coords.x),
    string.format("%.2f", coords.y),
    string.format("%.2f", coords.z),
    string.format("%.2f", heading),
    string.format("%.2f", speed),
    NetworkGetNetworkIdFromEntity(entity))
end

-- Developer Tools Functions
local function ToggleCoords()
    showCoords = not showCoords
    TriggerEvent('sl-core:client:Notify', showCoords and 'Coordinates display enabled' or 'Coordinates display disabled')
end

local function ToggleNames()
    showNames = not showNames
    TriggerEvent('sl-core:client:Notify', showNames and 'Player names display enabled' or 'Player names display disabled')
end

local function ToggleAreas()
    showAreas = not showAreas
    TriggerEvent('sl-core:client:Notify', showAreas and 'Area names display enabled' or 'Area names display disabled')
end

local function ToggleDebugInfo()
    showDebugInfo = not showDebugInfo
    TriggerEvent('sl-core:client:Notify', showDebugInfo and 'Debug info display enabled' or 'Debug info display disabled')
end

local function ToggleEntityMode()
    entityMode = not entityMode
    selectedEntity = nil
    TriggerEvent('sl-core:client:Notify', entityMode and 'Entity selection mode enabled' or 'Entity selection mode disabled')
end

local function CopyToClipboard(text)
    SendNUIMessage({
        action = "copyToClipboard",
        data = text
    })
end

-- Menu Functions
local function OpenDevTools()
    local menu = {
        {
            header = "Developer Tools",
            icon = "fas fa-code",
            isMenuHeader = true
        },
        {
            header = showCoords and "Hide Coordinates" or "Show Coordinates",
            icon = "fas fa-map-marker-alt",
            params = {
                event = "sl-admin:client:ToggleCoords"
            }
        },
        {
            header = showNames and "Hide Player Names" or "Show Player Names",
            icon = "fas fa-user-tag",
            params = {
                event = "sl-admin:client:ToggleNames"
            }
        },
        {
            header = showAreas and "Hide Area Names" or "Show Area Names",
            icon = "fas fa-map",
            params = {
                event = "sl-admin:client:ToggleAreas"
            }
        },
        {
            header = showDebugInfo and "Hide Debug Info" or "Show Debug Info",
            icon = "fas fa-bug",
            params = {
                event = "sl-admin:client:ToggleDebugInfo"
            }
        },
        {
            header = entityMode and "Disable Entity Mode" or "Enable Entity Mode",
            icon = "fas fa-cube",
            params = {
                event = "sl-admin:client:ToggleEntityMode"
            }
        },
        {
            header = "Copy Coordinates",
            icon = "fas fa-copy",
            params = {
                event = "sl-admin:client:CopyCoords"
            }
        }
    }
    
    exports['sl-menu']:openMenu(menu)
end

-- Event Handlers
RegisterNetEvent('sl-admin:client:OpenDevTools', function()
    OpenDevTools()
end)

RegisterNetEvent('sl-admin:client:ToggleCoords', function()
    ToggleCoords()
end)

RegisterNetEvent('sl-admin:client:ToggleNames', function()
    ToggleNames()
end)

RegisterNetEvent('sl-admin:client:ToggleAreas', function()
    ToggleAreas()
end)

RegisterNetEvent('sl-admin:client:ToggleDebugInfo', function()
    ToggleDebugInfo()
end)

RegisterNetEvent('sl-admin:client:ToggleEntityMode', function()
    ToggleEntityMode()
end)

RegisterNetEvent('sl-admin:client:CopyCoords', function()
    local coords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    local formatStr = string.format("vector4(%s, %s, %s, %s)",
        string.format("%.2f", coords.x),
        string.format("%.2f", coords.y),
        string.format("%.2f", coords.z),
        string.format("%.2f", heading)
    )
    CopyToClipboard(formatStr)
    TriggerEvent('sl-core:client:Notify', 'Coordinates copied to clipboard')
end)

-- Main Thread
CreateThread(function()
    while true do
        local wait = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        if showCoords or showNames or showAreas or showDebugInfo or entityMode then
            wait = 0
            
            -- Coordinates Display
            if showCoords then
                local coordsStr = string.format(
                    "~w~X: ~b~%.2f ~w~Y: ~b~%.2f ~w~Z: ~b~%.2f ~w~H: ~b~%.2f",
                    playerCoords.x, playerCoords.y, playerCoords.z, GetEntityHeading(playerPed)
                )
                DrawText(0.5, 0.02, coordsStr, {r = 255, g = 255, b = 255, a = 255})
            end
            
            -- Player Names Display
            if showNames then
                for _, player in ipairs(GetActivePlayers()) do
                    local targetPed = GetPlayerPed(player)
                    local targetCoords = GetEntityCoords(targetPed)
                    local distance = #(playerCoords - targetCoords)
                    
                    if distance <= 50.0 then
                        local targetName = GetPlayerName(player)
                        local targetHealth = GetEntityHealth(targetPed)
                        local targetArmor = GetPedArmour(targetPed)
                        
                        DrawText3D(
                            targetCoords.x, targetCoords.y, targetCoords.z + 1.0,
                            string.format("%s~n~HP: %s | ARM: %s", targetName, targetHealth, targetArmor)
                        )
                    end
                end
            end
            
            -- Area Names Display
            if showAreas then
                local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z))
                local zoneName = GetLabelText(GetNameOfZone(playerCoords.x, playerCoords.y, playerCoords.z))
                DrawText(0.5, 0.05, string.format("~w~Street: ~b~%s~n~~w~Zone: ~b~%s", streetName, zoneName))
            end
            
            -- Debug Info Display
            if showDebugInfo then
                local fps = GetFrameRate()
                local memory = collectgarbage("count")
                local vehCount = #GetGamePool('CVehicle')
                local pedCount = #GetGamePool('CPed')
                local objCount = #GetGamePool('CObject')
                
                DrawText(0.01, 0.5, string.format([[
~w~FPS: ~b~%d
~w~Memory: ~b~%.2f MB
~w~Vehicles: ~b~%d
~w~Peds: ~b~%d
~w~Objects: ~b~%d
                ]], fps, memory/1024, vehCount, pedCount, objCount))
            end
            
            -- Entity Mode
            if entityMode then
                local success, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
                if success then
                    selectedEntity = entity
                    local entityCoords = GetEntityCoords(entity)
                    DrawText3D(entityCoords.x, entityCoords.y, entityCoords.z, GetEntityInfo(entity))
                end
            end
        end
        
        Wait(wait)
    end
end)

-- Cleanup
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    
    showCoords = false
    showNames = false
    showAreas = false
    showDebugInfo = false
    entityMode = false
    selectedEntity = nil
end)
