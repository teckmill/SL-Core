local SLCore = exports['sl-core']:GetCoreObject()
local isSpectating = false
local isFrozen = false
local isNoclip = false
local isGodmode = false
local isInvisible = false
local lastCoords = nil

-- Utility Functions
local function ToggleNoclip()
    isNoclip = not isNoclip
    local ped = PlayerPedId()
    
    if isNoclip then
        SetEntityInvincible(ped, true)
        SetEntityVisible(ped, false, false)
    else
        SetEntityInvincible(ped, false)
        SetEntityVisible(ped, true, false)
    end
    
    TriggerEvent('sl-core:client:Notify', isNoclip and Lang:t('success.noclip_enabled') or Lang:t('success.noclip_disabled'))
end

local function ToggleGodmode()
    isGodmode = not isGodmode
    local ped = PlayerPedId()
    
    SetEntityInvincible(ped, isGodmode)
    TriggerEvent('sl-core:client:Notify', isGodmode and Lang:t('success.godmode_enabled') or Lang:t('success.godmode_disabled'))
end

local function ToggleInvisible()
    isInvisible = not isInvisible
    local ped = PlayerPedId()
    
    SetEntityVisible(ped, not isInvisible, false)
    TriggerEvent('sl-core:client:Notify', isInvisible and Lang:t('success.invisible_enabled') or Lang:t('success.invisible_disabled'))
end

-- Admin Menu
local function OpenAdminMenu()
    local menu = {
        {
            header = Lang:t('menu.admin_menu'),
            icon = 'fas fa-shield-alt',
            isMenuHeader = true
        },
        {
            header = Lang:t('menu.player_management'),
            icon = 'fas fa-users',
            params = {
                event = 'sl-admin:client:OpenPlayerMenu'
            }
        },
        {
            header = Lang:t('menu.vehicle_spawner'),
            icon = 'fas fa-car',
            params = {
                event = 'sl-admin:client:OpenVehicleMenu'
            }
        },
        {
            header = Lang:t('menu.server_management'),
            icon = 'fas fa-server',
            params = {
                event = 'sl-admin:client:OpenServerMenu'
            }
        },
        {
            header = Lang:t('menu.developer_tools'),
            icon = 'fas fa-code',
            params = {
                event = 'sl-admin:client:OpenDevTools'
            }
        }
    }
    
    exports['sl-menu']:openMenu(menu)
end

-- Player Management
local function GetNearbyPlayers()
    local players = {}
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    for _, player in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(player)
        local targetCoords = GetEntityCoords(targetPed)
        local distance = #(playerCoords - targetCoords)
        
        if distance <= 5.0 then
            players[#players + 1] = {
                source = GetPlayerServerId(player),
                name = GetPlayerName(player),
                distance = distance
            }
        end
    end
    
    return players
end

-- Vehicle Management
local function SpawnVehicle(model)
    if not IsModelInCdimage(model) then
        TriggerEvent('sl-core:client:Notify', Lang:t('error.invalid_vehicle'), 'error')
        return
    end
    
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
    SetPedIntoVehicle(ped, vehicle, -1)
    SetEntityAsNoLongerNeeded(vehicle)
    SetModelAsNoLongerNeeded(model)
    
    TriggerEvent('sl-core:client:Notify', Lang:t('success.vehicle_spawned'))
end

-- Spectate System
local function BeginSpectate(targetId)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
    if not DoesEntityExist(targetPed) then return end
    
    isSpectating = true
    lastCoords = GetEntityCoords(PlayerPedId())
    
    SetEntityVisible(PlayerPedId(), false, false)
    SetEntityInvincible(PlayerPedId(), true)
    NetworkSetInSpectatorMode(true, targetPed)
    
    TriggerEvent('sl-core:client:Notify', Lang:t('info.spectating', {GetPlayerName(GetPlayerFromServerId(targetId))}))
end

