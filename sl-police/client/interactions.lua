local SLCore = exports['sl-core']:GetCoreObject()
local isHandcuffed = false
local isEscorted = false
local cuffType = 1
local targetPlayer = 0

-- Basic police interactions
local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

-- Handcuff functions
RegisterNetEvent('sl-police:client:GetCuffed', function(playerId, isSoftcuff)
    local ped = PlayerPedId()
    if not isHandcuffed then
        isHandcuffed = true
        TriggerServerEvent("sl-police:server:SetHandcuffStatus", true)
        ClearPedTasksImmediately(ped)
        if GetSelectedPedWeapon(ped) ~= `WEAPON_UNARMED` then
            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
        end
        if not isSoftcuff then
            cuffType = 16
            loadAnimDict("mp_arresting")
            TaskPlayAnim(ped, "mp_arresting", "idle", 8.0, -8, -1, cuffType, 0, 0, 0, 0)
        else
            cuffType = 49
            loadAnimDict("mp_arresting")
            TaskPlayAnim(ped, "mp_arresting", "idle", 8.0, -8, -1, cuffType, 0, 0, 0, 0)
        end
    else
        isHandcuffed = false
        TriggerServerEvent("sl-police:server:SetHandcuffStatus", false)
        ClearPedTasksImmediately(ped)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "Uncuff", 0.2)
    end
end)

-- Escort functions
RegisterNetEvent('sl-police:client:GetEscorted', function(playerId)
    local ped = PlayerPedId()
    if not isEscorted then
        isEscorted = true
        targetPlayer = playerId
        local targetPed = GetPlayerPed(GetPlayerFromServerId(targetPlayer))
        AttachEntityToEntity(ped, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    else
        isEscorted = false
        targetPlayer = 0
        DetachEntity(ped, true, false)
    end
end)

-- Search functions
RegisterNetEvent('sl-police:client:SearchPlayer', function()
    local ped = PlayerPedId()
    loadAnimDict("mp_arresting")
    TaskPlayAnim(ped, "mp_arresting", "a_uncuff", 8.0, -8, -1, 49, 0, 0, 0, 0)
    TriggerServerEvent("sl-police:server:SearchPlayer")
end)

-- Vehicle interactions
RegisterNetEvent('sl-police:client:PutInVehicle', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local vehicle = SLCore.Functions.GetClosestVehicle(coords)
    if DoesEntityExist(vehicle) then
        for i = GetVehicleMaxNumberOfPassengers(vehicle), 1, -1 do
            if IsVehicleSeatFree(vehicle, i) then
                isEscorted = false
                TriggerEvent("sl-police:client:SetOutVehicle")
                SetPedIntoVehicle(ped, vehicle, i)
                return
            end
        end
    end
end)

RegisterNetEvent('sl-police:client:SetOutVehicle', function()
    local ped = PlayerPedId()
    if IsPedSittingInAnyVehicle(ped) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        TaskLeaveVehicle(ped, vehicle, 16)
    end
end)

-- Status check
local function IsPoliceJob()
    local Player = SLCore.Functions.GetPlayerData()
    return Player.job.name == "police"
end

-- Exports
exports('IsHandcuffed', function() return isHandcuffed end)
exports('IsEscorted', function() return isEscorted end)
exports('GetCuffType', function() return cuffType end)
exports('GetTargetPlayer', function() return targetPlayer end)
