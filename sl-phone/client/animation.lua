local SLCore = exports['sl-core']:GetCoreObject()
local phoneProp = 0
local phoneModel = `prop_npc_phone_02`

local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local function newPhoneProp()
    deletePhone()
    RequestModel(phoneModel)
    while not HasModelLoaded(phoneModel) do
        Wait(1)
    end
    phoneProp = CreateObject(phoneModel, 1.0, 1.0, 1.0, 1, 1, 0)
    local bone = GetPedBoneIndex(PlayerPedId(), 28422)
    AttachEntityToEntity(phoneProp, PlayerPedId(), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
end

local function deletePhone()
    if phoneProp ~= 0 then
        DeleteObject(phoneProp)
        phoneProp = 0
    end
end

local function PhonePlayAnim(status)
    local ped = PlayerPedId()
    
    if status then
        loadAnimDict("cellphone@")
        TaskPlayAnim(ped, "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, false, false, false)
        newPhoneProp()
    else
        StopAnimTask(ped, "cellphone@", "cellphone_text_read_base", 1.0)
        deletePhone()
    end
end

local function PhonePlayOut()
    local ped = PlayerPedId()
    loadAnimDict("cellphone@")
    TaskPlayAnim(ped, "cellphone@", "cellphone_text_out", 2.0, 1.0, 1000, 49, 0, false, false, false)
    Wait(700)
    deletePhone()
end

local function PhonePlayIn()
    local ped = PlayerPedId()
    loadAnimDict("cellphone@")
    TaskPlayAnim(ped, "cellphone@", "cellphone_text_in", 2.0, 1.0, 1000, 49, 0, false, false, false)
    Wait(700)
    newPhoneProp()
end

RegisterNetEvent('sl-phone:client:AnimatePhone')
AddEventHandler('sl-phone:client:AnimatePhone', function(status)
    if status then
        PhonePlayIn()
    else
        PhonePlayOut()
    end
end)

exports('PhonePlayAnim', PhonePlayAnim)
exports('newPhoneProp', newPhoneProp)
exports('deletePhone', deletePhone)
