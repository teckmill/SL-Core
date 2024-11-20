local SLCore = exports['sl-core']:GetCoreObject()
local PlayerData = {}
local CurrentApartment = nil
local CurrentBlips = {}
local InsideApartment = false

-- Core Ready Check
local CoreReady = false
AddEventHandler('SLCore:Client:OnPlayerLoaded', function()
    CoreReady = true
    PlayerData = SLCore.Functions.GetPlayerData()
    InitializeApartments()
end)

RegisterNetEvent('SLCore:Client:OnPlayerUnload', function()
    CoreReady = false
    PlayerData = {}
    RemoveApartmentBlips()
end)

-- Initialize Apartments
function InitializeApartments()
    CreateApartmentBlips()
    CreateApartmentZones()
end

-- Blip Management
function CreateApartmentBlips()
    RemoveApartmentBlips()
    for k, v in pairs(Config.Locations) do
        local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
        SetBlipSprite(blip, 475)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.65)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 3)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.name)
        EndTextCommandSetBlipName(blip)
        CurrentBlips[k] = blip
    end
end

function RemoveApartmentBlips()
    for k, v in pairs(CurrentBlips) do
        RemoveBlip(v)
    end
    CurrentBlips = {}
end

-- Zone Management
function CreateApartmentZones()
    for k, v in pairs(Config.Locations) do
        exports['sl-target']:AddBoxZone("apartment_"..k, vector3(v.coords.x, v.coords.y, v.coords.z), 2.0, 2.0, {
            name = "apartment_"..k,
            heading = v.coords.w,
            debugPoly = false,
            minZ = v.coords.z - 1,
            maxZ = v.coords.z + 1,
        }, {
            options = {
                {
                    type = "client",
                    event = "sl-apartments:client:EnterApartment",
                    icon = "fas fa-home",
                    label = "Enter Apartment",
                    apartment = k
                },
                {
                    type = "client",
                    event = "sl-apartments:client:ViewApartment",
                    icon = "fas fa-eye",
                    label = "View Apartment",
                    apartment = k
                }
            },
            distance = 2.5
        })
    end
end

-- Events
RegisterNetEvent('sl-apartments:client:EnterApartment', function(data)
    if not CoreReady then return end
    local apartment = data.apartment
    TriggerServerEvent('sl-apartments:server:EnterApartment', apartment)
end)

RegisterNetEvent('sl-apartments:client:ViewApartment', function(data)
    if not CoreReady then return end
    local apartment = data.apartment
    OpenViewMenu(apartment)
end)

RegisterNetEvent('sl-apartments:client:SetInsideApartment', function(apartmentId, interior)
    InsideApartment = true
    CurrentApartment = apartmentId
    LoadApartmentInterior(interior)
end)

-- UI Functions
function OpenViewMenu(apartment)
    local apartmentData = Config.Locations[apartment]
    if not apartmentData then return end

    local elements = {}
    for k, v in pairs(apartmentData.interiors) do
        table.insert(elements, {
            header = v.label,
            txt = "Price: $" .. v.price,
            params = {
                event = "sl-apartments:client:BuyApartment",
                args = {
                    apartment = apartment,
                    interior = k
                }
            }
        })
    end

    exports['sl-menu']:openMenu(elements)
end

-- Interior Management
function LoadApartmentInterior(interior)
    local interiorData = Config.Interiors[interior]
    if not interiorData then return end

    -- Load shell
    local coords = GetEntityCoords(PlayerPedId())
    local shell = CreateObject(GetHashKey(interiorData.shell), coords.x, coords.y, coords.z, false, false, false)
    FreezeEntityPosition(shell, true)

    -- Load furniture
    for _, furniture in pairs(interiorData.furniture) do
        local prop = CreateObject(GetHashKey(furniture.prop), 
            coords.x + furniture.pos.x,
            coords.y + furniture.pos.y,
            coords.z + furniture.pos.z,
            false, false, false)
        FreezeEntityPosition(prop, true)
    end
end

-- Export functions
exports('GetCurrentApartment', function()
    return CurrentApartment
end)

exports('IsInApartment', function()
    return InsideApartment
end)
