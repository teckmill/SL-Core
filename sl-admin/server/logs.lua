local SLCore = exports['sl-core']:GetCoreObject()

local webhooks = {
    ['kicks'] = '',      -- Add your Discord webhook for kicks
    ['bans'] = '',       -- Add your Discord webhook for bans
    ['unbans'] = '',     -- Add your Discord webhook for unbans
    ['reports'] = '',    -- Add your Discord webhook for reports
    ['actions'] = '',    -- Add your Discord webhook for general admin actions
    ['spawns'] = '',     -- Add your Discord webhook for vehicle/item spawns
    ['teleports'] = ''   -- Add your Discord webhook for teleport actions
}

local colors = {
    ['kicks'] = 15158332,    -- Red
    ['bans'] = 10038562,     -- Dark Red
    ['unbans'] = 3066993,    -- Green
    ['reports'] = 15105570,  -- Orange
    ['actions'] = 3447003,   -- Blue
    ['spawns'] = 9807270,    -- Gray
    ['teleports'] = 8359053  -- Purple
}

-- Format the message with proper Discord markdown
local function FormatMessage(message)
    return string.gsub(message, '`', '\\`')
end

-- Send log to Discord
local function SendToDiscord(webhook, title, message, color)
    if webhook == '' then return end
    
    local embed = {
        {
            ["title"] = title,
            ["description"] = FormatMessage(message),
            ["type"] = "rich",
            ["color"] = color or 3447003,
            ["footer"] = {
                ["text"] = "SL Admin | " .. os.date("%Y-%m-%d %H:%M:%S")
            }
        }
    }
    
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = 'SL Admin',
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

-- Log an admin action
local function LogAdminAction(type, data)
    if not webhooks[type] then return end
    
    local title = "Admin Action: " .. type:gsub("^%l", string.upper)
    local message = ""
    
    if type == 'kicks' then
        message = string.format("Admin: `%s`\nTarget: `%s`\nReason: `%s`", 
            data.admin or "Unknown",
            data.target or "Unknown",
            data.reason or "No reason provided"
        )
    elseif type == 'bans' then
        message = string.format("Admin: `%s`\nTarget: `%s`\nDuration: `%s`\nReason: `%s`", 
            data.admin or "Unknown",
            data.target or "Unknown",
            data.duration and (data.duration .. " hours") or "Permanent",
            data.reason or "No reason provided"
        )
    elseif type == 'unbans' then
        message = string.format("Admin: `%s`\nUnbanned Player: `%s`", 
            data.admin or "Unknown",
            data.target or "Unknown"
        )
    elseif type == 'reports' then
        message = string.format("Reporter: `%s`\nReport: `%s`", 
            data.player or "Unknown",
            data.message or "No message provided"
        )
    elseif type == 'actions' then
        message = string.format("Admin: `%s`\nAction: `%s`", 
            data.admin or "Unknown",
            data.action or "Unknown action"
        )
    elseif type == 'spawns' then
        message = string.format("Admin: `%s`\nSpawned: `%s`", 
            data.admin or "Unknown",
            data.item or "Unknown item"
        )
    elseif type == 'teleports' then
        message = string.format("Admin: `%s`\nAction: `%s`\nTarget: `%s`", 
            data.admin or "Unknown",
            data.action or "Unknown action",
            data.target or "Unknown"
        )
    end
    
    SendToDiscord(webhooks[type], title, message, colors[type])
end

-- Export the logging function
exports('LogAdminAction', LogAdminAction)

-- Event handler for logging
RegisterNetEvent('sl-admin:server:Log')
AddEventHandler('sl-admin:server:Log', function(type, data)
    local source = source
    if not IsPlayerAceAllowed(source, "command") then return end
    LogAdminAction(type, data)
end)

-- Log to database
local function LogToDatabase(type, data)
    local timestamp = os.time()
    MySQL.insert('INSERT INTO admin_logs (type, admin, target, action, data, timestamp) VALUES (?, ?, ?, ?, ?, ?)',
        {type, data.admin or "Unknown", data.target or "Unknown", data.action or "Unknown", json.encode(data), timestamp}
    )
end

-- Export the database logging function
exports('LogToDatabase', LogToDatabase)

-- Event handler for database logging
RegisterNetEvent('sl-admin:server:LogToDatabase')
AddEventHandler('sl-admin:server:LogToDatabase', function(type, data)
    local source = source
    if not IsPlayerAceAllowed(source, "command") then return end
    LogToDatabase(type, data)
end)
