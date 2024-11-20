local SLCore = exports['sl-core']:GetCoreObject()

-- Menu Functions
function OpenDoorMenu(doorId)
    local door = Config.Doors[doorId]
    if not door then return end
    
    local menuItems = {
        {
            header = Lang:t('menu.door_management'),
            isMenuHeader = true
        },
        {
            header = Lang:t('menu.toggle_lock'),
            txt = Lang:t('menu.toggle_lock_desc'),
            params = {
                event = 'sl-doors:client:ToggleDoorLock',
                args = {
                    doorId = doorId
                }
            }
        }
    }
    
    -- Add key management options if player has keys
    local Player = SLCore.Functions.GetPlayerData()
    if DoorStates[doorId] and DoorStates[doorId].keys and TableContains(DoorStates[doorId].keys, Player.citizenid) then
        table.insert(menuItems, {
            header = Lang:t('menu.give_keys'),
            txt = Lang:t('menu.give_keys_desc'),
            params = {
                event = 'sl-doors:client:GiveKeysMenu',
                args = {
                    doorId = doorId
                }
            }
        })
        
        table.insert(menuItems, {
            header = Lang:t('menu.remove_keys'),
            txt = Lang:t('menu.remove_keys_desc'),
            params = {
                event = 'sl-doors:client:RemoveKeysMenu',
                args = {
                    doorId = doorId
                }
            }
        })
    end
    
    -- Add lockpick option if enabled
    if Config.EnableLockpicking and door.canBeLockpicked then
        table.insert(menuItems, {
            header = Lang:t('menu.lockpick'),
            txt = Lang:t('menu.lockpick_desc'),
            params = {
                event = 'sl-doors:client:LockpickDoor',
                args = {
                    doorId = doorId
                }
            }
        })
    end
    
    exports['sl-menu']:openMenu(menuItems)
end

function OpenGiveKeysMenu(data)
    local doorId = data.doorId
    local door = Config.Doors[doorId]
    if not door then return end
    
    local menuItems = {
        {
            header = Lang:t('menu.give_keys'),
            isMenuHeader = true
        }
    }
    
    local players = SLCore.Functions.GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 3.0)
    for _, player in pairs(players) do
        if player ~= PlayerId() then
            local playerData = SLCore.Functions.GetPlayerData(player)
            if playerData then
                table.insert(menuItems, {
                    header = playerData.charinfo.firstname .. ' ' .. playerData.charinfo.lastname,
                    txt = Lang:t('menu.give_keys_to_player'),
                    params = {
                        event = 'sl-doors:client:GiveKeys',
                        args = {
                            doorId = doorId,
                            targetId = player
                        }
                    }
                })
            end
        end
    end
    
    if #menuItems == 1 then
        table.insert(menuItems, {
            header = Lang:t('menu.no_players_nearby'),
            txt = '',
            params = {
                event = 'sl-menu:client:closeMenu'
            }
        })
    end
    
    exports['sl-menu']:openMenu(menuItems)
end

function OpenRemoveKeysMenu(data)
    local doorId = data.doorId
    local door = Config.Doors[doorId]
    if not door then return end
    
    local menuItems = {
        {
            header = Lang:t('menu.remove_keys'),
            isMenuHeader = true
        }
    }
    
    if DoorStates[doorId] and DoorStates[doorId].keys then
        for _, citizenid in pairs(DoorStates[doorId].keys) do
            local Player = SLCore.Functions.GetPlayerByCitizenId(citizenid)
            if Player then
                table.insert(menuItems, {
                    header = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
                    txt = Lang:t('menu.remove_keys_from_player'),
                    params = {
                        event = 'sl-doors:client:RemoveKeys',
                        args = {
                            doorId = doorId,
                            targetId = Player.PlayerData.source
                        }
                    }
                })
            end
        end
    end
    
    if #menuItems == 1 then
        table.insert(menuItems, {
            header = Lang:t('menu.no_key_holders'),
            txt = '',
            params = {
                event = 'sl-menu:client:closeMenu'
            }
        })
    end
    
    exports['sl-menu']:openMenu(menuItems)
end

-- Event Handlers
RegisterNetEvent('sl-doors:client:OpenDoorMenu', function(data)
    OpenDoorMenu(data.doorId)
end)

RegisterNetEvent('sl-doors:client:GiveKeysMenu', function(data)
    OpenGiveKeysMenu(data)
end)

RegisterNetEvent('sl-doors:client:RemoveKeysMenu', function(data)
    OpenRemoveKeysMenu(data)
end)

-- Exports
exports('OpenDoorMenu', OpenDoorMenu)
exports('OpenGiveKeysMenu', OpenGiveKeysMenu)
exports('OpenRemoveKeysMenu', OpenRemoveKeysMenu)
