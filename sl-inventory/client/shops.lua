local SLCore = exports['sl-core']:GetCoreObject()

-- Shop Locations
Config.Shops = {
    [1] = {
        name = "24/7 Supermarket",
        coords = vector3(25.7, -1347.3, 29.49),
        type = "shop"
    },
    [2] = {
        name = "Rob's Liquor",
        coords = vector3(1135.8, -982.2, 46.4),
        type = "shop"
    },
    [3] = {
        name = "LTD Gasoline",
        coords = vector3(-48.5, -1757.5, 29.4),
        type = "shop"
    },
    -- Add more shops as needed
}

-- Create shop blips
CreateThread(function()
    for k, v in pairs(Config.Shops) do
        local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
        SetBlipSprite(blip, 52)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.6)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 2)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.name)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Shop interaction thread
CreateThread(function()
    while true do
        local sleep = 1000
        local pos = GetEntityCoords(PlayerPedId())
        local inRange = false
        
        for k, v in pairs(Config.Shops) do
            local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
            if dist < 10 then
                inRange = true
                if dist < 2 then
                    sleep = 0
                    DrawText3Ds(v.coords.x, v.coords.y, v.coords.z, "[E] " .. v.name)
                    if IsControlJustPressed(0, 38) then -- E key
                        OpenInventory("shop", {shop = k, type = v.type})
                    end
                end
            end
        end
        
        if not inRange then
            sleep = 2000
        end
        Wait(sleep)
    end
end)
