Config = {}

-- Notification Types
Config.Types = {
    SUCCESS = 'success',
    ERROR = 'error',
    INFO = 'info',
    WARNING = 'warning',
    SYSTEM = 'system'
}

-- Notification Positions
Config.Positions = {
    TOP_LEFT = 'top-left',
    TOP_RIGHT = 'top-right',
    TOP_CENTER = 'top-center',
    BOTTOM_LEFT = 'bottom-left',
    BOTTOM_RIGHT = 'bottom-right',
    BOTTOM_CENTER = 'bottom-center',
    CENTER_LEFT = 'center-left',
    CENTER_RIGHT = 'center-right',
    CENTER = 'center'
}

-- Default Settings
Config.DefaultSettings = {
    Type = Config.Types.INFO,
    Position = Config.Positions.TOP_RIGHT,
    Duration = 3000,
    Sound = true,
    SoundFile = 'notification',
    SoundVolume = 0.5,
    Animation = true,
    AnimationDuration = 300,
    Theme = 'dark',
    Icon = true,
    Progress = true,
    Closable = true,
    Queue = true
}

-- Queue Settings
Config.Queue = {
    Enabled = true,
    MaxSize = 5,
    Spacing = 10,
    ProcessInterval = 100
}

-- Style Settings
Config.Style = {
    Width = '300px',
    BorderRadius = '8px',
    FontFamily = 'Poppins',
    FontSize = '14px',
    IconSize = '24px',
    Colors = {
        Success = '#4CAF50',
        Error = '#F44336',
        Info = '#2196F3',
        Warning = '#FFC107',
        System = '#9C27B0',
        Background = {
            Light = '#FFFFFF',
            Dark = '#1E1E1E'
        },
        Text = {
            Light = '#000000',
            Dark = '#FFFFFF'
        }
    }
}

-- Sound Settings
Config.Sounds = {
    Enabled = true,
    Volume = 0.5,
    Files = {
        Success = 'success.ogg',
        Error = 'error.ogg',
        Info = 'info.ogg',
        Warning = 'warning.ogg',
        System = 'system.ogg'
    }
}

-- Animation Settings
Config.Animations = {
    Enabled = true,
    In = 'fadeIn',
    Out = 'fadeOut',
    Duration = 300,
    Easing = 'ease-in-out'
}

-- Mobile Settings
Config.Mobile = {
    Enabled = true,
    BreakPoint = 768,
    Position = Config.Positions.TOP_CENTER,
    Width = '90%'
}

-- Debug Settings
Config.Debug = false
Config.LogNotifications = true
