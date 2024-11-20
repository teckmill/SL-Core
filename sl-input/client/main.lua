local SLCore = exports['sl-core']:GetCoreObject()

-- Variables
local input = {
    type = "text", -- default input type
    title = "",
    text = "",
    options = {}
}

-- Functions
local function openInput(data)
    if not data then return end
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "OPEN_MENU",
        data = data
    })
end

exports("ShowInput", openInput)

-- NUI Callbacks
RegisterNUICallback('submit', function(data, cb)
    SetNuiFocus(false, false)
    if data.response then
        TriggerEvent('sl-input:client:submitInput', data.response)
    end
    cb('ok')
end)

RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)
