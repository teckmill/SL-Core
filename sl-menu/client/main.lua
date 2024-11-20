local SLCore = exports['sl-core']:GetCoreObject()

-- Variables
local openedMenu = nil

-- Functions
local function openMenu(data)
    if not data or not data.id then return end
    if openedMenu then closeMenu() end
    
    openedMenu = data.id
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "OPEN_MENU",
        data = data
    })
end

local function closeMenu()
    if not openedMenu then return end
    
    openedMenu = nil
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "CLOSE_MENU"
    })
end

-- Exports
exports("OpenMenu", openMenu)
exports("CloseMenu", closeMenu)
exports("IsMenuOpen", function() return openedMenu ~= nil end)

-- NUI Callbacks
RegisterNUICallback('clickMenuItem', function(data, cb)
    if not data.id or not data.itemId then return cb('error') end
    
    TriggerEvent('sl-menu:client:menuItemClicked', data.id, data.itemId)
    cb('ok')
end)

RegisterNUICallback('closeMenu', function(_, cb)
    closeMenu()
    cb('ok')
end)

-- Commands
RegisterCommand('closemenu', function()
    if openedMenu then
        closeMenu()
    end
end)

RegisterKeyMapping('closemenu', 'Close current menu', 'keyboard', 'BACK')
