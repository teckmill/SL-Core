local SLCore = exports['sl-core']:GetCoreObject()

-- Tattoo shop locations
Config.TattooShops = {
    {name = "Tattoo Shop", coords = vector3(1322.6, -1651.9, 51.2)},
    {name = "Tattoo Shop", coords = vector3(-1153.6, -1425.6, 4.9)},
    {name = "Tattoo Shop", coords = vector3(322.1, 180.4, 103.5)},
    {name = "Tattoo Shop", coords = vector3(-3170.0, 1075.0, 20.8)},
    {name = "Tattoo Shop", coords = vector3(1864.6, 3747.7, 33.0)},
    {name = "Tattoo Shop", coords = vector3(-293.7, 6200.0, 31.4)}
}

-- Create blips for tattoo shops
CreateThread(function()
    for _, shop in pairs(Config.TattooShops) do
        local blip = AddBlipForCoord(shop.coords)
        SetBlipSprite(blip, 75)
        SetBlipColour(blip, 1)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(shop.name)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Tattoo application function
function ApplyTattoo(collection, overlay)
    ClearPedDecorations(PlayerPedId())
    AddPedDecorationFromHashes(PlayerPedId(), GetHashKey(collection), GetHashKey(overlay))
end
