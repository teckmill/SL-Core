local SLCore = exports['sl-core']:GetCoreObject()

-- NUI Callbacks
RegisterNUICallback('GetContacts', function(data, cb)
    SLCore.Functions.TriggerCallback('sl-phone:server:GetContacts', function(contacts)
        cb(contacts)
    end)
end)

RegisterNUICallback('AddContact', function(data, cb)
    if not data.name or not data.number then return end
    TriggerServerEvent('sl-phone:server:AddContact', data)
    cb('ok')
end)

RegisterNUICallback('DeleteContact', function(data, cb)
    if not data.id then return end
    TriggerServerEvent('sl-phone:server:DeleteContact', data.id)
    cb('ok')
end)

RegisterNUICallback('UpdateContact', function(data, cb)
    if not data.id then return end
    TriggerServerEvent('sl-phone:server:UpdateContact', data)
    cb('ok')
end)

-- Events
RegisterNetEvent('sl-phone:client:RefreshContacts', function(contacts)
    SendNUIMessage({
        action = "UpdateContacts",
        contacts = contacts
    })
end)
