SLCore = {}
SLCore.PlayerData = {}
SLCore.Config = SLConfig
SLCore.Functions = {}
SLCore.RequestId = 0
SLCore.ServerCallbacks = {}
SLCore.TimeoutCallbacks = {}

function SLCore.Functions.GetPlayerData(cb)
    if cb then
        cb(SLCore.PlayerData)
    else
        return SLCore.PlayerData
    end
end

function SLCore.Functions.DrawText(x, y, width, height, scale, r, g, b, a, text)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function SLCore.Functions.Notify(text, type, length)
    if type == nil then type = "primary" end
    if length == nil then length = 5000 end
    SendNUIMessage({
        action = 'notify',
        type = type,
        length = length,
        text = text,
    })
end

function SLCore.Functions.TriggerCallback(name, cb, ...)
    SLCore.ServerCallbacks[SLCore.RequestId] = cb
    TriggerServerEvent('sl-core:server:triggerCallback', name, SLCore.RequestId, ...)
    SLCore.RequestId = SLCore.RequestId + 1
end

-- Events
RegisterNetEvent('sl-core:client:updatePlayerData')
AddEventHandler('sl-core:client:updatePlayerData', function(data)
    SLCore.PlayerData = data
end)

RegisterNetEvent('sl-core:client:moneyChange')
AddEventHandler('sl-core:client:moneyChange', function(type, amount, operation, reason)
    if operation == "add" then
        SLCore.Functions.Notify('$'..amount..' added ('..reason..')', 'success')
    else
        SLCore.Functions.Notify('$'..amount..' removed ('..reason..')', 'error')
    end
end)

-- Export
exports('GetCoreObject', function()
    return SLCore
end)

-- Initialize
Citizen.CreateThread(function()
    while true do
        SetCanAttackFriendly(PlayerPedId(), true, false)
        NetworkSetFriendlyFireOption(true)
        Citizen.Wait(100)
    end
end)
