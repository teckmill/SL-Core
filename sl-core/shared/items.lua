SLCore = SLCore or {}
SLCore.Shared = SLCore.Shared or {}
SLCore.Shared.Items = {
    -- WEAPONS
    -- Melee
    ['weapon_unarmed'] = {
        ['name'] = 'weapon_unarmed',
        ['label'] = 'Fists',
        ['weight'] = 1000,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'placeholder.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'Fisticuffs'
    },
    ['weapon_dagger'] = {
        ['name'] = 'weapon_dagger',
        ['label'] = 'Dagger',
        ['weight'] = 1000,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_dagger.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'A short knife with a pointed and edged blade'
    },
    ['weapon_bat'] = {
        ['name'] = 'weapon_bat',
        ['label'] = 'Bat',
        ['weight'] = 1000,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_bat.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'Used for hitting a ball in sports (or other things)'
    },

    -- Handguns
    ['weapon_pistol'] = {
        ['name'] = 'weapon_pistol',
        ['label'] = 'Walther P99',
        ['weight'] = 1000,
        ['type'] = 'weapon',
        ['ammotype'] = 'AMMO_PISTOL',
        ['image'] = 'weapon_pistol.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'A small firearm designed to be held in one hand'
    },
    ['weapon_pistol_mk2'] = {
        ['name'] = 'weapon_pistol_mk2',
        ['label'] = 'Pistol Mk II',
        ['weight'] = 1000,
        ['type'] = 'weapon',
        ['ammotype'] = 'AMMO_PISTOL',
        ['image'] = 'weapon_pistol_mk2.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'An upgraded small firearm designed to be held in one hand'
    },

    -- SMG
    ['weapon_smg'] = {
        ['name'] = 'weapon_smg',
        ['label'] = 'SMG',
        ['weight'] = 3000,
        ['type'] = 'weapon',
        ['ammotype'] = 'AMMO_SMG',
        ['image'] = 'weapon_smg.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'Submachine gun'
    },
    ['weapon_carbinerifle'] = {
        ['name'] = 'weapon_carbinerifle',
        ['label'] = 'Carbine Rifle',
        ['weight'] = 4000,
        ['type'] = 'weapon',
        ['ammotype'] = 'AMMO_RIFLE',
        ['image'] = 'weapon_carbinerifle.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'Automatic rifle'
    },
    ['weapon_stungun'] = {
        ['name'] = 'weapon_stungun',
        ['label'] = 'Taser',
        ['weight'] = 1500,
        ['type'] = 'weapon',
        ['ammotype'] = nil,
        ['image'] = 'weapon_stungun.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'Police issue taser'
    },

    -- AMMUNITION
    ['pistol_ammo'] = {
        ['name'] = 'pistol_ammo',
        ['label'] = 'Pistol Ammo',
        ['weight'] = 200,
        ['type'] = 'item',
        ['image'] = 'pistol_ammo.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Ammunition for pistols'
    },
    ['rifle_ammo'] = {
        ['name'] = 'rifle_ammo',
        ['label'] = 'Rifle Ammo',
        ['weight'] = 1000,
        ['type'] = 'item',
        ['image'] = 'rifle_ammo.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Ammunition for rifles'
    },
    ['smg_ammo'] = {
        ['name'] = 'smg_ammo',
        ['label'] = 'SMG Ammo',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'smg_ammo.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Ammunition for submachine guns'
    },
    ['shotgun_ammo'] = {
        ['name'] = 'shotgun_ammo',
        ['label'] = 'Shotgun Shells',
        ['weight'] = 700,
        ['type'] = 'item',
        ['image'] = 'shotgun_ammo.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Ammunition for shotguns'
    },

    -- CONSUMABLES
    -- Food
    ['sandwich'] = {
        ['name'] = 'sandwich',
        ['label'] = 'Sandwich',
        ['weight'] = 200,
        ['type'] = 'item',
        ['image'] = 'sandwich.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Nice bread with something between'
    },
    ['tosti'] = {
        ['name'] = 'tosti',
        ['label'] = 'Grilled Cheese',
        ['weight'] = 200,
        ['type'] = 'item',
        ['image'] = 'tosti.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Delicious grilled cheese sandwich'
    },
    ['burger'] = {
        ['name'] = 'burger',
        ['label'] = 'Burger',
        ['weight'] = 300,
        ['type'] = 'item',
        ['image'] = 'burger.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Tasty hamburger'
    },
    ['pizza'] = {
        ['name'] = 'pizza',
        ['label'] = 'Pizza Slice',
        ['weight'] = 300,
        ['type'] = 'item',
        ['image'] = 'pizza.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'A slice of pizza'
    },
    ['donut'] = {
        ['name'] = 'donut',
        ['label'] = 'Donut',
        ['weight'] = 200,
        ['type'] = 'item',
        ['image'] = 'donut.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Sweet donut with sprinkles'
    },

    -- Drinks
    ['water_bottle'] = {
        ['name'] = 'water_bottle',
        ['label'] = 'Water Bottle',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'water_bottle.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'For all the thirsty out there'
    },
    ['kurkakola'] = {
        ['name'] = 'kurkakola',
        ['label'] = 'Cola',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'cola.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'For all the thirsty out there'
    },
    ['coffee'] = {
        ['name'] = 'coffee',
        ['label'] = 'Coffee',
        ['weight'] = 300,
        ['type'] = 'item',
        ['image'] = 'coffee.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Hot cup of coffee'
    },
    ['energy_drink'] = {
        ['name'] = 'energy_drink',
        ['label'] = 'Energy Drink',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'energy_drink.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Gives you wings!'
    },

    -- Alcohol
    ['beer'] = {
        ['name'] = 'beer',
        ['label'] = 'Beer',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'beer.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Nothing like a good cold beer!'
    },
    ['whiskey'] = {
        ['name'] = 'whiskey',
        ['label'] = 'Whiskey',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'whiskey.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'For all the thirsty out there'
    },
    ['vodka'] = {
        ['name'] = 'vodka',
        ['label'] = 'Vodka',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'vodka.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Strong Russian spirit'
    },
    ['tequila'] = {
        ['name'] = 'tequila',
        ['label'] = 'Tequila',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'tequila.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Mexican spirit with a kick'
    },

    -- TOOLS
    ['lockpick'] = {
        ['name'] = 'lockpick',
        ['label'] = 'Lockpick',
        ['weight'] = 300,
        ['type'] = 'item',
        ['image'] = 'lockpick.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Very useful if you lose your keys'
    },
    ['advancedlockpick'] = {
        ['name'] = 'advancedlockpick',
        ['label'] = 'Advanced Lockpick',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'advancedlockpick.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'If you lose your keys a lot this is very useful'
    },
    ['repairkit'] = {
        ['name'] = 'repairkit',
        ['label'] = 'Repair Kit',
        ['weight'] = 2500,
        ['type'] = 'item',
        ['image'] = 'repairkit.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'For vehicle repairs'
    },
    ['screwdriverset'] = {
        ['name'] = 'screwdriverset',
        ['label'] = 'Screwdriver Set',
        ['weight'] = 1000,
        ['type'] = 'item',
        ['image'] = 'screwdriverset.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Very useful for screws'
    },
    ['drill'] = {
        ['name'] = 'drill',
        ['label'] = 'Drill',
        ['weight'] = 2000,
        ['type'] = 'item',
        ['image'] = 'drill.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'For making holes'
    },

    -- ELECTRONICS
    ['phone'] = {
        ['name'] = 'phone',
        ['label'] = 'Phone',
        ['weight'] = 700,
        ['type'] = 'item',
        ['image'] = 'phone.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = false,
        ['description'] = 'Expensive phone'
    },
    ['radio'] = {
        ['name'] = 'radio',
        ['label'] = 'Radio',
        ['weight'] = 2000,
        ['type'] = 'item',
        ['image'] = 'radio.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'For communication'
    },
    ['laptop'] = {
        ['name'] = 'laptop',
        ['label'] = 'Laptop',
        ['weight'] = 4000,
        ['type'] = 'item',
        ['image'] = 'laptop.png',
        ['unique'] = false,
        ['useable'] = false,
        ['shouldClose'] = true,
        ['description'] = 'Expensive laptop'
    },
    ['tablet'] = {
        ['name'] = 'tablet',
        ['label'] = 'Tablet',
        ['weight'] = 2000,
        ['type'] = 'item',
        ['image'] = 'tablet.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = false,
        ['description'] = 'Digital tablet device'
    },
    ['usb_drive'] = {
        ['name'] = 'usb_drive',
        ['label'] = 'USB Drive',
        ['weight'] = 100,
        ['type'] = 'item',
        ['image'] = 'usb_drive.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Store digital data'
    },

    -- VEHICLE PARTS
    ['veh_brakes'] = {
        ['name'] = 'veh_brakes',
        ['label'] = 'Brakes',
        ['weight'] = 1000,
        ['type'] = 'item',
        ['image'] = 'veh_brakes.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Upgrade vehicle brakes'
    },
    ['veh_engine'] = {
        ['name'] = 'veh_engine',
        ['label'] = 'Engine',
        ['weight'] = 1000,
        ['type'] = 'item',
        ['image'] = 'veh_engine.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Upgrade vehicle engine'
    },
    ['veh_turbo'] = {
        ['name'] = 'veh_turbo',
        ['label'] = 'Turbo',
        ['weight'] = 1000,
        ['type'] = 'item',
        ['image'] = 'veh_turbo.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Install vehicle turbo'
    },
    ['veh_nitrous'] = {
        ['name'] = 'veh_nitrous',
        ['label'] = 'Nitrous Oxide',
        ['weight'] = 1000,
        ['type'] = 'item',
        ['image'] = 'veh_nitrous.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Speed boost for vehicles'
    },
    ['veh_transmission'] = {
        ['name'] = 'veh_transmission',
        ['label'] = 'Transmission',
        ['weight'] = 1500,
        ['type'] = 'item',
        ['image'] = 'veh_transmission.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Vehicle transmission upgrade'
    },
    ['veh_armor'] = {
        ['name'] = 'veh_armor',
        ['label'] = 'Vehicle Armor',
        ['weight'] = 2000,
        ['type'] = 'item',
        ['image'] = 'veh_armor.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Protective armor for vehicles'
    },

    -- ILLEGAL ITEMS
    ['lockpick_illegal'] = {
        ['name'] = 'lockpick_illegal',
        ['label'] = 'Professional Lockpick',
        ['weight'] = 300,
        ['type'] = 'item',
        ['image'] = 'lockpick_illegal.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Professional tool for locks'
    },
    ['thermite'] = {
        ['name'] = 'thermite',
        ['label'] = 'Thermite',
        ['weight'] = 1000,
        ['type'] = 'item',
        ['image'] = 'thermite.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Very hot burning compound'
    },
    ['hackerdevice'] = {
        ['name'] = 'hackerdevice',
        ['label'] = 'Hacking Device',
        ['weight'] = 1000,
        ['type'] = 'item',
        ['image'] = 'hackerdevice.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Advanced electronic device'
    },

    -- MEDICAL
    ['bandage'] = {
        ['name'] = 'bandage',
        ['label'] = 'Bandage',
        ['weight'] = 100,
        ['type'] = 'item',
        ['image'] = 'bandage.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Heal small wounds'
    },
    ['firstaid'] = {
        ['name'] = 'firstaid',
        ['label'] = 'First Aid Kit',
        ['weight'] = 1000,
        ['type'] = 'item',
        ['image'] = 'firstaid.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'First aid for injuries'
    },
    ['painkillers'] = {
        ['name'] = 'painkillers',
        ['label'] = 'Painkillers',
        ['weight'] = 200,
        ['type'] = 'item',
        ['image'] = 'painkillers.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Relief from pain'
    },

    -- DRUGS & CONTRABAND
    ['weed_bag'] = {
        ['name'] = 'weed_bag',
        ['label'] = 'Bag of Weed',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'weed_bag.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'A bag of processed cannabis'
    },
    ['cocaine_bag'] = {
        ['name'] = 'cocaine_bag',
        ['label'] = 'Bag of Cocaine',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'cocaine_bag.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Processed cocaine'
    },
    ['meth_bag'] = {
        ['name'] = 'meth_bag',
        ['label'] = 'Bag of Meth',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'meth_bag.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Crystal methamphetamine'
    },

    -- CRAFTING MATERIALS
    ['metal_scrap'] = {
        ['name'] = 'metal_scrap',
        ['label'] = 'Metal Scrap',
        ['weight'] = 1000,
        ['type'] = 'item',
        ['image'] = 'metal_scrap.png',
        ['unique'] = false,
        ['useable'] = false,
        ['shouldClose'] = true,
        ['description'] = 'Scrap metal for crafting'
    },
    ['plastic'] = {
        ['name'] = 'plastic',
        ['label'] = 'Plastic',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'plastic.png',
        ['unique'] = false,
        ['useable'] = false,
        ['shouldClose'] = true,
        ['description'] = 'Raw plastic material'
    },
    ['rubber'] = {
        ['name'] = 'rubber',
        ['label'] = 'Rubber',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'rubber.png',
        ['unique'] = false,
        ['useable'] = false,
        ['shouldClose'] = true,
        ['description'] = 'Raw rubber material'
    },
    ['glass'] = {
        ['name'] = 'glass',
        ['label'] = 'Glass',
        ['weight'] = 500,
        ['type'] = 'item',
        ['image'] = 'glass.png',
        ['unique'] = false,
        ['useable'] = false,
        ['shouldClose'] = true,
        ['description'] = 'Glass material'
    },
    ['electronics'] = {
        ['name'] = 'electronics',
        ['label'] = 'Electronics',
        ['weight'] = 750,
        ['type'] = 'item',
        ['image'] = 'electronics.png',
        ['unique'] = false,
        ['useable'] = false,
        ['shouldClose'] = true,
        ['description'] = 'Electronic components'
    },

    -- FISHING EQUIPMENT
    ['fishing_rod'] = {
        ['name'] = 'fishing_rod',
        ['label'] = 'Fishing Rod',
        ['weight'] = 1500,
        ['type'] = 'item',
        ['image'] = 'fishing_rod.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = false,
        ['description'] = 'For catching fish'
    },
    ['fishing_bait'] = {
        ['name'] = 'fishing_bait',
        ['label'] = 'Fishing Bait',
        ['weight'] = 100,
        ['type'] = 'item',
        ['image'] = 'fishing_bait.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Bait for fishing'
    },
    ['fish_small'] = {
        ['name'] = 'fish_small',
        ['label'] = 'Small Fish',
        ['weight'] = 1000,
        ['type'] = 'item',
        ['image'] = 'fish_small.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'A small fish'
    },
    ['fish_medium'] = {
        ['name'] = 'fish_medium',
        ['label'] = 'Medium Fish',
        ['weight'] = 2000,
        ['type'] = 'item',
        ['image'] = 'fish_medium.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'A medium-sized fish'
    },
    ['fish_large'] = {
        ['name'] = 'fish_large',
        ['label'] = 'Large Fish',
        ['weight'] = 4000,
        ['type'] = 'item',
        ['image'] = 'fish_large.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'A large fish'
    },

    -- MINING EQUIPMENT
    ['pickaxe'] = {
        ['name'] = 'pickaxe',
        ['label'] = 'Pickaxe',
        ['weight'] = 2500,
        ['type'] = 'item',
        ['image'] = 'pickaxe.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = false,
        ['description'] = 'For mining minerals'
    },
    ['stone'] = {
        ['name'] = 'stone',
        ['label'] = 'Stone',
        ['weight'] = 2000,
        ['type'] = 'item',
        ['image'] = 'stone.png',
        ['unique'] = false,
        ['useable'] = false,
        ['shouldClose'] = true,
        ['description'] = 'Raw stone material'
    },
    ['iron_ore'] = {
        ['name'] = 'iron_ore',
        ['label'] = 'Iron Ore',
        ['weight'] = 2000,
        ['type'] = 'item',
        ['image'] = 'iron_ore.png',
        ['unique'] = false,
        ['useable'] = false,
        ['shouldClose'] = true,
        ['description'] = 'Raw iron ore'
    },
    ['gold_ore'] = {
        ['name'] = 'gold_ore',
        ['label'] = 'Gold Ore',
        ['weight'] = 2000,
        ['type'] = 'item',
        ['image'] = 'gold_ore.png',
        ['unique'] = false,
        ['useable'] = false,
        ['shouldClose'] = true,
        ['description'] = 'Raw gold ore'
    },
    ['diamond'] = {
        ['name'] = 'diamond',
        ['label'] = 'Diamond',
        ['weight'] = 1000,
        ['type'] = 'item',
        ['image'] = 'diamond.png',
        ['unique'] = false,
        ['useable'] = false,
        ['shouldClose'] = true,
        ['description'] = 'A precious diamond'
    },

    -- CLOTHING & ACCESSORIES
    ['mask'] = {
        ['name'] = 'mask',
        ['label'] = 'Face Mask',
        ['weight'] = 100,
        ['type'] = 'item',
        ['image'] = 'mask.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Covers your face'
    },
    ['backpack'] = {
        ['name'] = 'backpack',
        ['label'] = 'Backpack',
        ['weight'] = 1000,
        ['type'] = 'item',
        ['image'] = 'backpack.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Increases inventory space'
    },
    ['watch'] = {
        ['name'] = 'watch',
        ['label'] = 'Watch',
        ['weight'] = 200,
        ['type'] = 'item',
        ['image'] = 'watch.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Tells the time'
    },

    -- DOCUMENTS
    ['id_card'] = {
        ['name'] = 'id_card',
        ['label'] = 'ID Card',
        ['weight'] = 0,
        ['type'] = 'item',
        ['image'] = 'id_card.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Personal identification'
    },
    ['driver_license'] = {
        ['name'] = 'driver_license',
        ['label'] = 'Driver License',
        ['weight'] = 0,
        ['type'] = 'item',
        ['image'] = 'driver_license.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Driving permit'
    },
    ['weapon_license'] = {
        ['name'] = 'weapon_license',
        ['label'] = 'Weapon License',
        ['weight'] = 0,
        ['type'] = 'item',
        ['image'] = 'weapon_license.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Permit to carry weapons'
    }
}
