local SLCore = exports['sl-core']:GetCoreObject()
local isOnDuty = false
local currentHospital = nil

-- Function to toggle duty status
RegisterNetEvent('sl-ambulance:client:ToggleDuty', function()
    isOnDuty = not isOnDuty
    TriggerServerEvent('sl-ambulance:server:UpdateDutyStatus', isOnDuty)
    
    if isOnDuty then
        SLCore.Functions.Notify(Lang:t('info.on_duty'), 'success')
    else
        SLCore.Functions.Notify(Lang:t('info.off_duty'), 'error')
    end
end)

-- Function to check in at hospital
RegisterNetEvent('sl-ambulance:client:CheckIn', function(hospital)
    if not isOnDuty then
        SLCore.Functions.Notify(Lang:t('error.not_on_duty'), 'error')
        return
    end
    
    currentHospital = hospital
    SLCore.Functions.Notify(Lang:t('info.checked_in', {hospital = hospital}), 'success')
    TriggerServerEvent('sl-ambulance:server:UpdateHospital', hospital)
end)

-- Function to check out from hospital
RegisterNetEvent('sl-ambulance:client:CheckOut', function()
    if not currentHospital then return end
    
    currentHospital = nil
    SLCore.Functions.Notify(Lang:t('info.checked_out'), 'primary')
    TriggerServerEvent('sl-ambulance:server:UpdateHospital', nil)
end)

-- Function to handle EMS alerts
RegisterNetEvent('sl-ambulance:client:EMSAlert', function(coords, text)
    if not isOnDuty then return end
    
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 61)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 1)
    SetBlipScale(blip, 0.8)
    SetBlipFlashes(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('EMS Alert')
    EndTextCommandSetBlipName(blip)
    
    SLCore.Functions.Notify(text, 'ambulance')
    
    -- Remove blip after 2 minutes
    Citizen.SetTimeout(120000, function()
        RemoveBlip(blip)
    end)
end)

-- Function to get current duty status
exports('IsOnDuty', function()
    return isOnDuty
end)

-- Function to get current hospital
exports('GetCurrentHospital', function()
    return currentHospital
end)
