Config = {}

-- General Settings
Config.Debug = false -- Enable debug mode
Config.DefaultSpawn = vector4(195.17, -933.77, 29.7, 144.5) -- Default spawn location
Config.SpawnInLastPosition = true -- Spawn at last position if available

-- Camera Settings
Config.StartingCam = vector4(-1355.93, -1487.78, 520.75, 350.84) -- Camera position when selecting spawn
Config.CameraTransitionSpeed = 1.0 -- Speed of camera transitions
Config.CameraZoomSpeed = 0.5 -- Speed of camera zoom
Config.CameraHeight = 45.0 -- Height of spawn selection camera

-- Spawn Points
Config.Spawns = {
    ['legion'] = {
        coords = vector4(195.17, -933.77, 29.7, 144.5),
        label = "Legion Square",
        description = "The heart of Los Santos",
        icon = "fas fa-city",
        image = "legion.jpg"
    },
    ['airport'] = {
        coords = vector4(-1037.74, -2738.04, 20.17, 334.94),
        label = "Los Santos International",
        description = "Start your journey at the airport",
        icon = "fas fa-plane",
        image = "airport.jpg"
    },
    ['pier'] = {
        coords = vector4(-1850.49, -1231.02, 13.02, 315.15),
        label = "Del Perro Pier",
        description = "Enjoy the beach and entertainment",
        icon = "fas fa-umbrella-beach",
        image = "pier.jpg"
    },
    ['vinewood'] = {
        coords = vector4(300.69, 200.73, 104.37, 158.93),
        label = "Vinewood",
        description = "Live the high life",
        icon = "fas fa-film",
        image = "vinewood.jpg"
    },
    ['paleto'] = {
        coords = vector4(-125.88, 6432.53, 31.36, 315.0),
        label = "Paleto Bay",
        description = "A quiet coastal town",
        icon = "fas fa-fish",
        image = "paleto.jpg"
    },
    ['sandy'] = {
        coords = vector4(1851.14, 3685.0, 34.27, 212.26),
        label = "Sandy Shores",
        description = "Experience the desert life",
        icon = "fas fa-mountain",
        image = "sandy.jpg"
    }
}

-- Apartment Spawns (if player owns an apartment)
Config.ApartmentSpawns = {
    ['alta'] = {
        coords = vector4(-271.68, -957.62, 31.22, 112.61),
        label = "Alta Street Apartment",
        description = "Your home in the city",
        icon = "fas fa-home",
        image = "alta.jpg"
    },
    ['integrity'] = {
        coords = vector4(-47.07, -585.94, 37.95, 67.79),
        label = "Integrity Way",
        description = "Luxury living in the heart of LS",
        icon = "fas fa-building",
        image = "integrity.jpg"
    }
}

-- Hotel Spawns (default options for new players)
Config.HotelSpawns = {
    ['pink_cage'] = {
        coords = vector4(326.96, -208.96, 54.09, 166.03),
        label = "Pink Cage Motel",
        description = "Affordable accommodation",
        icon = "fas fa-bed",
        image = "pink_cage.jpg"
    },
    ['motormotel'] = {
        coords = vector4(1142.26, 2664.11, 38.16, 177.57),
        label = "Sandy Shores Motel",
        description = "Budget stay in the desert",
        icon = "fas fa-bed",
        image = "motor_motel.jpg"
    }
}

-- UI Settings
Config.UISettings = {
    blur = true, -- Enable background blur
    darkMode = false, -- Enable dark mode
    showLocationImages = true, -- Show images for spawn locations
    showWeather = true, -- Show current weather at spawn locations
    showTime = true -- Show current time
}

-- Spawn Selection Settings
Config.SelectionSettings = {
    defaultTab = 'last', -- Default selected tab: 'last', 'spawns', 'apartments', 'hotels'
    showLastLocation = true, -- Show last location option
    showApartments = true, -- Show owned apartments
    showHotels = true, -- Show hotel options
    maxSpawnsVisible = 6 -- Maximum number of spawns visible at once
}
