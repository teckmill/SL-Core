local SLCore = nil

-- Wait for core to be ready
CreateThread(function()
    while SLCore == nil do
        SLCore = exports['sl-core']:GetCoreObject()
        if not SLCore then 
            Wait(100)
        end
    end
end)

local PlayerData = {}
local PhoneData = {}
local CurrentApplication = nil
local PhoneProp = nil
local PhoneOpen = false

-- Initialize Phone Data
local function InitializePhone()
    PhoneData = {
        MetaData = {},
        isOpen = false,
        PlayerData = nil,
        Contacts = {},
        Tweets = {},
        MentionedTweets = {},
        Hashtags = {},
        Chats = {},
        Invoices = {},
        CallData = {},
        RecentCalls = {},
        Garage = {},
        Mails = {},
        Adverts = {},
        News = {},
        Bank = 0,
        Crypto = {},
        Photos = {}
    }
end

-- Load Animation Dictionary
local function LoadAnimation(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

-- Create Phone Prop
local function CreatePhone()
    DeletePhone()
    local ped = PlayerPedId()
    LoadAnimation(Config.AnimDict)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    PhoneProp = CreateObject(Config.PhoneModel, x, y, z + 0.2, true, true, true)
    local bone = GetPedBoneIndex(ped, 28422)
    AttachEntityToEntity(PhoneProp, ped, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    SetEntityAsMissionEntity(PhoneProp, true, true)
    SetModelAsNoLongerNeeded(Config.PhoneModel)
end

-- Delete Phone Prop
local function DeletePhone()
    if PhoneProp ~= nil then
        DeleteEntity(PhoneProp)
        PhoneProp = nil
    end
end

-- Phone Animation Functions
local function PhoneAnimation()
    LoadAnimation("cellphone@")
    TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_in", 3.0, 3.0, -1, 50, 0, false, false, false)
    PhoneProp = CreateObject(`prop_npc_phone_02`, 1.0, 1.0, 1.0, true, true, true)
    AttachEntityToEntity(PhoneProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
end

local function CancelPhoneAnimation()
    StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_in", 1.0)
    if PhoneProp ~= nil then
        DeleteObject(PhoneProp)
        PhoneProp = nil
    end
end

-- Phone Toggle Function
function TogglePhone()
    if not PhoneOpen then
        PhoneAnimation()
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "open",
            playerData = SLCore.Functions.GetPlayerData()
        })
        PhoneOpen = true
    else
        CancelPhoneAnimation()
        SetNuiFocus(false, false)
        SendNUIMessage({
            action = "close"
        })
        PhoneOpen = false
    end
end

-- Update Phone Data
local function UpdatePhoneData()
    local result = SLCore.Functions.TriggerCallback('sl-phone:server:GetPhoneData')
    if result then
        PhoneData = result
        SendNUIMessage({
            action = "updatePhoneData",
            data = PhoneData
        })
    end
end

-- Event Handlers
RegisterNetEvent('sl-phone:client:TogglePhone', function()
    TogglePhone()
end)

RegisterNetEvent('sl-phone:client:UpdatePhone', function(data)
    PhoneData = data
    SendNUIMessage({
        action = "updatePhoneData",
        data = PhoneData
    })
end)

-- NUI Callbacks
RegisterNUICallback('ClosePhone', function()
    TogglePhone()
end)

RegisterNUICallback('OpenApp', function(data)
    CurrentApplication = data.app
    SendNUIMessage({
        action = "openApp",
        app = data.app
    })
end)

RegisterNUICallback('SendMessage', function(data, cb)
    TriggerServerEvent('sl-phone:server:SendMessage', data)
    cb('ok')
end)

-- Initialize
CreateThread(function()
    while not SLCore or not SLCore.Functions.IsPlayerLoaded() do
        Wait(100)
    end
    
    PlayerData = SLCore.Functions.GetPlayerData()
    InitializePhone()
    UpdatePhoneData()
end)

-- Key Mapping
RegisterKeyMapping('phone', 'Open Phone', 'keyboard', Config.OpenKey)
RegisterCommand('phone', function()
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        TogglePhone()
    end
end)

-- Export Functions
exports('IsPhoneOpen', function()
    return PhoneOpen
end)

exports('GetPhoneData', function()
    return PhoneData
end)
