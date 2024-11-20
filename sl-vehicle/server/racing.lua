local SLCore = nil
local CoreReady = false

-- Initialize core
CreateThread(function()
    while SLCore == nil do
        if GetResourceState('sl-core') == 'started' then
            SLCore = exports['sl-core']:GetCoreObject()
            if SLCore then
                CoreReady = true
                break
            end
        end
        Wait(100)
    end
end)

-- Racing data tables
local ActiveRaces = {}
local RaceHistory = {}

-- Racing Functions
local function CreateRace(source, data)
    if not CoreReady then return false end
    
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local raceId = #ActiveRaces + 1
    ActiveRaces[raceId] = {
        creator = Player.PlayerData.citizenid,
        name = data.name,
        checkpoints = data.checkpoints,
        laps = data.laps or 1,
        participants = {},
        started = false,
        finished = false,
        startTime = 0,
        bestLap = nil,
        bestOverall = nil
    }
    
    return raceId
end

local function JoinRace(source, raceId)
    if not CoreReady or not ActiveRaces[raceId] then return false end
    
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    if not ActiveRaces[raceId].started then
        ActiveRaces[raceId].participants[Player.PlayerData.citizenid] = {
            checkpoint = 0,
            lap = 0,
            finished = false,
            bestLap = nil,
            startTime = 0
        }
        return true
    end
    
    return false
end

-- Events
RegisterNetEvent('sl-vehicle:server:CreateRace', function(data)
    local source = source
    local raceId = CreateRace(source, data)
    if raceId then
        TriggerClientEvent('sl-vehicle:client:RaceCreated', source, raceId)
    end
end)

RegisterNetEvent('sl-vehicle:server:JoinRace', function(raceId)
    local source = source
    local success = JoinRace(source, raceId)
    if success then
        TriggerClientEvent('sl-vehicle:client:RaceJoined', source, raceId)
    end
end)

-- Exports
exports('GetActiveRaces', function()
    return ActiveRaces
end)

exports('GetRaceHistory', function()
    return RaceHistory
end)
