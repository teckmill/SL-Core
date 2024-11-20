SLConfig = {}

SLConfig.MaxPlayers = GetConvarInt('sv_maxclients', 48) -- Gets max players from config file, default 48
SLConfig.DefaultSpawn = vector4(-1035.71, -2731.87, 12.86, 0.0)
SLConfig.UpdateInterval = 5                             -- how often to update player data in minutes
SLConfig.StatusInterval = 5000                          -- how often to check hunger/thirst status in milliseconds

SLConfig.Money = {}
SLConfig.Money.MoneyTypes = { cash = 500, bank = 5000, crypto = 0 } -- type = startamount - Add or remove money types for your server (for ex. blackmoney = 0), remember once added it will not be removed from the database!
SLConfig.Money.DontAllowMinus = { 'cash', 'crypto' }                -- Money that is not allowed going in minus
SLConfig.Money.MinusLimit = -5000                                    -- The maximum amount you can be negative 
SLConfig.Money.PayCheckTimeOut = 10                                 -- The time in minutes that it will give the paycheck
SLConfig.Money.PayCheckSociety = false                              -- If true paycheck will come from the society account that the player is employed at

SLConfig.Player = {}
SLConfig.Player.MaxWeight = 120000                                   -- Max weight a player can carry (currently 120kg, written in grams)
SLConfig.Player.MaxInvSlots = 41                                    -- Max inventory slots for a player
SLConfig.Player.HungerRate = 4.2                                    -- Rate at which hunger goes down.
SLConfig.Player.ThirstRate = 3.8                                    -- Rate at which thirst goes down.
SLConfig.Player.Bloodtypes = {
    "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-",
}

SLConfig.Server = {}                                    -- General server config
SLConfig.Server.Closed = false                          -- Set server closed (no one can join except people with ace permission 'sladmin.join')
SLConfig.Server.ClosedReason = "Server Closed"          -- Reason message to display when people can't join the server
SLConfig.Server.Uptime = 0                              -- Time the server has been up.
SLConfig.Server.Whitelist = false                       -- Enable or disable whitelist on the server
SLConfig.Server.WhitelistPermission = 'admin'           -- Permission that's able to enter the server when the whitelist is on
SLConfig.Server.PVP = true                              -- Enable or disable pvp on the server (Ability to shoot other players)
SLConfig.Server.Discord = ''                            -- Discord invite link
SLConfig.Server.CheckDuplicateLicense = true            -- Check for duplicate rockstar license on join
SLConfig.Server.Permissions = { 'god', 'admin', 'mod' } -- Add as many groups as you want here after creating them in your server.cfg

SLConfig.Commands = {}                                  -- Command Configuration
SLConfig.Commands.OOCColor = { 255, 151, 133 }          -- RGB color code for the OOC command

SLConfig.Notify = {}

SLConfig.Notify.NotificationStyling = {
    group = false,      -- Allow notifications to stack with a badge instead of repeating
    position = 'right', -- top-left | top-right | bottom-left | bottom-right | top | bottom | left | right | center
    progress = true     -- Display Progress Bar
}
