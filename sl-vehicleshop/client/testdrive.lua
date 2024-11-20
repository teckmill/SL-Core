local SLCore = exports['sl-core']:GetCoreObject()
local testDriveVeh = nil
local inTestDrive = false
local testDriveTimer = 0
local testDriveCoords = nil
local testDriveSpawn = nil

-- Core Functions
function StartTestDrive(model, shop)
    if inTestDrive then return end
    
    local shopConfig = Config.Shops[shop]
    if not shopConfig then return end
    
    testDriveCoords = GetEntityCoords(PlayerPedId())
    testDriveSpawn = shopConfig.testDrive.spawnPoint
    testDriveTimer = Config.TestDriveTime
    
    SLCore.Functions.SpawnVehicle(model, function(veh)
        SetEntityCoords(veh, testDriveSpawn.x, testDriveSpawn.y, testDriveSpawn.z)
        SetEntityHeading(veh, testDriveSpawn.w)
        SetVehicleNumberPlateText(veh, 'TEST')
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent('vehiclekeys:client:SetOwner', GetVehicleNumberPlateText(veh))
        testDriveVeh = veh
        inTestDrive = true
        StartTestDriveTimer()
    end, testDriveSpawn, true)
end

function EndTestDrive()
    if not inTestDrive then return end
    
    if DoesEntityExist(testDriveVeh) then
        SLCore.Functions.DeleteVehicle(testDriveVeh)
    end
    
    inTestDrive = false
    testDriveVeh = nil
    testDriveTimer = 0
    
    -- Teleport player back to shop
    SetEntityCoords(PlayerPedId(), testDriveCoords.x, testDriveCoords.y, testDriveCoords.z)
end

function StartTestDriveTimer()
    CreateThread(function()
        while inTestDrive do
            if testDriveTimer > 0 then
                testDriveTimer = testDriveTimer - 1
                SLCore.Functions.Notify('Test Drive Time: '..testDriveTimer..' seconds remaining', 'primary')
            else
                EndTestDrive()
                SLCore.Functions.Notify('Test drive ended', 'error')
            end
            Wait(1000)
        end
    end)
end

-- Events
RegisterNetEvent('sl-vehicleshop:client:TestDrive', function(model, shop)
    StartTestDrive(model, shop)
end)

RegisterNetEvent('sl-vehicleshop:client:EndTestDrive', function()
    EndTestDrive()
end)

-- Cleanup
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if inTestDrive then
        EndTestDrive()
    end
end)

-- Commands (for debugging)
if Config.Debug then
    RegisterCommand('endtestdrive', function()
        EndTestDrive()
    end, false)
end
