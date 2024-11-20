window.Config = {
    // Loading Screen Settings
    Title: 'SL Framework',
    Subtitle: 'Welcome to Our Server',
    Description: 'Experience the next generation of FiveM roleplay',

    // Background Settings
    BackgroundType: 'slideshow', // 'image', 'slideshow', 'video'
    BackgroundImages: [
        'img/bg1.jpg',
        'img/bg2.jpg',
        'img/bg3.jpg'
    ],
    SlideshowDuration: 5000, // milliseconds
    BackgroundVideo: 'video/background.mp4',
    BackgroundOpacity: 0.8,

    // Music Settings
    EnableMusic: true,
    MusicVolume: 0.3,
    MusicTracks: [
        {
            name: 'Track 1',
            file: 'music/track1.mp3'
        },
        {
            name: 'Track 2',
            file: 'music/track2.mp3'
        }
    ],
    ShuffleTracks: true,

    // Loading Tips
    EnableTips: true,
    TipInterval: 5000, // milliseconds
    Tips: [
        'Press M to open your phone',
        'Join our Discord community',
        'Check out our website for more information',
        'Report bugs on our forums'
    ],

    // Server Info
    ShowServerInfo: true,
    ServerName: 'SL Framework Server',
    ServerLogo: 'img/logo.png',
    DiscordLink: 'https://discord.gg/slframework',
    WebsiteLink: 'https://slframework.com',

    // Loading Progress
    ShowProgress: true,
    ProgressType: 'bar', // 'bar', 'circle', 'dots'
    ProgressMessages: [
        'Initializing game...',
        'Loading world...',
        'Preparing resources...',
        'Almost there...'
    ],

    // Visual Settings
    Theme: {
        Primary: '#4CAF50',
        Secondary: '#2196F3',
        Background: '#1E1E1E',
        Text: '#FFFFFF',
        TextSecondary: '#CCCCCC'
    },

    // Animation Settings
    EnableAnimations: true,
    AnimationDuration: 500, // milliseconds

    // Debug Settings
    Debug: false,
    LogEvents: true
};
