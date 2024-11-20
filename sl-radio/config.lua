Config = {}

-- Radio settings
Config.MaxFrequency = 500  -- Maximum radio frequency
Config.RestrictedChannels = 10  -- Channels 1-10 are restricted to emergency services
Config.MinFrequency = 1  -- Minimum radio frequency

-- Restricted channels configuration
Config.RestrictedChannels = {
    [1] = {
        police = true,
        ambulance = true
    },
    [2] = {
        police = true,
        ambulance = true
    },
    [3] = {
        police = true
    },
    [4] = {
        police = true
    },
    [5] = {
        police = true
    },
    [6] = {
        ambulance = true
    },
    [7] = {
        ambulance = true
    },
    [8] = {
        police = true,
        ambulance = true
    },
    [9] = {
        police = true,
        ambulance = true
    },
    [10] = {
        police = true,
        ambulance = true
    }
}
