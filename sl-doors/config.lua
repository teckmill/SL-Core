Config = {}

-- General Settings
Config.Debug = false
Config.DefaultDoorState = false -- false = locked, true = unlocked
Config.LockRange = 2.5 -- Distance to lock/unlock doors
Config.DrawTextRange = 2.0 -- Distance to show door text
Config.MaxKeys = 10 -- Maximum number of keys per door

-- Door Types
Config.DoorTypes = {
    ['normal'] = {
        lockpickTime = 30, -- Time in seconds to lockpick
        lockpickChance = 50, -- Chance of successful lockpick (0-100)
        breakChance = 25, -- Chance of lockpick breaking (0-100)
        requiredItems = {'lockpick'} -- Items required for lockpicking
    },
    ['secure'] = {
        lockpickTime = 45,
        lockpickChance = 30,
        breakChance = 40,
        requiredItems = {'advanced_lockpick'}
    },
    ['high_security'] = {
        lockpickTime = 60,
        lockpickChance = 10,
        breakChance = 60,
        requiredItems = {'electronic_kit'}
    }
}

-- Door Groups
Config.DoorGroups = {
    ['police'] = {
        label = 'Police Department',
        jobs = {
            ['police'] = 0, -- Minimum grade required (0 = all grades)
            ['sheriff'] = 0
        }
    },
    ['ambulance'] = {
        label = 'Hospital',
        jobs = {
            ['ambulance'] = 0,
            ['doctor'] = 0
        }
    },
    ['mechanic'] = {
        label = 'Mechanic Shop',
        jobs = {
            ['mechanic'] = 0
        }
    }
}

-- Default Doors
Config.Doors = {
    -- Police Department Front Door
    ['mrpd_front'] = {
        label = 'MRPD Front Door',
        group = 'police',
        coords = vector3(434.7444, -980.7556, 30.8153),
        model = 'v_ilev_ph_door01',
        type = 'secure',
        auto_distance = 5.0, -- Distance for automatic doors (nil for manual)
        auto_wait = 5000, -- Time to stay open in ms
        double_door = false -- Is this a double door?
    },
    
    -- Hospital Main Entrance
    ['pillbox_main'] = {
        label = 'Pillbox Main Entrance',
        group = 'ambulance',
        coords = vector3(298.2, -584.3, 43.2),
        model = 'v_ilev_ph_door002',
        type = 'normal',
        auto_distance = 3.0,
        auto_wait = 5000,
        double_door = true,
        other_door = 'pillbox_main2' -- ID of the other door in the pair
    },
    ['pillbox_main2'] = {
        label = 'Pillbox Main Entrance',
        group = 'ambulance',
        coords = vector3(301.2, -581.3, 43.2),
        model = 'v_ilev_ph_door002',
        type = 'normal',
        auto_distance = 3.0,
        auto_wait = 5000,
        double_door = true,
        other_door = 'pillbox_main'
    }
}

-- Notification Settings
Config.Notifications = {
    ['locked'] = {
        type = 'error',
        text = 'Door is now locked'
    },
    ['unlocked'] = {
        type = 'success',
        text = 'Door is now unlocked'
    },
    ['no_access'] = {
        type = 'error',
        text = 'You do not have access to this door'
    },
    ['lockpick_failed'] = {
        type = 'error',
        text = 'Lockpicking failed'
    },
    ['lockpick_broke'] = {
        type = 'error',
        text = 'Your lockpick broke'
    }
}

-- Draw Text Settings
Config.DrawText = {
    ['locked'] = {
        text = '[E] Locked',
        color = {255, 50, 50}
    },
    ['unlocked'] = {
        text = '[E] Unlocked',
        color = {50, 255, 50}
    },
    ['locking'] = {
        text = 'Locking...',
        color = {255, 255, 255}
    },
    ['unlocking'] = {
        text = 'Unlocking...',
        color = {255, 255, 255}
    }
}
