Config = {}

-- Phone System Configuration
Config.Phone = {
    DefaultBackground = 'default.jpg',
    MaxContacts = 100,
    MaxMessages = 1000,
    MessageCooldown = 1000, -- milliseconds
    AllowedImageFormats = {'jpg', 'jpeg', 'png'},
    MaxImageSize = 2048, -- KB
    EmergencyNumbers = {
        Police = '911',
        Ambulance = '912',
        Mechanic = '913'
    }
}

-- Social Media Configuration
Config.Social = {
    MaxPostLength = 280,
    MaxCommentLength = 140,
    PostCooldown = 60, -- seconds
    CommentCooldown = 30, -- seconds
    MaxPostImages = 4,
    MaxFollowers = 1000,
    VerifiedRoles = {
        'admin',
        'police_chief',
        'mayor',
        'business_owner'
    }
}

-- Dating Configuration
Config.Dating = {
    MinAge = 18,
    MaxPhotos = 6,
    MaxBioLength = 500,
    MaxInterests = 10,
    SwipeCooldown = 12, -- hours
    MaxMatches = 50,
    PreferenceOptions = {
        Gender = {'Male', 'Female', 'Non-Binary', 'All'},
        AgeRange = {min = 18, max = 99},
        Distance = {min = 0, max = 100} -- km
    }
}

-- Reputation System Configuration
Config.Reputation = {
    Categories = {
        Business = {
            name = 'Business',
            description = 'Reputation in business dealings',
            icon = 'fas fa-briefcase'
        },
        Driving = {
            name = 'Driving',
            description = 'Reputation as a driver',
            icon = 'fas fa-car'
        },
        Social = {
            name = 'Social',
            description = 'General social reputation',
            icon = 'fas fa-users'
        },
        Dating = {
            name = 'Dating',
            description = 'Dating reputation',
            icon = 'fas fa-heart'
        },
        Criminal = {
            name = 'Criminal',
            description = 'Criminal reputation (visible only to criminal organizations)',
            icon = 'fas fa-mask'
        }
    },
    RatingCooldown = 24, -- hours
    MinRating = 1,
    MaxRating = 5,
    InitialScore = 3,
    UpdateInterval = 5 -- minutes
}

-- UI Configuration
Config.UI = {
    DefaultTheme = 'dark',
    Themes = {
        dark = {
            primary = '#1a1a1a',
            secondary = '#2d2d2d',
            accent = '#3498db',
            text = '#ffffff',
            textSecondary = '#bbbbbb'
        },
        light = {
            primary = '#ffffff',
            secondary = '#f5f5f5',
            accent = '#2980b9',
            text = '#000000',
            textSecondary = '#555555'
        }
    },
    Animations = {
        Duration = 300,
        Easing = 'ease-in-out'
    },
    Sounds = {
        Enabled = true,
        Volume = 0.5,
        Effects = {
            message = 'message.ogg',
            notification = 'notification.ogg',
            match = 'match.ogg'
        }
    }
}

-- Framework Integration
Config.Framework = {
    Name = 'qb-core',
    UseCustomPhone = true,
    UseCustomNotifications = true,
    Debug = false
}

-- Notification Types
Config.NotificationTypes = {
    message = {
        icon = 'fas fa-envelope',
        color = '#3498db'
    },
    like = {
        icon = 'fas fa-heart',
        color = '#e74c3c'
    },
    comment = {
        icon = 'fas fa-comment',
        color = '#2ecc71'
    },
    follow = {
        icon = 'fas fa-user-plus',
        color = '#f1c40f'
    },
    match = {
        icon = 'fas fa-fire',
        color = '#e67e22'
    },
    reputation = {
        icon = 'fas fa-star',
        color = '#9b59b6'
    }
}

-- Permission Levels
Config.Permissions = {
    admin = {
        canManagePosts = true,
        canManageUsers = true,
        canViewAllProfiles = true,
        canModifyReputation = true
    },
    moderator = {
        canManagePosts = true,
        canManageUsers = false,
        canViewAllProfiles = true,
        canModifyReputation = false
    },
    user = {
        canManagePosts = false,
        canManageUsers = false,
        canViewAllProfiles = false,
        canModifyReputation = false
    }
}