local function EndSpectate()
    if not isSpectating then return end
    
    isSpectating = false
    NetworkSetInSpectatorMode(false, PlayerPedId())
    SetEntityVisible(PlayerPedId(), true, false)
    SetEntityInvincible(PlayerPedId(), false)
    
    if lastCoords then
        SetEntityCoords(PlayerPedId(), lastCoords.x, lastCoords.y, lastCoords.z, false, false, false, false)
        lastCoords = nil
    end
    
    TriggerEvent('sl-core:client:Notify', Lang:t('info.stopped_spectating'))
end

-- Event Handlers
RegisterNetEvent('sl-admin:client:OpenMenu', function()
    OpenAdminMenu()
end)

RegisterNetEvent('sl-admin:client:SpawnVehicle', function(model)
    SpawnVehicle(model)
end)

RegisterNetEvent('sl-admin:client:BeginSpectate', function(targetId)
    BeginSpectate(targetId)
end)

RegisterNetEvent('sl-admin:client:EndSpectate', function()
    EndSpectate()
end)

RegisterNetEvent('sl-admin:client:SetFrozen', function(state)
    isFrozen = state
    FreezeEntityPosition(PlayerPedId(), isFrozen)
    
    if isFrozen then
        TriggerEvent('sl-core:client:Notify', Lang:t('info.player_frozen'))
    else
        TriggerEvent('sl-core:client:Notify', Lang:t('info.player_unfrozen'))
    end
end)

RegisterNetEvent('sl-admin:client:SetWeather', function(weather)
    SetWeatherTypeNow(weather)
    SetWeatherTypeNowPersist(weather)
end)

-- Command Handlers
RegisterCommand('admin', function()
    TriggerServerEvent('sl-admin:server:CheckPermission', 'menu', function(hasPermission)
        if hasPermission then
            OpenAdminMenu()
        end
    end)
end)

RegisterCommand('noclip', function()
    TriggerServerEvent('sl-admin:server:CheckPermission', 'noclip', function(hasPermission)
        if hasPermission then
            ToggleNoclip()
        end
    end)
end)

-- Key Mappings
if Config.EnableKeybinds then
    RegisterKeyMapping('admin', Lang:t('commands.admin_menu'), 'keyboard', Config.MenuKey)
    RegisterKeyMapping('noclip', Lang:t('commands.noclip'), 'keyboard', Config.NoclipKey)
end

-- Threads
CreateThread(function()
    while true do
        if isNoclip then
            local multiplier = 1.0
            
            if IsControlPressed(0, 21) then -- Left Shift
                multiplier = Config.NoclipSpeed.fast
            elseif IsControlPressed(0, 36) then -- Left Ctrl
                multiplier = Config.NoclipSpeed.slow
            end
            
            local ped = PlayerPedId()
            local newPos = GetEntityCoords(ped)
            
            SetEntityVelocity(ped, 0.0, 0.0, 0.0)
            
            if IsControlPressed(0, 32) then -- W
                newPos = GetOffsetFromEntityInWorldCoords(ped, 0.0, multiplier, 0.0)
            end
            
            if IsControlPressed(0, 33) then -- S
                newPos = GetOffsetFromEntityInWorldCoords(ped, 0.0, -multiplier, 0.0)
            end
            
            if IsControlPressed(0, 34) then -- A
                newPos = GetOffsetFromEntityInWorldCoords(ped, -multiplier, 0.0, 0.0)
            end
            
            if IsControlPressed(0, 35) then -- D
                newPos = GetOffsetFromEntityInWorldCoords(ped, multiplier, 0.0, 0.0)
            end
            
            if IsControlPressed(0, 22) then -- Space
                newPos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, multiplier)
            end
            
            if IsControlPressed(0, 73) then -- X
                newPos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -multiplier)
            end
            
            SetEntityCoordsNoOffset(ped, newPos.x, newPos.y, newPos.z, true, true, true)
        end
        Wait(0)
    end
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    
    if isSpectating then
        EndSpectate()
    end
    
    if isNoclip then
        ToggleNoclip()
    end
    
    if isGodmode then
        ToggleGodmode()
    end
    
    if isInvisible then
        ToggleInvisible()
    end
end)
