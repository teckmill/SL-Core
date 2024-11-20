local SLCore = exports['sl-core']:GetCoreObject()

-- Clothing shop locations
Config = {}
Config.Shops = {
    {name = "Clothing Store", coords = vector3(72.3, -1399.1, 28.4)},
    {name = "Clothing Store", coords = vector3(-703.8, -152.3, 36.4)},
    {name = "Clothing Store", coords = vector3(-167.9, -299.0, 38.7)},
    {name = "Clothing Store", coords = vector3(428.7, -800.1, 28.5)},
    {name = "Clothing Store", coords = vector3(-829.4, -1073.7, 10.3)},
    {name = "Clothing Store", coords = vector3(-1447.8, -242.5, 48.8)},
    {name = "Clothing Store", coords = vector3(11.6, 6514.2, 30.9)},
    {name = "Clothing Store", coords = vector3(123.6, -219.4, 53.6)},
    {name = "Clothing Store", coords = vector3(1696.3, 4829.3, 41.1)},
    {name = "Clothing Store", coords = vector3(618.1, 2759.6, 41.1)},
    {name = "Clothing Store", coords = vector3(1190.6, 2713.4, 37.2)},
    {name = "Clothing Store", coords = vector3(-1193.4, -772.3, 16.3)},
    {name = "Clothing Store", coords = vector3(-3172.5, 1048.1, 19.9)},
    {name = "Clothing Store", coords = vector3(-1108.4, 2708.9, 18.1)}
}

-- Create blips for clothing shops
CreateThread(function()
    for _, shop in pairs(Config.Shops) do
        local blip = AddBlipForCoord(shop.coords)
        SetBlipSprite(blip, 73)
        SetBlipColour(blip, 47)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(shop.name)
        EndTextCommandSetBlipName(blip)
    end
end)
