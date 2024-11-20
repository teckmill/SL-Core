Config = {}

Config.StartingApartment = true -- Enable/disable starting apartments
Config.DefaultSpawn = vector4(-1035.71, -2731.87, 12.86, 0.0)

Config.Interior = vector3(-814.89, 181.95, 76.85) -- Interior to load where characters are previewed
Config.DefaultNumberOfCharacters = 5 -- Define maximum amount of default characters (maximum 5 characters defined by default)
Config.PlayersNumberOfCharacters = { -- Define maximum amount of player characters by rockstar license (you can find this license in your server's database in the players table)
    ['license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'] = 2,
}

-- Default spawn locations
Config.Spawns = {
    {
        coords = vector4(-1035.71, -2731.87, 12.86, 0.0),
        location = "Airport",
        label = "Los Santos International Airport"
    },
    {
        coords = vector4(195.17, -933.77, 29.7, 144.5),
        location = "Bus Station",
        label = "Bus Station"
    },
    {
        coords = vector4(298.81, -584.94, 43.26, 77.02),
        location = "Hospital",
        label = "Pillbox Hospital"
    },
    {
        coords = vector4(-1833.96, -1223.5, 13.02, 310.63),
        location = "Beach",
        label = "Vespucci Beach"
    }
}
