Config = {}

-- Skill configuration
Config.Skills = {
    ['strength'] = {
        name = 'Strength',
        description = 'Increases melee damage and carrying capacity',
        maxLevel = 100,
        xpPerLevel = 1000,
        activities = {
            ['boxing'] = 5,
            ['weightlifting'] = 3,
            ['running'] = 1,
            ['swimming'] = 2,
            ['fighting'] = 4
        }
    },
    ['stamina'] = {
        name = 'Stamina',
        description = 'Increases running and swimming duration',
        maxLevel = 100,
        xpPerLevel = 1000,
        activities = {
            ['running'] = 5,
            ['swimming'] = 4,
            ['cycling'] = 3,
            ['parkour'] = 2
        }
    },
    ['shooting'] = {
        name = 'Shooting',
        description = 'Improves weapon accuracy and recoil control',
        maxLevel = 100,
        xpPerLevel = 1000,
        activities = {
            ['target_practice'] = 5,
            ['hunting'] = 3,
            ['combat'] = 4
        }
    },
    ['driving'] = {
        name = 'Driving',
        description = 'Improves vehicle handling and reduces damage',
        maxLevel = 100,
        xpPerLevel = 1000,
        activities = {
            ['racing'] = 5,
            ['drifting'] = 4,
            ['delivery'] = 2
        }
    },
    ['crafting'] = {
        name = 'Crafting',
        description = 'Improves crafting success rate and unlocks recipes',
        maxLevel = 100,
        xpPerLevel = 1000,
        activities = {
            ['item_crafting'] = 5,
            ['repair'] = 3,
            ['cooking'] = 2
        }
    }
}

-- Skill bonuses configuration
Config.Bonuses = {
    ['strength'] = {
        [25] = {
            type = 'melee_damage',
            value = 1.1,
            description = '10% increased melee damage'
        },
        [50] = {
            type = 'carry_weight',
            value = 1.2,
            description = '20% increased carrying capacity'
        },
        [75] = {
            type = 'melee_damage',
            value = 1.3,
            description = '30% increased melee damage'
        },
        [100] = {
            type = 'both',
            value = 1.5,
            description = '50% increased melee damage and carrying capacity'
        }
    },
    ['stamina'] = {
        [25] = {
            type = 'sprint_duration',
            value = 1.1,
            description = '10% increased sprint duration'
        },
        [50] = {
            type = 'swim_speed',
            value = 1.2,
            description = '20% increased swim speed'
        },
        [75] = {
            type = 'sprint_duration',
            value = 1.3,
            description = '30% increased sprint duration'
        },
        [100] = {
            type = 'both',
            value = 1.5,
            description = '50% increased stamina regeneration'
        }
    },
    ['shooting'] = {
        [25] = {
            type = 'accuracy',
            value = 1.1,
            description = '10% increased accuracy'
        },
        [50] = {
            type = 'recoil',
            value = 0.8,
            description = '20% reduced recoil'
        },
        [75] = {
            type = 'accuracy',
            value = 1.3,
            description = '30% increased accuracy'
        },
        [100] = {
            type = 'both',
            value = 1.5,
            description = '50% increased accuracy and reduced recoil'
        }
    },
    ['driving'] = {
        [25] = {
            type = 'handling',
            value = 1.1,
            description = '10% improved handling'
        },
        [50] = {
            type = 'damage_reduction',
            value = 0.8,
            description = '20% reduced vehicle damage'
        },
        [75] = {
            type = 'handling',
            value = 1.3,
            description = '30% improved handling'
        },
        [100] = {
            type = 'both',
            value = 1.5,
            description = '50% improved handling and damage reduction'
        }
    },
    ['crafting'] = {
        [25] = {
            type = 'success_rate',
            value = 1.1,
            description = '10% increased crafting success rate'
        },
        [50] = {
            type = 'material_cost',
            value = 0.9,
            description = '10% reduced material costs'
        },
        [75] = {
            type = 'success_rate',
            value = 1.3,
            description = '30% increased crafting success rate'
        },
        [100] = {
            type = 'both',
            value = 1.5,
            description = '50% increased success rate and reduced costs'
        }
    }
}

-- XP multiplier for VIP players
Config.VIPMultiplier = 1.5

-- Minimum time (in seconds) between XP gains for the same activity
Config.XPCooldown = 5

-- Maximum XP that can be gained per activity instance
Config.MaxXPPerActivity = 100

-- Whether to save skills periodically (in addition to player logout)
Config.PeriodicSave = true
Config.SaveInterval = 5 -- minutes

-- UI configuration
Config.UI = {
    showNotifications = true,
    showLevelUpEffects = true,
    showXPBar = true,
    notificationDuration = 3000
}
