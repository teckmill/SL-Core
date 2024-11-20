SLCore = exports['sl-core']:GetCoreObject()

SLCore.Shared.Weapons = {
    -- Melee
    ['weapon_dagger'] = {
        ['name'] = 'weapon_dagger',
        ['label'] = 'Dagger',
        ['ammotype'] = nil,
        ['damagereason'] = 'Stabbed',
        ['weight'] = 1000,
    },
    ['weapon_bat'] = {
        ['name'] = 'weapon_bat',
        ['label'] = 'Baseball Bat',
        ['ammotype'] = nil,
        ['damagereason'] = 'Beaten up',
        ['weight'] = 1000,
    },
    ['weapon_bottle'] = {
        ['name'] = 'weapon_bottle',
        ['label'] = 'Broken Bottle',
        ['ammotype'] = nil,
        ['damagereason'] = 'Attacked',
        ['weight'] = 1000,
    },

    -- Handguns
    ['weapon_pistol'] = {
        ['name'] = 'weapon_pistol',
        ['label'] = 'Pistol',
        ['ammotype'] = 'AMMO_PISTOL',
        ['damagereason'] = 'Shot',
        ['weight'] = 1000,
    },
    ['weapon_combatpistol'] = {
        ['name'] = 'weapon_combatpistol',
        ['label'] = 'Combat Pistol',
        ['ammotype'] = 'AMMO_PISTOL',
        ['damagereason'] = 'Shot',
        ['weight'] = 1000,
    },
    ['weapon_appistol'] = {
        ['name'] = 'weapon_appistol',
        ['label'] = 'AP Pistol',
        ['ammotype'] = 'AMMO_PISTOL',
        ['damagereason'] = 'Shot',
        ['weight'] = 1000,
    },

    -- Submachine Guns
    ['weapon_microsmg'] = {
        ['name'] = 'weapon_microsmg',
        ['label'] = 'Micro SMG',
        ['ammotype'] = 'AMMO_SMG',
        ['damagereason'] = 'Riddled',
        ['weight'] = 2500,
    },
    ['weapon_smg'] = {
        ['name'] = 'weapon_smg',
        ['label'] = 'SMG',
        ['ammotype'] = 'AMMO_SMG',
        ['damagereason'] = 'Riddled',
        ['weight'] = 2500,
    },

    -- Shotguns
    ['weapon_pumpshotgun'] = {
        ['name'] = 'weapon_pumpshotgun',
        ['label'] = 'Pump Shotgun',
        ['ammotype'] = 'AMMO_SHOTGUN',
        ['damagereason'] = 'Blasted',
        ['weight'] = 3000,
    },
    ['weapon_sawnoffshotgun'] = {
        ['name'] = 'weapon_sawnoffshotgun',
        ['label'] = 'Sawn-off Shotgun',
        ['ammotype'] = 'AMMO_SHOTGUN',
        ['damagereason'] = 'Blasted',
        ['weight'] = 2500,
    },

    -- Assault Rifles
    ['weapon_assaultrifle'] = {
        ['name'] = 'weapon_assaultrifle',
        ['label'] = 'Assault Rifle',
        ['ammotype'] = 'AMMO_RIFLE',
        ['damagereason'] = 'Shot',
        ['weight'] = 4000,
    },
    ['weapon_carbinerifle'] = {
        ['name'] = 'weapon_carbinerifle',
        ['label'] = 'Carbine Rifle',
        ['ammotype'] = 'AMMO_RIFLE',
        ['damagereason'] = 'Shot',
        ['weight'] = 4000,
    },

    -- Light Machine Guns
    ['weapon_mg'] = {
        ['name'] = 'weapon_mg',
        ['label'] = 'Machine Gun',
        ['ammotype'] = 'AMMO_MG',
        ['damagereason'] = 'Shot',
        ['weight'] = 8000,
    },

    -- Sniper Rifles
    ['weapon_sniperrifle'] = {
        ['name'] = 'weapon_sniperrifle',
        ['label'] = 'Sniper Rifle',
        ['ammotype'] = 'AMMO_SNIPER',
        ['damagereason'] = 'Sniped',
        ['weight'] = 6000,
    },

    -- Heavy Weapons
    ['weapon_rpg'] = {
        ['name'] = 'weapon_rpg',
        ['label'] = 'RPG',
        ['ammotype'] = 'AMMO_RPG',
        ['damagereason'] = 'Exploded',
        ['weight'] = 10000,
    },

    -- Throwables
    ['weapon_grenade'] = {
        ['name'] = 'weapon_grenade',
        ['label'] = 'Grenade',
        ['ammotype'] = nil,
        ['damagereason'] = 'Bombed',
        ['weight'] = 1000,
    },
    ['weapon_smokegrenade'] = {
        ['name'] = 'weapon_smokegrenade',
        ['label'] = 'Smoke Grenade',
        ['ammotype'] = nil,
        ['damagereason'] = 'Smoked',
        ['weight'] = 1000,
    },
}
