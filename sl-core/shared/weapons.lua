local SLCore = exports['sl-core']:GetCoreObject()

SLCore.Weapons = {
    -- Melee
    ['weapon_dagger'] = {['name'] = 'weapon_dagger', ['label'] = 'Dagger', ['ammotype'] = nil, ['damagereason'] = 'Stabbed', ['weight'] = 1000},
    ['weapon_bat'] = {['name'] = 'weapon_bat', ['label'] = 'Bat', ['ammotype'] = nil, ['damagereason'] = 'Beaten up', ['weight'] = 1000},
    ['weapon_bottle'] = {['name'] = 'weapon_bottle', ['label'] = 'Broken Bottle', ['ammotype'] = nil, ['damagereason'] = 'Attacked', ['weight'] = 1000},
    ['weapon_crowbar'] = {['name'] = 'weapon_crowbar', ['label'] = 'Crowbar', ['ammotype'] = nil, ['damagereason'] = 'Beaten up', ['weight'] = 1000},
    ['weapon_flashlight'] = {['name'] = 'weapon_flashlight', ['label'] = 'Flashlight', ['ammotype'] = nil, ['damagereason'] = 'Beaten up', ['weight'] = 1000},
    ['weapon_golfclub'] = {['name'] = 'weapon_golfclub', ['label'] = 'Golf Club', ['ammotype'] = nil, ['damagereason'] = 'Beaten up', ['weight'] = 1000},
    ['weapon_hammer'] = {['name'] = 'weapon_hammer', ['label'] = 'Hammer', ['ammotype'] = nil, ['damagereason'] = 'Beaten up', ['weight'] = 1000},
    ['weapon_hatchet'] = {['name'] = 'weapon_hatchet', ['label'] = 'Hatchet', ['ammotype'] = nil, ['damagereason'] = 'Beaten up', ['weight'] = 1000},
    ['weapon_knuckle'] = {['name'] = 'weapon_knuckle', ['label'] = 'Knuckle Dusters', ['ammotype'] = nil, ['damagereason'] = 'Beaten up', ['weight'] = 1000},
    ['weapon_knife'] = {['name'] = 'weapon_knife', ['label'] = 'Knife', ['ammotype'] = nil, ['damagereason'] = 'Stabbed', ['weight'] = 1000},
    ['weapon_machete'] = {['name'] = 'weapon_machete', ['label'] = 'Machete', ['ammotype'] = nil, ['damagereason'] = 'Beaten up', ['weight'] = 1000},
    ['weapon_switchblade'] = {['name'] = 'weapon_switchblade', ['label'] = 'Switchblade', ['ammotype'] = nil, ['damagereason'] = 'Stabbed', ['weight'] = 1000},
    ['weapon_nightstick'] = {['name'] = 'weapon_nightstick', ['label'] = 'Nightstick', ['ammotype'] = nil, ['damagereason'] = 'Beaten up', ['weight'] = 1000},
    ['weapon_wrench'] = {['name'] = 'weapon_wrench', ['label'] = 'Wrench', ['ammotype'] = nil, ['damagereason'] = 'Beaten up', ['weight'] = 1000},
    ['weapon_battleaxe'] = {['name'] = 'weapon_battleaxe', ['label'] = 'Battle Axe', ['ammotype'] = nil, ['damagereason'] = 'Beaten up', ['weight'] = 1000},
    ['weapon_poolcue'] = {['name'] = 'weapon_poolcue', ['label'] = 'Pool Cue', ['ammotype'] = nil, ['damagereason'] = 'Beaten up', ['weight'] = 1000},
    ['weapon_stone_hatchet'] = {['name'] = 'weapon_stone_hatchet', ['label'] = 'Stone Hatchet', ['ammotype'] = nil, ['damagereason'] = 'Beaten up', ['weight'] = 1000},

    -- Handguns
    ['weapon_pistol'] = {['name'] = 'weapon_pistol', ['label'] = 'Pistol', ['ammotype'] = 'AMMO_PISTOL', ['damagereason'] = 'Shot', ['weight'] = 1000},
    ['weapon_pistol_mk2'] = {['name'] = 'weapon_pistol_mk2', ['label'] = 'Pistol Mk II', ['ammotype'] = 'AMMO_PISTOL', ['damagereason'] = 'Shot', ['weight'] = 1000},
    ['weapon_combatpistol'] = {['name'] = 'weapon_combatpistol', ['label'] = 'Combat Pistol', ['ammotype'] = 'AMMO_PISTOL', ['damagereason'] = 'Shot', ['weight'] = 1000},
    ['weapon_appistol'] = {['name'] = 'weapon_appistol', ['label'] = 'AP Pistol', ['ammotype'] = 'AMMO_PISTOL', ['damagereason'] = 'Shot', ['weight'] = 1000},
    ['weapon_stungun'] = {['name'] = 'weapon_stungun', ['label'] = 'Taser', ['ammotype'] = 'AMMO_STUNGUN', ['damagereason'] = 'Tased', ['weight'] = 1000},
    ['weapon_pistol50'] = {['name'] = 'weapon_pistol50', ['label'] = 'Pistol .50', ['ammotype'] = 'AMMO_PISTOL', ['damagereason'] = 'Shot', ['weight'] = 1000},
    ['weapon_snspistol'] = {['name'] = 'weapon_snspistol', ['label'] = 'SNS Pistol', ['ammotype'] = 'AMMO_PISTOL', ['damagereason'] = 'Shot', ['weight'] = 1000},
    ['weapon_heavypistol'] = {['name'] = 'weapon_heavypistol', ['label'] = 'Heavy Pistol', ['ammotype'] = 'AMMO_PISTOL', ['damagereason'] = 'Shot', ['weight'] = 1000},
    ['weapon_vintagepistol'] = {['name'] = 'weapon_vintagepistol', ['label'] = 'Vintage Pistol', ['ammotype'] = 'AMMO_PISTOL', ['damagereason'] = 'Shot', ['weight'] = 1000},
    ['weapon_flaregun'] = {['name'] = 'weapon_flaregun', ['label'] = 'Flare Gun', ['ammotype'] = 'AMMO_FLARE', ['damagereason'] = 'Shot', ['weight'] = 1000},
    ['weapon_marksmanpistol'] = {['name'] = 'weapon_marksmanpistol', ['label'] = 'Marksman Pistol', ['ammotype'] = 'AMMO_PISTOL', ['damagereason'] = 'Shot', ['weight'] = 1000},
    ['weapon_revolver'] = {['name'] = 'weapon_revolver', ['label'] = 'Heavy Revolver', ['ammotype'] = 'AMMO_PISTOL', ['damagereason'] = 'Shot', ['weight'] = 1000},
    ['weapon_revolver_mk2'] = {['name'] = 'weapon_revolver_mk2', ['label'] = 'Heavy Revolver Mk II', ['ammotype'] = 'AMMO_PISTOL', ['damagereason'] = 'Shot', ['weight'] = 1000},
    ['weapon_doubleaction'] = {['name'] = 'weapon_doubleaction', ['label'] = 'Double Action Revolver', ['ammotype'] = 'AMMO_PISTOL', ['damagereason'] = 'Shot', ['weight'] = 1000},
    ['weapon_snspistol_mk2'] = {['name'] = 'weapon_snspistol_mk2', ['label'] = 'SNS Pistol Mk II', ['ammotype'] = 'AMMO_PISTOL', ['damagereason'] = 'Shot', ['weight'] = 1000},
    ['weapon_raypistol'] = {['name'] = 'weapon_raypistol', ['label'] = 'Up-n-Atomizer', ['ammotype'] = 'AMMO_PISTOL', ['damagereason'] = 'Shot', ['weight'] = 1000},
    ['weapon_ceramicpistol'] = {['name'] = 'weapon_ceramicpistol', ['label'] = 'Ceramic Pistol', ['ammotype'] = 'AMMO_PISTOL', ['damagereason'] = 'Shot', ['weight'] = 1000},
    ['weapon_navyrevolver'] = {['name'] = 'weapon_navyrevolver', ['label'] = 'Navy Revolver', ['ammotype'] = 'AMMO_PISTOL', ['damagereason'] = 'Shot', ['weight'] = 1000},
    ['weapon_gadgetpistol'] = {['name'] = 'weapon_gadgetpistol', ['label'] = 'Perico Pistol', ['ammotype'] = 'AMMO_PISTOL', ['damagereason'] = 'Shot', ['weight'] = 1000},

    -- Submachine Guns
    ['weapon_microsmg'] = {['name'] = 'weapon_microsmg', ['label'] = 'Micro SMG', ['ammotype'] = 'AMMO_SMG', ['damagereason'] = 'Riddled', ['weight'] = 2500},
    ['weapon_smg'] = {['name'] = 'weapon_smg', ['label'] = 'SMG', ['ammotype'] = 'AMMO_SMG', ['damagereason'] = 'Riddled', ['weight'] = 2500},
    ['weapon_smg_mk2'] = {['name'] = 'weapon_smg_mk2', ['label'] = 'SMG Mk II', ['ammotype'] = 'AMMO_SMG', ['damagereason'] = 'Riddled', ['weight'] = 2500},
    ['weapon_assaultsmg'] = {['name'] = 'weapon_assaultsmg', ['label'] = 'Assault SMG', ['ammotype'] = 'AMMO_SMG', ['damagereason'] = 'Riddled', ['weight'] = 2500},
    ['weapon_combatpdw'] = {['name'] = 'weapon_combatpdw', ['label'] = 'Combat PDW', ['ammotype'] = 'AMMO_SMG', ['damagereason'] = 'Riddled', ['weight'] = 2500},
    ['weapon_machinepistol'] = {['name'] = 'weapon_machinepistol', ['label'] = 'Machine Pistol', ['ammotype'] = 'AMMO_PISTOL', ['damagereason'] = 'Riddled', ['weight'] = 2500},
    ['weapon_minismg'] = {['name'] = 'weapon_minismg', ['label'] = 'Mini SMG', ['ammotype'] = 'AMMO_SMG', ['damagereason'] = 'Riddled', ['weight'] = 2500},
    ['weapon_raycarbine'] = {['name'] = 'weapon_raycarbine', ['label'] = 'Unholy Hellbringer', ['ammotype'] = 'AMMO_SMG', ['damagereason'] = 'Riddled', ['weight'] = 2500},

    -- Shotguns
    ['weapon_pumpshotgun'] = {['name'] = 'weapon_pumpshotgun', ['label'] = 'Pump Shotgun', ['ammotype'] = 'AMMO_SHOTGUN', ['damagereason'] = 'Blasted', ['weight'] = 3000},
    ['weapon_sawnoffshotgun'] = {['name'] = 'weapon_sawnoffshotgun', ['label'] = 'Sawed-off Shotgun', ['ammotype'] = 'AMMO_SHOTGUN', ['damagereason'] = 'Blasted', ['weight'] = 2500},
    ['weapon_assaultshotgun'] = {['name'] = 'weapon_assaultshotgun', ['label'] = 'Assault Shotgun', ['ammotype'] = 'AMMO_SHOTGUN', ['damagereason'] = 'Blasted', ['weight'] = 3000},
    ['weapon_bullpupshotgun'] = {['name'] = 'weapon_bullpupshotgun', ['label'] = 'Bullpup Shotgun', ['ammotype'] = 'AMMO_SHOTGUN', ['damagereason'] = 'Blasted', ['weight'] = 3000},
    ['weapon_musket'] = {['name'] = 'weapon_musket', ['label'] = 'Musket', ['ammotype'] = 'AMMO_SHOTGUN', ['damagereason'] = 'Blasted', ['weight'] = 3000},
    ['weapon_heavyshotgun'] = {['name'] = 'weapon_heavyshotgun', ['label'] = 'Heavy Shotgun', ['ammotype'] = 'AMMO_SHOTGUN', ['damagereason'] = 'Blasted', ['weight'] = 3000},
    ['weapon_dbshotgun'] = {['name'] = 'weapon_dbshotgun', ['label'] = 'Double Barrel Shotgun', ['ammotype'] = 'AMMO_SHOTGUN', ['damagereason'] = 'Blasted', ['weight'] = 3000},
    ['weapon_autoshotgun'] = {['name'] = 'weapon_autoshotgun', ['label'] = 'Sweeper Shotgun', ['ammotype'] = 'AMMO_SHOTGUN', ['damagereason'] = 'Blasted', ['weight'] = 3000},
    ['weapon_pumpshotgun_mk2'] = {['name'] = 'weapon_pumpshotgun_mk2', ['label'] = 'Pump Shotgun Mk II', ['ammotype'] = 'AMMO_SHOTGUN', ['damagereason'] = 'Blasted', ['weight'] = 3000},
    ['weapon_combatshotgun'] = {['name'] = 'weapon_combatshotgun', ['label'] = 'Combat Shotgun', ['ammotype'] = 'AMMO_SHOTGUN', ['damagereason'] = 'Blasted', ['weight'] = 3000},
}

-- Make weapons available to other resources
exports('GetWeapons', function()
    return SLCore.Weapons
end)
