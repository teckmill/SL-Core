local SLCore = exports['sl-core']:GetCoreObject()
local PlayerData = {}
local CurrentWeaponData = {}
local CurrentInventoryData = {}

-- Basic inventory functions
function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

function FormatNumber(number)
    local formatted = number
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

function GetClosestVending()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local object = nil
    for _, machine in pairs(Config.VendingObjects) do
        local ClosestObject = GetClosestObjectOfType(pos.x, pos.y, pos.z, 0.75, GetHashKey(machine), 0, 0, 0)
        if ClosestObject ~= 0 then
            if object == nil then
                object = ClosestObject
            end
        end
    end
    return object
end

function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function OpenInventory(invType, data)
    local PlayerData = SLCore.Functions.GetPlayerData()
    if PlayerData.metadata["isdead"] or PlayerData.metadata["inlaststand"] then return end
    
    SendNUIMessage({
        action = "open",
        type = invType,
        data = data,
        slots = Config.MaxInventorySlots
    })
    SetNuiFocus(true, true)
end

RegisterNetEvent('sl-inventory:client:RefreshInventory')
AddEventHandler('sl-inventory:client:RefreshInventory', function(data)
    CurrentInventoryData = data
    SendNUIMessage({
        action = "refresh",
        data = data
    })
end)
