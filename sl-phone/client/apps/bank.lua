local SLCore = exports['sl-core']:GetCoreObject()

-- NUI Callbacks
RegisterNUICallback('GetBankData', function(data, cb)
    SLCore.Functions.TriggerCallback('sl-phone:server:GetBankData', function(bankData)
        cb(bankData)
    end)
end)

RegisterNUICallback('TransferMoney', function(data, cb)
    if not data.recipient or not data.amount then return end
    if tonumber(data.amount) <= 0 then return end
    
    SLCore.Functions.TriggerCallback('sl-phone:server:TransferMoney', function(success, message)
        cb({success = success, message = message})
    end, data.recipient, tonumber(data.amount))
end)

RegisterNUICallback('RequestMoney', function(data, cb)
    if not data.target or not data.amount or not data.reason then return end
    if tonumber(data.amount) <= 0 then return end
    
    TriggerServerEvent('sl-phone:server:RequestMoney', {
        target = data.target,
        amount = tonumber(data.amount),
        reason = data.reason
    })
    cb('ok')
end)

-- Events
RegisterNetEvent('sl-phone:client:UpdateBank', function(balance)
    SendNUIMessage({
        action = "UpdateBankBalance",
        balance = balance
    })
end)

RegisterNetEvent('sl-phone:client:TransactionComplete', function(data)
    SendNUIMessage({
        action = "TransactionComplete",
        data = data
    })
end)

RegisterNetEvent('sl-phone:client:MoneyRequest', function(data)
    SendNUIMessage({
        action = "MoneyRequest",
        data = data
    })
end)
