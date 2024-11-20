local SLCore = exports['sl-core']:GetCoreObject()
local isSpectating = false
local isFrozen = false
local isNoclip = false
local isGodmode = false
local isInvisible = false
local lastCoords = nil
local showCoords = false
local showNames = false
local entityMode = false

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
            header = Lang:t('menu.admin_options'),
            icon = 'fas fa-cogs',
            params = {
                event = 'sl-admin:client:OpenAdminOptions'
            }
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
        },
        {
            header = Lang:t('menu.weather_options'),
            icon = 'fas fa-cloud-sun',
            params = {
                event = 'sl-admin:client:OpenWeatherMenu'
            }
        },
        {
            header = Lang:t('menu.dealer_list'),
            icon = 'fas fa-cannabis',
            params = {
                event = 'sl-admin:client:OpenDealerMenu'
            }
        }
    }
    
    exports['sl-menu']:openMenu(menu)
end

-- Admin Options Menu
local function OpenAdminOptions()
    local menu = {
        {
            header = Lang:t('menu.admin_options'),
            icon = 'fas fa-cogs',
            isMenuHeader = true
        },
        {
            header = Lang:t('menu.noclip'),
            icon = 'fas fa-ghost',
            params = {
                event = 'sl-admin:client:ToggleNoclip'
            }
        },
        {
            header = Lang:t('menu.godmode'),
            icon = 'fas fa-pray',
            params = {
                event = 'sl-admin:client:ToggleGodmode'
            }
        },
        {
            header = Lang:t('menu.invisible'),
            icon = 'fas fa-eye-slash',
            params = {
                event = 'sl-admin:client:ToggleInvisible'
            }
        },
        {
            header = Lang:t('menu.names'),
            icon = 'fas fa-id-card',
            params = {
                event = 'sl-admin:client:ToggleNames'
            }
        },
        {
            header = Lang:t('menu.blips'),
            icon = 'fas fa-map-marker',
            params = {
                event = 'sl-admin:client:ToggleBlips'
            }
        },
        {
            header = Lang:t('menu.coords'),
            icon = 'fas fa-location-arrow',
            params = {
                event = 'sl-admin:client:ToggleCoords'
            }
        },
        {
            header = Lang:t('menu.dev_mode'),
            icon = 'fas fa-code',
            params = {
                event = 'sl-admin:client:ToggleDevMode'
            }
        }
    }
    
    exports['sl-menu']:openMenu(menu)
end

-- Player Management Menu
local function OpenPlayerMenu()
    local players = SLCore.Functions.GetPlayers()
    local menu = {
        {
            header = Lang:t('menu.player_management'),
            icon = 'fas fa-users',
            isMenuHeader = true
        }
    }
    
    for _, player in pairs(players) do
        menu[#menu + 1] = {
            header = player.name,
            txt = Lang:t('info.id') .. player.source,
            icon = 'fas fa-user',
            params = {
                event = 'sl-admin:client:OpenPlayerOptions',
                args = {
                    playerId = player.source,
                    playerName = player.name
                }
            }
        }
    end
    
    exports['sl-menu']:openMenu(menu)
end

-- Player Options Menu
local function OpenPlayerOptions(data)
    local menu = {
        {
            header = Lang:t('menu.player_options') .. data.playerName,
            icon = 'fas fa-user-cog',
            isMenuHeader = true
        },
        {
            header = Lang:t('menu.kill'),
            icon = 'fas fa-skull',
            params = {
                event = 'sl-admin:client:KillPlayer',
                args = data.playerId
            }
        },
        {
            header = Lang:t('menu.revive'),
            icon = 'fas fa-heart',
            params = {
                event = 'sl-admin:client:RevivePlayer',
                args = data.playerId
            }
        },
        {
            header = Lang:t('menu.freeze'),
            icon = 'fas fa-snowflake',
            params = {
                event = 'sl-admin:client:FreezePlayer',
                args = data.playerId
            }
        },
        {
            header = Lang:t('menu.spectate'),
            icon = 'fas fa-eye',
            params = {
                event = 'sl-admin:client:SpectatePlayer',
                args = data.playerId
            }
        },
        {
            header = Lang:t('menu.goto'),
            icon = 'fas fa-location-arrow',
            params = {
                event = 'sl-admin:client:GotoPlayer',
                args = data.playerId
            }
        },
        {
            header = Lang:t('menu.bring'),
            icon = 'fas fa-hand-point-right',
            params = {
                event = 'sl-admin:client:BringPlayer',
                args = data.playerId
            }
        },
        {
            header = Lang:t('menu.sit_vehicle'),
            icon = 'fas fa-car-side',
            params = {
                event = 'sl-admin:client:SitInVehicle',
                args = data.playerId
            }
        },
        {
            header = Lang:t('menu.open_inv'),
            icon = 'fas fa-box',
            params = {
                event = 'sl-admin:client:OpenInventory',
                args = data.playerId
            }
        }
    }
    
    exports['sl-menu']:openMenu(menu)
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
