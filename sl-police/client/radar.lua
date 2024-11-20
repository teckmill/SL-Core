local SLCore = exports['sl-core']:GetCoreObject()
local radarActive = false
local frontPlate = nil
local rearPlate = nil
local radarInfo = {
    frontSpeed = "0",
    rearSpeed = "0",
    frontPlate = "",
    rearPlate = ""
}

-- Radar Functions
function ToggleRadar()
    radarActive = not radarActive
    if radarActive then
        RunRadarLoop()
    end
end

function RunRadarLoop()
    CreateThread(function()
        while radarActive do
            -- Front radar
            local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
            if playerVeh ~= 0 then
                local coordA = GetOffsetFromEntityInWorldCoords(playerVeh, 0.0, 1.0, 1.0)
                local coordB = GetOffsetFromEntityInWorldCoords(playerVeh, 0.0, 105.0, 0.0)
                local frontVeh = StartShapeTestCapsule(coordA, coordB, 3.0, 10, playerVeh, 7)
                local _, _, _, _, frontVehicle = GetShapeTestResult(frontVeh)
                
                if frontVehicle ~= 0 then
                    local fSpeed = GetEntitySpeed(frontVehicle) * 2.236936
                    local fVehPlate = GetVehicleNumberPlateText(frontVehicle)
                    radarInfo.frontPlate = fVehPlate
                    radarInfo.frontSpeed = math.ceil(fSpeed)
                end
            end
            
            -- Rear radar
            -- Similar logic for rear radar
            
            SendNUIMessage({
                action = "updateRadar",
                data = radarInfo
            })
            
            Wait(150)
        end
    end)
end

-- Commands
RegisterCommand('radar', function()
    if PlayerData.job.name == "police" then
        ToggleRadar()
    end
end)

-- Exports
exports('ToggleRadar', ToggleRadar) 