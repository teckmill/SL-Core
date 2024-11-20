local SLCore = exports['sl-core']:GetCoreObject()
local PlayerData = {}
local CurrentShop = nil
local CurrentZone = nil
local testDriveVeh = 0
local inTestDrive = false
local testDriveCoords = nil
local testDriveBlip = nil

-- Initialize
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    PlayerData = SLCore.Functions.GetPlayerData()
    CreateDealerBlips()
end)

RegisterNetEvent('SLCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

-- Core Functions
function CreateDealerBlips()
    for k, v in pairs(Config.Shops) do
        local blip = AddBlipForCoord(v.location.x, v.location.y, v.location.z)
        SetBlipSprite(blip, 326)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.75)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 3)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.label)
        EndTextCommandSetBlipName(blip)
    end
end

function SetupDealerZones()
    for k, v in pairs(Config.Shops) do
        exports['sl-target']:AddBoxZone("vehicleshop_"..k, vector3(v.location.x, v.location.y, v.location.z), 3.0, 3.0, {
            name = "vehicleshop_"..k,
            heading = v.location.w,
            debugPoly = Config.Debug,
            minZ = v.location.z - 1,
            maxZ = v.location.z + 2,
        }, {
            options = {
                {
                    type = "client",
                    event = "sl-vehicleshop:client:OpenShop",
                    icon = "fas fa-car",
                    label = Lang:t('info.vehicle_shop'),
                    shop = k,
                    canInteract = function()
                        return CanAccessShop(k)
                    end
                }
            },
            distance = 3.0
        })
    end
end

function CanAccessShop(shop)
    local shopConfig = Config.Shops[shop]
    if not shopConfig then return false end
    
    if shopConfig.job and (not PlayerData.job or PlayerData.job.name ~= shopConfig.job) then
        return false
    end
    
    return true
end

function StartTestDrive(shop, model)
    if inTestDrive then
        SLCore.Functions.Notify(Lang:t('error.testdrive_in_progress'), 'error')
        return
    end

    local shopConfig = Config.Shops[shop]
    if not shopConfig.testDrive.enabled then
        SLCore.Functions.Notify(Lang:t('error.no_testdrive'), 'error')
        return
    end

    -- Charge for test drive
    TriggerServerEvent('sl-vehicleshop:server:payTestDrive', shop)

    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    testDriveCoords = pos

    SLCore.Functions.SpawnVehicle(model, function(vehicle)
        SetEntityHeading(vehicle, shopConfig.location.w)
        TaskWarpPedIntoVehicle(ped, vehicle, -1)
        TriggerEvent('vehiclekeys:client:SetOwner', GetVehicleNumberPlateText(vehicle))
        SetVehicleEngineOn(vehicle, true, true)
        testDriveVeh = vehicle
        inTestDrive = true

        -- Create radius blip
        testDriveBlip = AddBlipForRadius(testDriveCoords.x, testDriveCoords.y, testDriveCoords.z, shopConfig.testDrive.radius)
        SetBlipColour(testDriveBlip, 1)
        SetBlipAlpha(testDriveBlip, 128)

        -- Start test drive timer
        local timeRemaining = shopConfig.testDrive.duration
        CreateThread(function()
            while timeRemaining > 0 and inTestDrive do
                Wait(1000)
                timeRemaining = timeRemaining - 1
                
                -- Check if player is too far from dealership
                local dist = #(GetEntityCoords(ped) - testDriveCoords)
                if dist > shopConfig.testDrive.radius then
                    EndTestDrive()
                    SLCore.Functions.Notify(Lang:t('error.outside_testdrive'), 'error')
                    break
                end

                if timeRemaining <= 0 then
                    EndTestDrive()
                    SLCore.Functions.Notify(Lang:t('error.testdrive_exceeded'), 'error')
                end
            end
        end)
    end, pos, true)
end

function EndTestDrive()
    local ped = PlayerPedId()
    TaskLeaveVehicle(ped, testDriveVeh, 0)
    Wait(2000)
    SLCore.Functions.DeleteVehicle(testDriveVeh)
    RemoveBlip(testDriveBlip)
    testDriveVeh = 0
    testDriveBlip = nil
    inTestDrive = false
    testDriveCoords = nil
end

-- Events
RegisterNetEvent('sl-vehicleshop:client:OpenShop', function(data)
    if not data.shop then return end
    CurrentShop = data.shop
    TriggerEvent('sl-vehicleshop:client:OpenVehicleShop', data.shop)
end)

RegisterNetEvent('sl-vehicleshop:client:TestDrive', function(data)
    if not data.shop or not data.vehicle then return end
    StartTestDrive(data.shop, data.vehicle)
end)

RegisterNetEvent('sl-vehicleshop:client:FinanceVehicle', function(data)
    if not data.shop or not data.vehicle then return end
    TriggerServerEvent('sl-vehicleshop:server:financeVehicle', data.shop, data.vehicle, data.downPayment, data.paymentCount)
end)

RegisterNetEvent('sl-vehicleshop:client:PurchaseVehicle', function(data)
    if not data.shop or not data.vehicle then return end
    TriggerServerEvent('sl-vehicleshop:server:purchaseVehicle', data.shop, data.vehicle, data.paymentType)
end)

-- Initialize
CreateThread(function()
    Wait(1000)
    SetupDealerZones()
end)

-- Cleanup
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if testDriveVeh ~= 0 then
        SLCore.Functions.DeleteVehicle(testDriveVeh)
    end
end)
