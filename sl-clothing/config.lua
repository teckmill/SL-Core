Config = {}

Config.DefaultPrice = 100
Config.DefaultBarberPrice = 50

Config.Shops = {
    ['legion'] = {
        label = "Legion Square Clothing",
        coords = vector4(75.39, -1392.88, 29.37, 272.05),
        price = 100,
        type = "clothing"
    },
    ['barber_1'] = {
        label = "Hair Salon",
        coords = vector4(-814.22, -183.7, 37.57, 116.91),
        price = 50,
        type = "barber"
    },
    ['tattoo_1'] = {
        label = "Blazing Tattoo",
        coords = vector4(1322.6, -1651.9, 51.2, 42.5),
        type = "tattoo"
    }
}

Config.ClothingRooms = {
    ['police'] = {
        label = "Police Locker Room",
        coords = vector4(461.34, -999.06, 30.69, 90.65),
        job = "police"
    },
    ['ambulance'] = {
        label = "EMS Locker Room",
        coords = vector4(301.65, -599.28, 43.28, 77.88),
        job = "ambulance"
    }
}

Config.MaxOutfits = 20
Config.MaxTattoos = 50

Config.Outfits = {
    ['police'] = {
        ['male'] = {
            ['cadet'] = {
                outfitLabel = "Police Cadet",
                outfitData = {
                    ['arms'] = {item = 0, texture = 0},
                    ['t-shirt'] = {item = 58, texture = 0},
                    ['torso2'] = {item = 55, texture = 0},
                    ['vest'] = {item = 0, texture = 0},
                    ['decals'] = {item = 0, texture = 0},
                    ['accessory'] = {item = 0, texture = 0},
                    ['bag'] = {item = 0, texture = 0},
                    ['pants'] = {item = 35, texture = 0},
                    ['shoes'] = {item = 24, texture = 0},
                }
            }
        },
        ['female'] = {
            ['cadet'] = {
                outfitLabel = "Police Cadet",
                outfitData = {
                    ['arms'] = {item = 14, texture = 0},
                    ['t-shirt'] = {item = 35, texture = 0},
                    ['torso2'] = {item = 48, texture = 0},
                    ['vest'] = {item = 0, texture = 0},
                    ['decals'] = {item = 0, texture = 0},
                    ['accessory'] = {item = 0, texture = 0},
                    ['bag'] = {item = 0, texture = 0},
                    ['pants'] = {item = 34, texture = 0},
                    ['shoes'] = {item = 27, texture = 0},
                }
            }
        }
    }
} 