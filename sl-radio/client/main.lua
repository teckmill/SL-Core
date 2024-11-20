local SLCore = exports['sl-core']:GetCoreObject()
local PlayerData = SLCore.Functions.GetPlayerData()
local radioMenu = false
local onRadio = false
local RadioChannel = 0

-- Functions
local function LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end
end

local function SplitStr(str, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(str, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
    end
    table.insert(result, string.sub(str, from))
    return result
end

local function connectToRadio(channel)
    if onRadio then
        exports["pma-voice"]:setRadioChannel(0)
    else
        exports["pma-voice"]:setRadioChannel(channel)
        if SLCore.Functions.GetPlayerData().job.name == "police" then
            exports["pma-voice"]:setRadioVolume(0.5)
        end
    end
end

local function toggleRadio(toggle)
    radioMenu = toggle
    SetNuiFocus(radioMenu, radioMenu)
    if radioMenu then
        SendNUIMessage({
            type = "open",
        })
    else
        SendNUIMessage({
            type = "close",
        })
    end
end

local function closeEvent()
    toggleRadio(false)
end

local function enterRadio(channel)
    if not channel then return end
    
    SLCore.Functions.TriggerCallback('sl-radio:server:GetItem', function(hasItem)
        if hasItem then
            if tonumber(channel) <= Config.MaxFrequency and tonumber(channel) ~= 0 then
                if tonumber(channel) <= Config.RestrictedChannels then
                    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
                        connectToRadio(channel)
                        TriggerServerEvent('sl-radio:server:JoinRadio', channel)
                    else
                        SLCore.Functions.Notify(Lang:t('error.restricted_channel'), 'error')
                    end
                else
                    connectToRadio(channel)
                    TriggerServerEvent('sl-radio:server:JoinRadio', channel)
                end
            else
                SLCore.Functions.Notify(Lang:t('error.invalid_channel'), 'error')
            end
        end
    end, "radio")
end

-- Events
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    PlayerData = SLCore.Functions.GetPlayerData()
end)

RegisterNetEvent('SLCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('sl-radio:client:JoinRadio', function(channel)
    LoadAnimDict("cellphone@")
    TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, false, false, false)
    RadioChannel = channel
    onRadio = true
end)

RegisterNetEvent('sl-radio:client:LeaveRadio', function()
    RadioChannel = 0
    onRadio = false
    exports["pma-voice"]:setRadioChannel(0)
    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
    StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 1.0)
end)

RegisterNetEvent('sl-radio:client:UseRadio', function()
    toggleRadio(not radioMenu)
end)

-- NUI Callbacks
RegisterNUICallback('joinRadio', function(data, cb)
    local rchannel = tonumber(data.channel)
    if rchannel ~= nil then
        enterRadio(rchannel)
    end
    cb('ok')
end)

RegisterNUICallback('leaveRadio', function(_, cb)
    TriggerServerEvent('sl-radio:server:LeaveRadio')
    cb('ok')
end)

RegisterNUICallback('escape', function(_, cb)
    toggleRadio(false)
    cb('ok')
end)

-- Command
RegisterCommand('radio', function()
    if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] then
        SLCore.Functions.TriggerCallback('sl-radio:server:GetItem', function(hasItem)
            if hasItem then
                toggleRadio(not radioMenu)
            end
        end, "radio")
    end
end)

-- Resource cleanup
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if radioMenu then
            toggleRadio(false)
        end
    end
end)
