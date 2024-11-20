local SLCore = exports['sl-core']:GetCoreObject()
local PlayerData = {}
local onDuty = false
local currentHospital = nil
local bedOccupying = nil
local cam = nil

-- Initialize
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    PlayerData = SLCore.Functions.GetPlayerData()
    onDuty = PlayerData.job.onduty
    if PlayerData.job.name == "ambulance" then
        InitializeHospitals()
    end
end)

RegisterNetEvent('SLCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    onDuty = JobInfo.onduty
    if JobInfo.name == "ambulance" then
        InitializeHospitals()
    end
end)

-- Hospital Functions
function InitializeHospitals()
    for k, v in pairs(Config.Hospitals) do
        -- Create Blip
        local blip = AddBlipForCoord(v.blip.coords)
        SetBlipSprite(blip, v.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, v.blip.scale)
        SetBlipColour(blip, v.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.label)
        EndTextCommandSetBlipName(blip)
        
        -- Create Zones
        for type, coords in pairs(v.stations) do
            exports['sl-target']:AddBoxZone("hospital_" .. k .. "_" .. type, 
                vector3(coords.x, coords.y, coords.z), 1.5, 1.5, {
                    name = "hospital_" .. k .. "_" .. type,
                    heading = coords.w,
                    debugPoly = false,
                    minZ = coords.z - 1,
                    maxZ = coords.z + 1,
                }, {
                    options = {
                        {
                            type = "client",
                            event = "sl-ambulance:client:" .. type,
                            icon = "fas fa-" .. (type == "duty" and "clock" or type == "armory" and "box-open" or "pills"),
                            label = type:gsub("^%l", string.upper),
                            job = "ambulance"
                        },
                    },
                    distance = 2.5
                })
        end
    end
end

-- Events
RegisterNetEvent('sl-ambulance:client:duty', function()
    onDuty = not onDuty
    TriggerServerEvent("sl-ambulance:server:SetDuty", onDuty)
end)

RegisterNetEvent('sl-ambulance:client:armory', function()
    if not onDuty then return end
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "hospital", Config.Items)
end)

RegisterNetEvent('sl-ambulance:client:pharmacy', function()
    if not onDuty then return end
    -- Add pharmacy menu here
end)

-- Exports
exports('IsOnDuty', function()
    return onDuty
end) 