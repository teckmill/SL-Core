Config = {}

-- General Settings
Config.Debug = false
Config.UpdateInterval = 200 -- milliseconds
Config.EnableExperimental = false
Config.DefaultLanguage = 'en'

-- Display Settings
Config.AlwaysDisplayHud = true
Config.HideInPause = true
Config.HideInCutscene = true
Config.HideInPhoto = true

-- Status Settings
Config.Status = {
    Health = {
        Enabled = true,
        Position = 'left',
        Icon = 'heart',
        Color = '#ff0000',
        Blinking = true,
        BlinkThreshold = 20
    },
    Armor = {
        Enabled = true,
        Position = 'left',
        Icon = 'shield',
        Color = '#0066ff',
        ShowEmpty = true
    },
    Stamina = {
        Enabled = true,
        Position = 'left',
        Icon = 'running',
        Color = '#ffff00',
        ShowEmpty = false
    },
    Hunger = {
        Enabled = true,
        Position = 'right',
        Icon = 'hamburger',
        Color = '#ffa500',
        Critical = 20,
        Warning = 40
    },
    Thirst = {
        Enabled = true,
        Position = 'right',
        Icon = 'tint',
        Color = '#00ffff',
        Critical = 20,
        Warning = 40
    },
    Stress = {
        Enabled = true,
        Position = 'right',
        Icon = 'brain',
        Color = '#ff00ff',
        IncreaseSpeed = 0.1,
        DecreaseSpeed = 0.05
    }
}

-- Voice Settings
Config.Voice = {
    Enabled = true,
    Position = 'top-right',
    ShowSpeaker = true,
    ShowRange = true,
    Ranges = {
        {name = 'Whisper', range = 2.0, color = '#ffffff'},
        {name = 'Normal', range = 5.0, color = '#ffff00'},
        {name = 'Shouting', range = 12.0, color = '#ff0000'}
    }
}

-- Vehicle HUD
Config.Vehicle = {
    Enabled = true,
    Position = 'bottom-right',
    ShowSpeed = true,
    ShowFuel = true,
    ShowDamage = true,
    SpeedUnit = 'mph', -- 'mph' or 'kmh'
    FuelWarning = 20,
    DamageWarning = 40
}

-- Minimap Settings
Config.Minimap = {
    Enabled = true,
    Position = 'bottom-left',
    Size = 'normal', -- 'small', 'normal', 'large'
    Rotation = true,
    ShowStreetName = true,
    ShowZoneName = true,
    ShowCompass = true
}

-- Money Display
Config.Money = {
    Enabled = true,
    Position = 'top-right',
    ShowBank = true,
    ShowCash = true,
    ShowChange = true,
    AnimateChanges = true
}

-- Job Display
Config.Job = {
    Enabled = true,
    Position = 'top-right',
    ShowGrade = true,
    ShowDuty = true,
    ShowOrganization = true
}

-- Gang Display
Config.Gang = {
    Enabled = true,
    Position = 'top-right',
    ShowRank = true,
    ShowTerritory = true
}

-- Weapon Display
Config.Weapon = {
    Enabled = true,
    Position = 'bottom-right',
    ShowAmmo = true,
    ShowWeaponName = true,
    ShowWeaponStats = true,
    BlinkLowAmmo = true,
    LowAmmoThreshold = 10
}

-- Cinematic Mode
Config.Cinematic = {
    Enabled = true,
    Key = 'C',
    HideAllHud = true,
    ShowMinimalInfo = false,
    AnimationDuration = 1000
}

-- Custom Colors
Config.Colors = {
    Primary = '#4CAF50',
    Secondary = '#2196F3',
    Success = '#4CAF50',
    Warning = '#FFC107',
    Danger = '#F44336',
    Info = '#2196F3'
}

-- Layout Settings
Config.Layout = {
    Theme = 'dark', -- 'dark', 'light'
    Opacity = 0.9,
    Scale = 1.0,
    Font = 'Roboto',
    RoundedCorners = true,
    BorderWidth = 2,
    Spacing = 10,
    Animation = {
        Enabled = true,
        Duration = 200,
        Easing = 'easeInOutQuad'
    }
}

-- Notification Settings
Config.Notifications = {
    Enabled = true,
    Position = 'top-right',
    Duration = 3000,
    MaxVisible = 5,
    Sound = true,
    SoundVolume = 0.5
}

-- Performance Settings
Config.Performance = {
    LowEndMode = false,
    ReduceAnimations = false,
    DisableBlur = false,
    DisableShadows = false
}

-- Compatibility Settings
Config.Compatibility = {
    RadialMenu = true,
    Inventory = true,
    Phone = true,
    CustomScripts = {}
}

-- Advanced Settings
Config.Advanced = {
    UseNativeUI = false,
    CustomRendering = false,
    AsyncUpdates = true,
    CacheData = true,
    DebugMode = false
}
