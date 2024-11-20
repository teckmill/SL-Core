local SLCore = exports['sl-core']:GetCoreObject()

-- Menu State
local isMenuOpen = false
local selectedPlayer = nil
local selectedVehicle = nil

-- Menu Configuration
local menuConfig = {
    position = "right",
    width = 400,
    height = 600
}

-- Menu Options
local function getPlayerOptions()
    return {
        {
            header = "Player Actions",
            isMenuHeader = true
        },
        {
            header = "Teleport Options",
            txt = "Teleport to/from player",
            params = {
                event = "sl-admin:client:OpenTeleportMenu",
                args = {
                    playerId = selectedPlayer
                }
            }
        },
        {
            header = "Player Info",
            txt = "View detailed player information",
            params = {
                event = "sl-admin:client:ViewPlayerInfo",
                args = {
                    playerId = selectedPlayer
                }
            }
        },
        {
            header = "Punish Player",
            txt = "Kick, ban, or warn player",
            params = {
                event = "sl-admin:client:OpenPunishMenu",
                args = {
                    playerId = selectedPlayer
                }
            }
        }
    }
end

local function getVehicleOptions()
    return {
        {
            header = "Vehicle Options",
            isMenuHeader = true
        },
        {
            header = "Spawn Vehicle",
            txt = "Enter vehicle model name",
            params = {
                event = "sl-admin:client:SpawnVehicle"
            }
        },
        {
            header = "Fix Vehicle",
            txt = "Repair current vehicle",
            params = {
                event = "sl-admin:client:FixVehicle"
            }
        },
        {
            header = "Delete Vehicle",
            txt = "Remove current vehicle",
            params = {
                event = "sl-admin:client:DeleteVehicle"
            }
        }
    }
end

local function getServerOptions()
    return {
        {
            header = "Server Management",
            isMenuHeader = true
        },
        {
            header = "Weather Control",
            txt = "Change server weather",
            params = {
                event = "sl-admin:client:OpenWeatherMenu"
            }
        },
        {
            header = "Time Control",
            txt = "Change server time",
            params = {
                event = "sl-admin:client:OpenTimeMenu"
            }
        },
        {
            header = "Announcements",
            txt = "Send server announcement",
            params = {
                event = "sl-admin:client:OpenAnnouncementMenu"
            }
        }
    }
end

-- Event Handlers
RegisterNetEvent('sl-admin:client:OpenMenu', function()
    if not SLCore.Functions.HasPermission('admin') then return end
    
    if isMenuOpen then
        exports['sl-menu']:closeMenu()
        isMenuOpen = false
        return
    end
    
    local adminMenu = {
        {
            header = "Admin Menu",
            isMenuHeader = true
        },
        {
            header = "Player Management",
            txt = "Manage online players",
            params = {
                event = "sl-admin:client:OpenPlayerMenu"
            }
        },
        {
            header = "Vehicle Options",
            txt = "Vehicle management tools",
            params = {
                event = "sl-admin:client:OpenVehicleMenu"
            }
        },
        {
            header = "Server Management",
            txt = "Server control options",
            params = {
                event = "sl-admin:client:OpenServerMenu"
            }
        },
        {
            header = "Developer Tools",
            txt = "Development utilities",
            params = {
                event = "sl-admin:client:OpenDevTools"
            }
        },
        {
            header = "Close Menu",
            txt = "Exit admin menu",
            params = {
                event = "sl-menu:client:closeMenu"
            }
        }
    }
    
    exports['sl-menu']:openMenu(adminMenu)
    isMenuOpen = true
end)

-- Menu Events
RegisterNetEvent('sl-admin:client:OpenPlayerMenu', function()
    local players = SLCore.Functions.GetPlayers()
    local playerMenu = {
        {
            header = "Online Players",
            isMenuHeader = true
        }
    }
    
    for _, player in pairs(players) do
        table.insert(playerMenu, {
            header = player.name,
            txt = "ID: " .. player.source,
            params = {
                event = "sl-admin:client:SelectPlayer",
                args = {
                    playerId = player.source
                }
            }
        })
    end
    
    exports['sl-menu']:openMenu(playerMenu)
end)

RegisterNetEvent('sl-admin:client:OpenVehicleMenu', function()
    exports['sl-menu']:openMenu(getVehicleOptions())
end)

RegisterNetEvent('sl-admin:client:OpenServerMenu', function()
    exports['sl-menu']:openMenu(getServerOptions())
end)

-- Commands
RegisterCommand('admin', function()
    if not SLCore.Functions.HasPermission('admin') then return end
    TriggerEvent('sl-admin:client:OpenMenu')
end)

-- Keybinds
RegisterKeyMapping('admin', 'Open Admin Menu', 'keyboard', 'F10')
