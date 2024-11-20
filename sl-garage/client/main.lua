local SLCore = exports['sl-core']:GetCoreObject()
local PlayerData = {}
local Zones = {}
local CurrentGarage = nil

-- Initialize
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    PlayerData = SLCore.Functions.GetPlayerData()
    InitializeGarages()
end)

RegisterNetEvent('SLCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

-- Create Zones and Blips
local function InitializeGarages()
    -- Create zones for public garages
    for k, v in pairs(Config.Garages) do
        -- Parking zone
        Zones[k .. '_parking'] = BoxZone:Create(
            vector3(v.zones.parking.x, v.zones.parking.y, v.zones.parking.z),
            v.size.parking.x, v.size.parking.y, {
                name = k .. '_parking',
                heading = v.zones.parking.w,
                minZ = v.zones.parking.z - v.size.parking.z / 2,
                maxZ = v.zones.parking.z + v.size.parking.z / 2,
                debugPoly = false
            }
        )
        
        -- Store zone
        Zones[k .. '_store'] = BoxZone:Create(
            v.zones.store,
            v.size.store.x, v.size.store.y, {
                name = k .. '_store',
                heading = 0,
                minZ = v.zones.store.z - v.size.store.z / 2,
                maxZ = v.zones.store.z + v.size.store.z / 2,
                debugPoly = false
            }
        )
        
        -- Create blip
        local garageType = Config.GarageTypes[v.type]
        local blip = AddBlipForCoord(v.zones.parking.x, v.zones.parking.y, v.zones.parking.z)
        SetBlipSprite(blip, garageType.blipSprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, garageType.blipColor)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.label)
        EndTextCommandSetBlipName(blip)
    end
    
    -- Create zones for impound lots
    for k, v in pairs(Config.ImpoundLots) do
        -- Similar zone creation for impound lots
        -- ... (similar to above but for impound lots)
    end
end

-- Zone Functions
local function HandleZoneEntry(name)
    local zoneType = string.match(name, "(.-)_")
    local action = string.match(name, "_(%w+)")
    
    if action == "parking" then
        CurrentGarage = zoneType
        if Config.UseTarget then
            exports['sl-target']:AddBoxZone(name, Config.Garages[zoneType].zones.parking, 
                Config.Garages[zoneType].size.parking.x, Config.Garages[zoneType].size.parking.y, {
                    name = name,
                    heading = Config.Garages[zoneType].zones.parking.w,
                    debugPoly = false,
                    minZ = Config.Garages[zoneType].zones.parking.z - 1,
                    maxZ = Config.Garages[zoneType].zones.parking.z + 1,
                }, {
                    options = {
                        {
                            type = "client",
                            event = "sl-garage:client:OpenGarageMenu",
                            icon = "fas fa-parking",
                            label = "Open Garage",
                            garage = zoneType
                        },
                    },
                    distance = 2.5
                })
        else
            -- Show floating text/marker
        end
    elseif action == "store" then
        if Config.UseTarget then
            exports['sl-target']:AddBoxZone(name, Config.Garages[zoneType].zones.store, 
                Config.Garages[zoneType].size.store.x, Config.Garages[zoneType].size.store.y, {
                    name = name,
                    heading = 0,
                    debugPoly = false,
                }, {
                    options = {
                        {
                            type = "client",
                            event = "sl-garage:client:StoreVehicle",
                            icon = "fas fa-parking",
                            label = "Store Vehicle",
                            garage = zoneType
                        },
                    },
                    distance = 2.5
                })
        end
    end
end

-- Events
RegisterNetEvent('sl-garage:client:OpenGarageMenu', function(data)
    local garage = data.garage
    SLCore.Functions.TriggerCallback('sl-garage:server:GetGarageVehicles', function(vehicles)
        OpenGarageMenu(garage, vehicles)
    end, garage)
end)

RegisterNetEvent('sl-garage:client:StoreVehicle', function(data)
    local garage = data.garage
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    if vehicle ~= 0 then
        local plate = GetVehicleNumberPlateText(vehicle)
        TriggerServerEvent('sl-garage:server:StoreVehicle', garage, plate)
    end
end)

-- Initialize
CreateThread(function()
    while not SLCore.Functions.IsPlayerLoaded() do
        Wait(100)
    end
    InitializeGarages()
end) 