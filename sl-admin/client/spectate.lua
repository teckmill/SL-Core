local SLCore = exports['sl-core']:GetCoreObject()

local isSpectating = false
local lastCoords = nil
local spectateCoords = nil
local spectateTarget = nil

local function startSpectating(targetPed)
    if not DoesEntityExist(targetPed) then return end
    
    local playerPed = PlayerPedId()
    lastCoords = GetEntityCoords(playerPed)
    
    SetEntityVisible(playerPed, false, false)
    SetEntityInvincible(playerPed, true)
    SetEntityCollision(playerPed, false, false)
    
    NetworkSetInSpectatorMode(true, targetPed)
    isSpectating = true
end

local function stopSpectating()
    if not isSpectating then return end
    
    local playerPed = PlayerPedId()
    
    NetworkSetInSpectatorMode(false, spectateTarget)
    SetEntityCoords(playerPed, lastCoords.x, lastCoords.y, lastCoords.z, false, false, false, false)
    
    SetEntityVisible(playerPed, true, false)
    SetEntityInvincible(playerPed, false)
    SetEntityCollision(playerPed, true, true)
    
    isSpectating = false
    spectateTarget = nil
    lastCoords = nil
end

-- Event Handlers
RegisterNetEvent('sl-admin:client:SpectatePlayer', function(targetId)
    if isSpectating then
        stopSpectating()
        return
    end
    
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
    if targetPed == PlayerPedId() then
        SLCore.Functions.Notify('You cannot spectate yourself', 'error')
        return
    end
    
    if DoesEntityExist(targetPed) then
        spectateTarget = targetPed
        startSpectating(targetPed)
        SLCore.Functions.Notify('Now spectating player', 'success')
    else
        SLCore.Functions.Notify('Target player not found', 'error')
    end
end)

RegisterNetEvent('sl-admin:client:StopSpectating', function()
    if isSpectating then
        stopSpectating()
        SLCore.Functions.Notify('Stopped spectating', 'primary')
    end
end)

-- Commands
RegisterCommand('spectate', function(source, args)
    if not SLCore.Functions.HasPermission('admin') then return end
    
    if not args[1] then
        SLCore.Functions.Notify('Please specify a player ID', 'error')
        return
    end
    
    local targetId = tonumber(args[1])
    if not targetId then
        SLCore.Functions.Notify('Invalid player ID', 'error')
        return
    end
    
    TriggerServerEvent('sl-admin:server:SpectatePlayer', targetId)
end)

-- Main Thread for Spectate Controls
CreateThread(function()
    while true do
        Wait(0)
        if isSpectating then
            -- ESC to stop spectating
            if IsControlJustPressed(0, 200) then
                TriggerEvent('sl-admin:client:StopSpectating')
            end
            
            -- Display spectate info
            DrawText2D('Spectating - Press ESC to stop', 0.5, 0.95)
        else
            Wait(500)
        end
    end
end)

-- Utility Functions
function DrawText2D(text, x, y)
    SetTextFont(4)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
    
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end
