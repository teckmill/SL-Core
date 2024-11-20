local isPhoneOpen = false

-- NUI Callback handler
RegisterNUICallback('phoneEvent', function(data, cb)
    if data.action == 'close' then
        SetNuiFocus(false, false)
        isPhoneOpen = false
        TriggerEvent('sl-phone:client:phoneStateChanged', false)
    elseif data.action == 'appOpened' then
        TriggerEvent('sl-phone:client:appOpened', data.app)
    end
    cb('ok')
end)

-- Toggle phone visibility
RegisterNetEvent('sl-phone:client:togglePhone')
AddEventHandler('sl-phone:client:togglePhone', function()
    isPhoneOpen = not isPhoneOpen
    
    if isPhoneOpen then
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'open'
        })
    else
        SetNuiFocus(false, false)
        SendNUIMessage({
            action = 'close'
        })
    end
    
    TriggerEvent('sl-phone:client:phoneStateChanged', isPhoneOpen)
end)

-- Update phone data
RegisterNetEvent('sl-phone:client:updatePhoneData')
AddEventHandler('sl-phone:client:updatePhoneData', function(data)
    if isPhoneOpen then
        SendNUIMessage({
            action = 'updateData',
            data = data
        })
    end
end)

-- Check if phone is open
function IsPhoneOpen()
    return isPhoneOpen
end

exports('IsPhoneOpen', IsPhoneOpen)
