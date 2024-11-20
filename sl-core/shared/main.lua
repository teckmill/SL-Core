SLCore = {}
SLCore.Shared = {}
SLCore.Config = {}
SLCore.Players = {}
SLCore.Functions = {}
SLCore.Commands = {}
SLCore.RequestId = 0
SLCore.Callbacks = {}

-- Initialize Locale System
SLCore.Shared.Languages = {}
SLCore.Shared.CurrentLanguage = 'en'

-- Export core object
exports('GetCoreObject', function()
    return SLCore
end)

-- Version check
SLCore.Config.Version = '1.0.0'

-- Server Configuration
SLCore.Config.Server = {
    Debug = false,
    Closed = false,
    ClosedReason = "Server is currently closed.",
    Uptime = 0,
    WhitelistRequired = false,
    Discord = "",
    CheckDuplicateLicense = true,
    Permissions = {'god', 'admin', 'mod'},
    DefaultSpawn = vector4(-1035.71, -2731.87, 12.86, 0.0),
    AfkTimeout = 1800, -- 30 minutes
}

-- Money Configuration
SLCore.Config.Money = {
    MoneyTypes = {['cash'] = 500, ['bank'] = 5000, ['crypto'] = 0},
    DontAllowMinus = {'cash', 'crypto'},
    PayCheckTimeOut = 10,
}

-- Player Configuration
SLCore.Config.Player = {
    MaxWeight = 120000,
    MaxInvSlots = 41,
    HungerRate = 4.2,
    ThirstRate = 3.8,
    AdminList = {},
}

-- Shared Functions
function SLCore.Shared.Print(msg)
    print('^3[sl-core]^7 ' .. msg)
end

function SLCore.Shared.RandomInt(length)
    if length <= 0 then return '' end
    return tostring(math.random(1, 10 ^ length - 1))
end

function SLCore.Shared.RandomStr(length)
    if length <= 0 then return '' end
    local res = ''
    for i = 1, length do
        res = res .. string.char(math.random(97, 122))
    end
    return res
end

function SLCore.Shared.SplitStr(str, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)
    while delim_from do
        result[#result + 1] = string.sub(str, from, delim_from - 1)
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
    end
    result[#result + 1] = string.sub(str, from)
    return result
end

function SLCore.Shared.TableContains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function SLCore.Shared.Round(value, numDecimalPlaces)
    if numDecimalPlaces then
        local power = 10 ^ numDecimalPlaces
        return math.floor((value * power) + 0.5) / power
    else
        return math.floor(value + 0.5)
    end
end

-- Initialize default locale
CreateThread(function()
    Wait(0) -- Wait for all resources to load
    
    -- Add default English translations
    SLCore.Shared.Locale('en', {
        error = {
            generic = "An error occurred",
            invalid_value = "Invalid value provided",
            missing_param = "Missing required parameter",
            not_authorized = "Not authorized to perform this action",
        },
        success = {
            generic = "Operation successful",
            saved = "Changes saved successfully",
            loaded = "Data loaded successfully",
        },
        info = {
            loading = "Loading...",
            processing = "Processing...",
            waiting = "Please wait...",
        }
    })
end)

-- Make core object globally accessible
_G.SLCore = SLCore
