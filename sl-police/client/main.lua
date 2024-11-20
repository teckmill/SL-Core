local SLCore = exports['sl-core']:GetCoreObject()
local isHandcuffed = false
local cuffType = nil
local isEscorted = false
local draggerId = 0
local isDead = false

-- Initialize
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    PlayerData = SLCore.Functions.GetPlayerData()
    if PlayerData.job.name == "police" then
        local duty = PlayerData.job.onduty
        TriggerServerEvent("sl-police:server:UpdateCurrentCops")
        InitDutyZones()
    end
end)

RegisterNetEvent('police:client:SetHandcuffStatus', function(cuffed, type)
    isHandcuffed = cuffed
    cuffType = type
end)

RegisterNetEvent('police:client:GetCuffed', function(playerId, isSoftcuff)
    local ped = PlayerPedId()
    if not isHandcuffed then
        isHandcuffed = true
        TriggerServerEvent("police:server:SetHandcuffStatus", true)
        ClearPedTasksImmediately(ped)
        if GetSelectedPedWeapon(ped) ~= GetHashKey('WEAPON_UNARMED') then
            SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
        end
        if not isSoftcuff then
            cuffType = 16
            GetCuffedAnimation()
            SLCore.Functions.Notify("You are cuffed!")
        else
            cuffType = 49
            GetCuffedAnimation()
            SLCore.Functions.Notify("You are cuffed, but you can walk")
        end
    else
        isHandcuffed = false
        isEscorted = false
        TriggerEvent('hospital:client:isEscorted', isEscorted)
        DetachEntity(ped, true, false)
        TriggerServerEvent("police:server:SetHandcuffStatus", false)
        ClearPedTasksImmediately(ped)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "Uncuff", 0.2)
        SLCore.Functions.Notify("You are uncuffed!")
    end
end)

-- Functions
function GetCuffedAnimation()
    local ped = PlayerPedId()
    local cuffer = GetPlayerPed(GetPlayerFromServerId(cufferId))
    local heading = GetEntityHeading(cuffer)
    loadAnimDict("mp_arrest_paired")
    SetEntityCoords(ped, GetOffsetFromEntityInWorldCoords(cuffer, 0.0, 0.45, 0.0))
    
    SetEntityHeading(ped, heading)
    TaskPlayAnim(ped, "mp_arrest_paired", "crook_p2_back_right", 3.0, 3.0, -1, 32, 0, 0, 0, 0, false, false, false)
    Wait(2500)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(0)
    end
end

-- Exports
exports('IsHandcuffed', function()
    return isHandcuffed
end) 