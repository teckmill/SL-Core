local SLCore = exports['sl-core']:GetCoreObject()

-- Money Variables
local isEnabled = true
local showConstantly = false
local displayTime = 5000 -- Time to show money updates (ms)
local hideTimer = nil

-- Format Money
local function FormatMoney(amount)
    local formatted = amount
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

-- Update Money Display
local function UpdateMoneyHUD(cash, bank, crypto)
    if not isEnabled then return end
    
    SendNUIMessage({
        action = "updateMoney",
        cash = FormatMoney(cash),
        bank = FormatMoney(bank),
        crypto = crypto and FormatMoney(crypto) or "0",
        show = true
    })
    
    -- Reset hide timer
    if hideTimer then
        RemoveTimer(hideTimer)
    end
    
    -- Hide after display time unless showConstantly is true
    if not showConstantly then
        hideTimer = SetTimeout(displayTime, function()
            SendNUIMessage({
                action = "updateMoney",
                show = false
            })
            hideTimer = nil
        end)
    end
end

-- Money Update Events
RegisterNetEvent('sl-hud:client:UpdateMoney')
AddEventHandler('sl-hud:client:UpdateMoney', function(cash, bank, crypto)
    UpdateMoneyHUD(cash, bank, crypto)
end)

-- Toggle Money Display
RegisterCommand('togglemoney', function()
    isEnabled = not isEnabled
    SendNUIMessage({
        action = "updateMoney",
        show = isEnabled and showConstantly
    })
end)

-- Toggle Constant Display
RegisterCommand('toggleconstantmoney', function()
    showConstantly = not showConstantly
    if not showConstantly and hideTimer then
        RemoveTimer(hideTimer)
        SendNUIMessage({
            action = "updateMoney",
            show = false
        })
    elseif showConstantly then
        -- Request current money values from server
        TriggerServerEvent('sl-hud:server:RequestMoney')
    end
end)

-- Initialize Money Display
CreateThread(function()
    Wait(1000)
    -- Request initial money values from server
    TriggerServerEvent('sl-hud:server:RequestMoney')
end)
