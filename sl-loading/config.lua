Config = {}

-- Loading Screen Settings
Config.Title = 'SL Framework'
Config.Subtitle = 'Welcome to Our Server'
Config.Description = 'Experience the next generation of FiveM roleplay'

-- Background Settings
Config.BackgroundType = 'slideshow' -- 'image', 'slideshow', 'video'
Config.BackgroundImages = {
    'img/bg1.jpg',
    'img/bg2.jpg',
    'img/bg3.jpg'
}
Config.SlideshowDuration = 5000 -- milliseconds
Config.BackgroundVideo = 'video/background.mp4'
Config.BackgroundOpacity = 0.8

-- Music Settings
Config.EnableMusic = true
Config.MusicVolume = 0.3
Config.MusicTracks = {
    {
        name = 'Track 1',
        file = 'music/track1.mp3'
    },
    {
        name = 'Track 2',
        file = 'music/track2.mp3'
    }
}
Config.ShuffleTracks = true

-- Loading Tips
Config.EnableTips = true
Config.TipInterval = 5000 -- milliseconds
Config.Tips = {
    'Press M to open your phone',
    'Join our Discord community',
    'Check out our website for more information',
    'Report bugs on our forums'
}

-- Server Info
Config.ShowServerInfo = true
Config.ServerName = 'SL Framework Server'
Config.ServerLogo = 'img/logo.png'
Config.DiscordLink = 'https://discord.gg/slframework'
Config.WebsiteLink = 'https://slframework.com'

-- Loading Progress
Config.ShowProgress = true
Config.ProgressType = 'bar' -- 'bar', 'circle', 'dots'
Config.ProgressMessages = {
    'Initializing game...',
    'Loading world...',
    'Preparing resources...',
    'Almost there...'
}

-- Visual Settings
Config.Theme = {
    Primary = '#4CAF50',
    Secondary = '#2196F3',
    Background = '#1E1E1E',
    Text = '#FFFFFF',
    TextSecondary = '#CCCCCC'
}

Config.Font = {
    Primary = 'Poppins',
    Secondary = 'Roboto'
}

-- Animation Settings
Config.EnableAnimations = true
Config.AnimationDuration = 500 -- milliseconds

-- Debug Settings
Config.Debug = false
Config.LogEvents = true
