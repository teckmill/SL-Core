local SLCore = exports['sl-core']:GetCoreObject()

-- Local Variables
local success = false
local targetActive = false
local hasFocus = false
local currentEntity = nil
local lastEntity = nil
local currentTarget = nil
local sendData = nil

-- Cache frequently used natives
local GetEntityCoords = GetEntityCoords
local Wait = Wait

-- Initialize default targets
local function InitializeTargets()
    -- Add default targets from config
    if Config.DefaultTargets then
        for name, target in pairs(Config.DefaultTargets) do
            if target.models then
                exports['sl-target']:AddTargetModel(target.models, target.options, target.distance)
            end
        end
    end
end

-- Raycast function to detect entities
local function RaycastCamera(flag)
    local coords = GetGameplayCamCoord()
    local offset = GetGameplayCamRot(2)
    local direction = vector3(
        -math.sin(math.rad(offset.z)) * math.abs(math.cos(math.rad(offset.x))),
        math.cos(math.rad(offset.z)) * math.abs(math.cos(math.rad(offset.x))),
        math.sin(math.rad(offset.x))
    )
    local destination = coords + (direction * Config.MaxDistance)
    local ray = StartExpensiveSynchronousShapeTestLosProbe(coords.x, coords.y, coords.z, destination.x, destination.y, destination.z, flag or -1, PlayerPedId(), 0)
    return GetShapeTestResult(ray)
end

-- Check if entity is valid target
local function ValidateEntity(entity)
    if not DoesEntityExist(entity) then return false end
    if isEntityBlacklisted(entity) then return false end
    local model = GetEntityModel(entity)
    local coords = GetEntityCoords(entity)
    local distance = #(GetEntityCoords(PlayerPedId()) - coords)
    
    -- Check if entity is in currentTargets
    if currentTargets[NetworkGetNetworkIdFromEntity(entity)] then
        return true, currentTargets[NetworkGetNetworkIdFromEntity(entity)]
    end
    
    -- Check if model is in currentTargets
    if currentTargets[model] then
        return true, currentTargets[model]
    end
    
    return false, nil
end

-- Get available options for target
local function GetTargetOptions(target)
    if not target or not target.options then return {} end
    return filterOptions(target.options)
end

-- Update NUI state
local function SendNUIMessage(data)
    if not data then return end
    SendNUIMessage({
        action = data.action,
        data = data.data
    })
end

-- Toggle targeting mode
local function EnableTarget()
    if targetActive then return end
    targetActive = true
    
    -- Show targeting UI
    SendNUIMessage({action = 'SHOW_TARGET'})
    
    -- Main targeting loop
    CreateThread(function()
        while targetActive do
            local hit, _, coords, _, entity = RaycastCamera()
            
            if hit == 1 then
                if entity ~= 0 and entity ~= lastEntity then
                    lastEntity = entity
                    local isValid, target = ValidateEntity(entity)
                    
                    if isValid then
                        currentEntity = entity
                        currentTarget = target
                        local options = GetTargetOptions(target)
                        
                        if #options > 0 then
                            SendNUIMessage({
                                action = 'UPDATE_TARGET_STATUS',
                                data = {
                                    available = true,
                                    label = target.label or '',
                                    color = Config.Colors.Available
                                }
                            })
                        end
                    else
                        currentEntity = nil
                        currentTarget = nil
                        SendNUIMessage({
                            action = 'UPDATE_TARGET_STATUS',
                            data = {
                                available = false
                            }
                        })
                    end
                end
            else
                if lastEntity then
                    lastEntity = nil
                    currentEntity = nil
                    currentTarget = nil
                    SendNUIMessage({
                        action = 'UPDATE_TARGET_STATUS',
                        data = {
                            available = false
                        }
                    })
                end
            end
            
            Wait(Config.UpdateFrequency)
        end
    end)
end

-- Disable targeting mode
local function DisableTarget()
    if not targetActive then return end
    targetActive = false
    currentEntity = nil
    lastEntity = nil
    currentTarget = nil
    SendNUIMessage({action = 'HIDE_TARGET'})
end

-- Toggle target
local function ToggleTarget()
    if targetActive then
        DisableTarget()
    else
        EnableTarget()
    end
end

-- NUI Callbacks
RegisterNUICallback('selectOption', function(data, cb)
    if not data.type or not data.event then return cb('error') end
    
    if data.type == 'client' then
        TriggerEvent(data.event, data.data)
    elseif data.type == 'server' then
        TriggerServerEvent(data.event, data.data)
    end
    
    cb('ok')
end)

RegisterNUICallback('closeMenu', function(_, cb)
    DisableTarget()
    cb('ok')
end)

-- Key Mapping
RegisterCommand('+targetmode', function()
    if IsPauseMenuActive() and Config.DisableTargetingDuringPause then return end
    if Config.DisableInVehicle and IsPedInAnyVehicle(PlayerPedId(), false) then return end
    ToggleTarget()
end)

RegisterCommand('-targetmode', function()
    if not targetActive then return end
    if currentTarget and currentEntity then
        local options = GetTargetOptions(currentTarget)
        if #options > 0 then
            SendNUIMessage({
                action = 'SHOW_MENU',
                data = {
                    label = currentTarget.label or 'Select an Option',
                    options = options
                }
            })
        end
    end
end)

RegisterKeyMapping('+targetmode', 'Toggle targeting mode', 'keyboard', Config.OpenKey)

-- Initialize
CreateThread(function()
    InitializeTargets()
end)
