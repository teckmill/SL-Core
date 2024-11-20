local SLCore = exports['sl-core']:GetCoreObject()

-- Utility Functions
function GetPlayerByPhone(phone)
    local Players = SLCore.Functions.GetPlayers()
    for _, v in pairs(Players) do
        local Player = SLCore.Functions.GetPlayer(v)
        if Player.PlayerData.charinfo.phone == phone then
            return Player
        end
    end
    return nil
end

function GetPlayerByCitizenId(citizenid)
    local Players = SLCore.Functions.GetPlayers()
    for _, v in pairs(Players) do
        local Player = SLCore.Functions.GetPlayer(v)
        if Player.PlayerData.citizenid == citizenid then
            return Player
        end
    end
    return nil
end

function IsPlayerNearCoords(playerId, coords, distance)
    local Player = SLCore.Functions.GetPlayer(playerId)
    if not Player then return false end
    
    local ped = GetPlayerPed(playerId)
    local playerCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - coords)
    
    return dist <= distance
end

function SendDistanceMessage(coords, distance, message, messageType)
    local Players = SLCore.Functions.GetPlayers()
    for _, playerId in pairs(Players) do
        if IsPlayerNearCoords(playerId, coords, distance) then
            TriggerClientEvent('sl-core:client:Notify', playerId, message, messageType)
        end
    end
end

-- Export Functions
exports('GetPlayerByPhone', GetPlayerByPhone)
exports('GetPlayerByCitizenId', GetPlayerByCitizenId)
exports('IsPlayerNearCoords', IsPlayerNearCoords)
exports('SendDistanceMessage', SendDistanceMessage)
