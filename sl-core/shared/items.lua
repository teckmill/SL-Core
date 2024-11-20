SLShared = SLShared or {}
SLShared.Items = {
    -- WEAPONS
    ['weapon_pistol'] = {
        ['name'] = 'weapon_pistol',
        ['label'] = 'Pistol',
        ['weight'] = 1000,
        ['type'] = 'weapon',
        ['ammotype'] = 'AMMO_PISTOL',
        ['image'] = 'weapon_pistol.png',
        ['unique'] = true,
        ['useable'] = false,
        ['description'] = 'A basic pistol'
    },

    -- AMMO
    ['pistol_ammo'] = {
        ['name'] = 'pistol_ammo',
        ['label'] = 'Pistol Ammo',
        ['weight'] = 10,
        ['type'] = 'ammo',
        ['image'] = 'pistol_ammo.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Ammunition for pistols'
    },

    -- CONSUMABLES
    ['water_bottle'] = {
        ['name'] = 'water_bottle',
        ['label'] = 'Water Bottle',
        ['weight'] = 500,
        ['type'] = 'consumable',
        ['image'] = 'water_bottle.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Stay hydrated!',
        ['thirst'] = 30,
    },
    ['sandwich'] = {
        ['name'] = 'sandwich',
        ['label'] = 'Sandwich',
        ['weight'] = 200,
        ['type'] = 'consumable',
        ['image'] = 'sandwich.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Nice and tasty sandwich',
        ['hunger'] = 40,
    },

    -- TOOLS
    ['lockpick'] = {
        ['name'] = 'lockpick',
        ['label'] = 'Lockpick',
        ['weight'] = 300,
        ['type'] = 'tool',
        ['image'] = 'lockpick.png',
        ['unique'] = false,
        ['useable'] = true,
        ['shouldClose'] = true,
        ['description'] = 'Very useful if you lose your keys'
    },
    ['phone'] = {
        ['name'] = 'phone',
        ['label'] = 'Phone',
        ['weight'] = 700,
        ['type'] = 'tool',
        ['image'] = 'phone.png',
        ['unique'] = true,
        ['useable'] = true,
        ['shouldClose'] = false,
        ['description'] = 'Useful for calling and messaging'
    },

    -- MATERIALS
    ['metalscrap'] = {
        ['name'] = 'metalscrap',
        ['label'] = 'Metal Scrap',
        ['weight'] = 100,
        ['type'] = 'material',
        ['image'] = 'metalscrap.png',
        ['unique'] = false,
        ['useable'] = false,
        ['description'] = 'Raw material that can be used for crafting'
    },
}
