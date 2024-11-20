local SLCore = exports['sl-core']:GetCoreObject()
local TestDriveVehicle = nil
local TestDriveTimer = 0
local InTestDrive = false
local StartCoords = nil

-- Start Test Drive
RegisterNetEvent('sl-dealership:client:StartTestDrive', function(data)
    local vehicle = data.vehicle
    local dealership = Config.Dealerships[CurrentDealership]
    
    SLCore.Functions.TriggerCallback('sl-dealership:server:StartTestDrive', function(success)
        if success then
            -- Spawn test drive vehicle
            local coords = dealership.testDrive.returnLocation
            TestDriveVehicle = exports['sl-vehicles']:SpawnVehicle(vehicle.model, coords, true)
            
            if TestDriveVehicle then
                -- Set up vehicle
                SetVehicleNumberPlateText(TestDriveVehicle, "TEST")
                SetEntityHeading(TestDriveVehicle, coords.w)
                SetVehicleFuelLevel(TestDriveVehicle, 100.0)
                SetVehicleEngineOn(TestDriveVehicle, true, true, false)
                
                -- Start test drive
                StartCoords = coords
                InTestDrive = true
                TestDriveTimer = dealership.testDrive.duration
                
                -- Set player into vehicle
                TaskWarpPedIntoVehicle(PlayerPedId(), TestDriveVehicle, -1)
                
                -- Start timers
                StartTestDriveTimers()
            end
        else
            SLCore.Functions.Notify('You cannot afford the test drive deposit!', 'error')
        end
    end, dealership.testDrive.deposit)
end)

-- Test Drive Timers
function StartTestDriveTimers()
    -- Timer countdown
    CreateThread(function()
        while TestDriveTimer > 0 and InTestDrive do
            Wait(1000)
            TestDriveTimer = TestDriveTimer - 1
            
            if TestDriveTimer <= 30 and TestDriveTimer % 10 == 0 then
                SLCore.Functions.Notify(TestDriveTimer .. ' seconds remaining!', 'warning')
            end
            
            if TestDriveTimer <= 0 then
                EndTestDrive(true)
            end
        end
    end)
    
    -- Distance check
    CreateThread(function()
        while InTestDrive do
            Wait(1000)
            if TestDriveVehicle then
                local dist = #(GetEntityCoords(TestDriveVehicle) - vector3(StartCoords.x, StartCoords.y, StartCoords.z))
                if dist > Config.TestDrive.maxDistance then
                    SLCore.Functions.Notify('You\'ve gone too far! Return to the dealership!', 'error')
                    Wait(5000)
                    if #(GetEntityCoords(TestDriveVehicle) - vector3(StartCoords.x, StartCoords.y, StartCoords.z)) > Config.TestDrive.maxDistance then
                        EndTestDrive(false)
                    end
                end
            end
        end
    end)
    
    -- Speed check
    CreateThread(function()
        while InTestDrive do
            Wait(100)
            if TestDriveVehicle then
                local speed = GetEntitySpeed(TestDriveVehicle) * 2.236936 -- Convert to MPH
                if speed > Config.TestDrive.maxSpeed then
                    SetVehicleForwardSpeed(TestDriveVehicle, Config.TestDrive.maxSpeed / 2.236936)
                    SLCore.Functions.Notify('Speed limited to ' .. Config.TestDrive.maxSpeed .. ' MPH!', 'error')
                end
            end
        end
    end)
end

-- End Test Drive
function EndTestDrive(normal)
    if not InTestDrive then return end
    InTestDrive = false
    
    -- Calculate damage
    local damage = 0
    if TestDriveVehicle then
        local engineHealth = GetVehicleEngineHealth(TestDriveVehicle)
        local bodyHealth = GetVehicleBodyHealth(TestDriveVehicle)
        
        damage = (2000 - (engineHealth + bodyHealth)) / 20 -- Convert to percentage
    end
    
    -- Delete vehicle
    if DoesEntityExist(TestDriveVehicle) then
        DeleteEntity(TestDriveVehicle)
    end
    TestDriveVehicle = nil
    
    -- Return deposit with potential penalty
    TriggerServerEvent('sl-dealership:server:EndTestDrive', {
        normal = normal,
        damage = damage
    })
end

-- Cleanup
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() and InTestDrive then
        EndTestDrive(false)
    end
end) 