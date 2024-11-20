local SLCore = exports['sl-core']:GetCoreObject()

-- Variables
local openedMenu = nil
local activeTheme = 'default'

-- Functions
local function openMenu(data)
    if not data or not data.id then return end
    if openedMenu then closeMenu() end
    
    -- Validate and set defaults
    data.type = data.type or 'list'
    data.theme = data.theme or activeTheme
    data.position = data.position or 'center'
    data.items = data.items or {}
    
    -- Add metadata to items
    for i, item in ipairs(data.items) do
        item.index = i
        item.type = item.type or 'button'
        item.disabled = item.disabled or false
    end
    
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

local function updateMenu(id, data)
    if not openedMenu or openedMenu ~= id then return end
    
    SendNUIMessage({
        action = "UPDATE_MENU",
        data = data
    })
end

local function setTheme(theme)
    activeTheme = theme
    SendNUIMessage({
        action = "SET_THEME",
        theme = theme
    })
end

-- Exports
exports("OpenMenu", openMenu)
exports("CloseMenu", closeMenu)
exports("UpdateMenu", updateMenu)
exports("SetTheme", setTheme)
exports("IsMenuOpen", function() return openedMenu ~= nil end)
exports("GetCurrentMenu", function() return openedMenu end)

-- NUI Callbacks
RegisterNUICallback('clickMenuItem', function(data, cb)
    if not data.id or not data.itemId then return cb('error') end
    
    TriggerEvent('sl-menu:client:menuItemClicked', data.id, data.itemId, data.value)
    cb('ok')
end)

RegisterNUICallback('closeMenu', function(_, cb)
    closeMenu()
    cb('ok')
end)

RegisterNUICallback('sliderChange', function(data, cb)
    if not data.id or not data.itemId then return cb('error') end
    
    TriggerEvent('sl-menu:client:sliderChanged', data.id, data.itemId, data.value)
    cb('ok')
end)

RegisterNUICallback('checkboxChange', function(data, cb)
    if not data.id or not data.itemId then return cb('error') end
    
    TriggerEvent('sl-menu:client:checkboxChanged', data.id, data.itemId, data.checked)
    cb('ok')
end)

RegisterNUICallback('inputSubmit', function(data, cb)
    if not data.id or not data.itemId then return cb('error') end
    
    TriggerEvent('sl-menu:client:inputSubmitted', data.id, data.itemId, data.value)
    cb('ok')
end)

-- Commands
RegisterCommand('closemenu', function()
    if openedMenu then
        closeMenu()
    end
end)

RegisterCommand('menutheme', function(_, args)
    if args[1] then
        setTheme(args[1])
    end
end)

-- Key Mappings
RegisterKeyMapping('closemenu', 'Close active menu', 'keyboard', 'ESCAPE')

-- Events
RegisterNetEvent('sl-menu:client:closeMenu', closeMenu)
RegisterNetEvent('sl-menu:client:updateMenu', updateMenu)
RegisterNetEvent('sl-menu:client:setTheme', setTheme)
