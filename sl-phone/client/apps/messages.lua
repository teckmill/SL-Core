local SLCore = exports['sl-core']:GetCoreObject()

-- NUI Callbacks
RegisterNUICallback('GetMessages', function(data, cb)
    SLCore.Functions.TriggerCallback('sl-phone:server:GetMessages', function(messages)
        cb(messages)
    end)
end)

RegisterNUICallback('SendMessage', function(data, cb)
    if not data.receiver or not data.message then return end
    TriggerServerEvent('sl-phone:server:SendMessage', data)
    cb('ok')
end)

RegisterNUICallback('DeleteMessage', function(data, cb)
    if not data.id then return end
    TriggerServerEvent('sl-phone:server:DeleteMessage', data.id)
    cb('ok')
end)

RegisterNUICallback('DeleteConversation', function(data, cb)
    if not data.number then return end
    TriggerServerEvent('sl-phone:server:DeleteConversation', data.number)
    cb('ok')
end)

-- Events
RegisterNetEvent('sl-phone:client:ReceiveMessage', function(data)
    -- Play notification sound
    SendNUIMessage({
        action = "PlayNotification",
        sound = "message"
    })
    
    -- Update messages UI
    SendNUIMessage({
        action = "RefreshMessages",
        message = data
    })
    
    -- Show notification if phone is closed
    if not exports['sl-phone']:IsPhoneOpen() then
        TriggerEvent('sl-core:client:Notify', {
            title = "New Message",
            text = "From: " .. data.sender .. "\nMessage: " .. data.message,
            type = "message"
        })
    end
end)

RegisterNetEvent('sl-phone:client:MessageDeleted', function(id)
    SendNUIMessage({
        action = "RefreshMessages"
    })
end)

RegisterNetEvent('sl-phone:client:ConversationDeleted', function(number)
    SendNUIMessage({
        action = "RefreshMessages"
    })
end)
