SLCore.Functions = {}

function SLCore.Functions.GetPlayerData(cb)
    if cb then
        cb(SLCore.PlayerData)
    else
        return SLCore.PlayerData
    end
end

function SLCore.Functions.TriggerCallback(name, cb, ...)
    SLCore.ServerCallbacks[name] = cb
    TriggerServerEvent('SLCore:Server:TriggerCallback', name, ...)
end

function SLCore.Functions.Notify(text, texttype, length)
    if type(text) == "table" then
        local ttext = text.text or 'Placeholder'
        local caption = text.caption or 'Placeholder'
        texttype = texttype or 'primary'
        length = length or 5000
        SendNUIMessage({
            action = 'notify',
            type = texttype,
            length = length,
            text = ttext,
            caption = caption
        })
    else
        texttype = texttype or 'primary'
        length = length or 5000
        SendNUIMessage({
            action = 'notify',
            type = texttype,
            length = length,
            text = text
        })
    end
end

RegisterNetEvent('SLCore:Client:TriggerCallback', function(name, ...)
    if SLCore.ServerCallbacks[name] then
        SLCore.ServerCallbacks[name](...)
        SLCore.ServerCallbacks[name] = nil
    end
end)
