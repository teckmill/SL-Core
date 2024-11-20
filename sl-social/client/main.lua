local QBCore = exports['qb-core']:GetCoreObject()
local isPhoneOpen = false
local currentApp = nil
local phoneData = {
    contacts = {},
    messages = {},
    posts = {},
    notifications = {}
}

-- Utility Functions
local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(1)
    end
end

local function PlayPhoneAnim(anim)
    local dict = "cellphone@"
    LoadAnimDict(dict)
    TaskPlayAnim(PlayerPedId(), dict, anim, 2.0, 2.0, -1, 51, 0, false, false, false)
end

local function ShowNotification(data)
    SendNUIMessage({
        action = "showNotification",
        notification = data
    })
    if Config.UI.Sounds.Enabled then
        PlaySound(-1, Config.UI.Sounds.Effects.notification, "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    end
end

-- Basic Functions
local function TogglePhone(show)
    isPhoneOpen = show
    SetNuiFocus(show, show)
    SendNUIMessage({
        action = "toggle",
        show = show
    })
end

-- Phone System
RegisterNetEvent('sl-social:client:togglePhone')
AddEventHandler('sl-social:client:togglePhone', function()
    isPhoneOpen = not isPhoneOpen
    
    if isPhoneOpen then
        PlayPhoneAnim("text")
        QBCore.Functions.TriggerCallback('sl-social:server:getContacts', function(contacts)
            phoneData.contacts = contacts
            SendNUIMessage({
                action = "togglePhone",
                show = true,
                data = phoneData,
                theme = Config.UI.Themes[Config.UI.DefaultTheme]
            })
        end)
    else
        StopAnimTask(PlayerPedId(), "cellphone@", "text", 1.0)
        SendNUIMessage({
            action = "togglePhone",
            show = false
        })
    end
    
    SetNuiFocus(isPhoneOpen, isPhoneOpen)
end)

RegisterNUICallback('closePhone', function()
    TriggerEvent('sl-social:client:togglePhone')
end)

RegisterNUICallback('addContact', function(data, cb)
    TriggerServerEvent('sl-social:server:addContact', data)
    cb('ok')
end)

-- Social Media System
RegisterNUICallback('getPosts', function(data, cb)
    QBCore.Functions.TriggerCallback('sl-social:server:getPosts', function(posts)
        cb(posts)
    end, data.page or 1)
end)

RegisterNUICallback('createPost', function(data, cb)
    TriggerServerEvent('sl-social:server:createPost', data)
    cb('ok')
end)

RegisterNetEvent('sl-social:client:postCreated')
AddEventHandler('sl-social:client:postCreated', function(post)
    SendNUIMessage({
        action = "newPost",
        post = post
    })
end)

-- Dating System
RegisterNUICallback('getDatingProfile', function(data, cb)
    QBCore.Functions.TriggerCallback('sl-social:server:getDatingProfile', function(profile)
        cb(profile)
    end)
end)

RegisterNUICallback('updateDatingProfile', function(data, cb)
    TriggerServerEvent('sl-social:server:updateDatingProfile', data)
    cb('ok')
end)

RegisterNetEvent('sl-social:client:matchFound')
AddEventHandler('sl-social:client:matchFound', function(matchData)
    SendNUIMessage({
        action = "matchFound",
        match = matchData
    })
    if Config.UI.Sounds.Enabled then
        PlaySound(-1, Config.UI.Sounds.Effects.match, "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    end
end)

-- Reputation System
RegisterNUICallback('getReputation', function(data, cb)
    QBCore.Functions.TriggerCallback('sl-social:server:getReputation', function(reputation)
        cb(reputation)
    end, data.targetId)
end)

RegisterNUICallback('rateUser', function(data, cb)
    TriggerServerEvent('sl-social:server:rateUser', data)
    cb('ok')
end)

-- Command Registration
RegisterCommand('phone', function()
    if not exports['sl-core']:IsPlayerDead() then
        if not isPhoneOpen then
            TogglePhone(true)
        end
    end
end)

RegisterKeyMapping('phone', 'Open Phone', 'keyboard', 'M')

-- NUI Callbacks
RegisterNUICallback('closeApp', function(data, cb)
    TogglePhone(false)
    cb('ok')
end)

RegisterNUICallback('tabChanged', function(data, cb)
    local tab = data.tab
    if tab == "social" then
        TriggerServerEvent('sl-social:server:getSocialFeed')
    elseif tab == "messages" then
        TriggerServerEvent('sl-social:server:getMessages')
    elseif tab == "dating" then
        TriggerServerEvent('sl-social:server:getDatingProfiles')
    elseif tab == "reputation" then
        TriggerServerEvent('sl-social:server:getReputation')
    end
    cb('ok')
end)

RegisterNUICallback('createPost', function(data, cb)
    TriggerServerEvent('sl-social:server:createPost', data.content)
    cb('ok')
end)

RegisterNUICallback('sendMessage', function(data, cb)
    TriggerServerEvent('sl-social:server:sendMessage', data.content)
    cb('ok')
end)

RegisterNUICallback('likeDatingProfile', function(data, cb)
    TriggerServerEvent('sl-social:server:likeDatingProfile')
    cb('ok')
end)

RegisterNUICallback('dislikeDatingProfile', function(data, cb)
    TriggerServerEvent('sl-social:server:dislikeDatingProfile')
    cb('ok')
end)

-- Server Event Handlers
RegisterNetEvent('sl-social:client:updateSocialFeed')
AddEventHandler('sl-social:client:updateSocialFeed', function(posts)
    if isPhoneOpen then
        SendNUIMessage({
            action = "updateSocial",
            posts = posts
        })
    end
end)

RegisterNetEvent('sl-social:client:updateMessages')
AddEventHandler('sl-social:client:updateMessages', function(messages)
    if isPhoneOpen then
        SendNUIMessage({
            action = "updateMessages",
            messages = messages
        })
    end
end)

RegisterNetEvent('sl-social:client:updateDatingProfiles')
AddEventHandler('sl-social:client:updateDatingProfiles', function(profiles)
    if isPhoneOpen then
        SendNUIMessage({
            action = "updateDating",
            profiles = profiles
        })
    end
end)

RegisterNetEvent('sl-social:client:updateReputation')
AddEventHandler('sl-social:client:updateReputation', function(stats)
    if isPhoneOpen then
        SendNUIMessage({
            action = "updateReputation",
            stats = stats
        })
    end
end)

-- Animation Functions
local function PlayPhoneAnim()
    local ped = PlayerPedId()
    if not IsEntityPlayingAnim(ped, "cellphone@", "cellphone_text_read_base", 3) then
        RequestAnimDict("cellphone@")
        while not HasAnimDictLoaded("cellphone@") do
            Wait(10)
        end
        TaskPlayAnim(ped, "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, false, false, false)
    end
end

local function StopPhoneAnim()
    local ped = PlayerPedId()
    StopAnimTask(ped, "cellphone@", "cellphone_text_read_base", 1.0)
end

-- Thread for Animation
CreateThread(function()
    while true do
        Wait(500)
        if isPhoneOpen then
            PlayPhoneAnim()
        else
            StopPhoneAnim()
        end
    end
end)

-- Initialize resource
CreateThread(function()
    while true do
        if isPhoneOpen then
            DisableControlAction(0, 1, true) -- LookLeftRight
            DisableControlAction(0, 2, true) -- LookUpDown
            DisableControlAction(0, 24, true) -- Attack
            DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
        end
        Wait(0)
    end
end)

-- Event Handlers
RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    -- Initialize phone data when player loads
    QBCore.Functions.TriggerCallback('sl-social:server:getContacts', function(contacts)
        phoneData.contacts = contacts
    end)
end)

RegisterNetEvent('sl-social:client:contactAdded')
AddEventHandler('sl-social:client:contactAdded', function(contact)
    table.insert(phoneData.contacts, contact)
    SendNUIMessage({
        action = "updateContacts",
        contacts = phoneData.contacts
    })
    ShowNotification({
        type = "success",
        title = "New Contact",
        message = "Contact added successfully",
        duration = 3000
    })
end)

-- NUI Callbacks for UI Interaction
RegisterNUICallback('switchApp', function(data, cb)
    currentApp = data.app
    SendNUIMessage({
        action = "switchApp",
        app = data.app
    })
    cb('ok')
end)

RegisterNUICallback('playSound', function(data, cb)
    if Config.UI.Sounds.Enabled then
        PlaySound(-1, data.sound, "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    end
    cb('ok')
end)

-- Cleanup
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    if isPhoneOpen then
        SetNuiFocus(false, false)
        StopAnimTask(PlayerPedId(), "cellphone@", "text", 1.0)
    end
end)
