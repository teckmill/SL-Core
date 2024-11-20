local SLCore = exports['sl-core']:GetCoreObject()

local isInRace = false
local currentRace = nil
local currentCheckpoint = 0
local raceBlips = {}
local checkpointBlips = {}
local raceCountdown = 0

-- Race Functions
function StartRace(raceData)
    if isInRace then return end
    
    isInRace = true
    currentRace = raceData
    currentCheckpoint = 1
    raceCountdown = 3
    
    -- Create race blips
    CreateRaceBlips()
    
    -- Start countdown
    CreateThread(function()
        while raceCountdown > 0 do
            SLCore.Functions.Notify(raceCountdown, 'primary', 1000)
            raceCountdown = raceCountdown - 1
            Wait(1000)
        end
        
        SLCore.Functions.Notify('GO!', 'success', 1000)
        StartRaceTimer()
    end)
end

function CreateRaceBlips()
    for i, checkpoint in ipairs(currentRace.checkpoints) do
        local blip = AddBlipForCoord(checkpoint.x, checkpoint.y, checkpoint.z)
        SetBlipSprite(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, i == currentCheckpoint and 84 or 4)
        SetBlipRoute(blip, i == currentCheckpoint)
        table.insert(checkpointBlips, blip)
    end
    
    -- Create finish line blip
    local finishBlip = AddBlipForCoord(currentRace.finish.x, currentRace.finish.y, currentRace.finish.z)
    SetBlipSprite(finishBlip, 38)
    SetBlipDisplay(finishBlip, 4)
    SetBlipScale(finishBlip, 1.0)
    SetBlipAsShortRange(finishBlip, true)
    SetBlipColour(finishBlip, 5)
    table.insert(raceBlips, finishBlip)
end

function UpdateRaceBlips()
    for i, blip in ipairs(checkpointBlips) do
        SetBlipColour(blip, i == currentCheckpoint and 84 or 4)
        SetBlipRoute(blip, i == currentCheckpoint)
    end
end

function StartRaceTimer()
    CreateThread(function()
        local startTime = GetGameTimer()
        
        while isInRace do
            local currentTime = GetGameTimer() - startTime
            local minutes = math.floor(currentTime / 60000)
            local seconds = math.floor((currentTime - minutes * 60000) / 1000)
            local milliseconds = currentTime - minutes * 60000 - seconds * 1000
            
            DrawText2D(string.format('%02d:%02d.%03d', minutes, seconds, milliseconds), 0.5, 0.95)
            
            Wait(0)
        end
    end)
end

function DrawText2D(text, x, y)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.45, 0.45)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Events
RegisterNetEvent('sl-racing:client:StartRace', function(raceData)
    StartRace(raceData)
end)

RegisterNetEvent('sl-racing:client:RaceFinished', function(position, totalTime)
    isInRace = false
    currentRace = nil
    currentCheckpoint = 0
    
    -- Clean up blips
    for _, blip in ipairs(checkpointBlips) do
        RemoveBlip(blip)
    end
    for _, blip in ipairs(raceBlips) do
        RemoveBlip(blip)
    end
    checkpointBlips = {}
    raceBlips = {}
    
    -- Show finish notification
    SLCore.Functions.Notify(string.format('Race finished! Position: %d, Time: %s', position, totalTime), 'success', 5000)
end)

-- Main Thread
CreateThread(function()
    while true do
        Wait(0)
        if isInRace and currentRace and currentCheckpoint > 0 then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            
            if currentCheckpoint <= #currentRace.checkpoints then
                local checkpoint = currentRace.checkpoints[currentCheckpoint]
                local distance = #(playerCoords - vector3(checkpoint.x, checkpoint.y, checkpoint.z))
                
                if distance < 5.0 then
                    currentCheckpoint = currentCheckpoint + 1
                    UpdateRaceBlips()
                    if currentCheckpoint <= #currentRace.checkpoints then
                        SLCore.Functions.Notify(string.format('Checkpoint %d/%d', currentCheckpoint - 1, #currentRace.checkpoints), 'primary', 2000)
                    end
                end
            else
                local finishDistance = #(playerCoords - vector3(currentRace.finish.x, currentRace.finish.y, currentRace.finish.z))
                if finishDistance < 5.0 then
                    TriggerServerEvent('sl-racing:server:FinishRace', currentRace.id)
                end
            end
        end
    end
end)
