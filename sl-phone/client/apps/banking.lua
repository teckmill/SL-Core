local SLCore = exports['sl-core']:GetCoreObject()

-- NUI Callbacks
RegisterNUICallback('GetBankData', function(data, cb)
    SLCore.Functions.TriggerCallback('sl-phone:server:GetBankData', function(bankData)
        cb(bankData)
    end)
end)

RegisterNUICallback('TransferMoney', function(data, cb)
    if not data.amount or not data.recipient then return end
    TriggerServerEvent('sl-phone:server:TransferMoney', data)
    cb('ok')
end)

RegisterNUICallback('GetTransactions', function(data, cb)
    SLCore.Functions.TriggerCallback('sl-phone:server:GetTransactions', function(transactions)
        cb(transactions)
    end)
end)

-- Events
RegisterNetEvent('sl-phone:client:UpdateBankData', function(bankData)
    SendNUIMessage({
        action = "UpdateBankData",
        data = bankData
    })
end) 