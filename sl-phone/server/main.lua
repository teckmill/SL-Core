local SLCore = exports['sl-core']:GetCoreObject()

-- Database Tables
local function InitializeDatabase()
    local queries = {
        [[
            CREATE TABLE IF NOT EXISTS `phone_contacts` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `identifier` VARCHAR(50) NOT NULL,
                `name` VARCHAR(50) NOT NULL,
                `number` VARCHAR(10) NOT NULL,
                `iban` VARCHAR(50) DEFAULT NULL,
                `photo` TEXT DEFAULT NULL,
                PRIMARY KEY (`id`),
                INDEX `identifier` (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `phone_messages` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `identifier` VARCHAR(50) NOT NULL,
                `sender` VARCHAR(10) NOT NULL,
                `receiver` VARCHAR(10) NOT NULL,
                `message` TEXT NOT NULL,
                `attachments` TEXT DEFAULT NULL,
                `time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                `isRead` TINYINT(1) DEFAULT 0,
                PRIMARY KEY (`id`),
                INDEX `identifier` (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `phone_tweets` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `identifier` VARCHAR(50) NOT NULL,
                `author` VARCHAR(50) NOT NULL,
                `message` VARCHAR(280) NOT NULL,
                `time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                `likes` INT(11) DEFAULT 0,
                `hashtags` VARCHAR(255) DEFAULT NULL,
                `mentions` VARCHAR(255) DEFAULT NULL,
                PRIMARY KEY (`id`),
                INDEX `identifier` (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `phone_photos` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `identifier` VARCHAR(50) NOT NULL,
                `photo` TEXT NOT NULL,
                `time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                `description` VARCHAR(255) DEFAULT NULL,
                PRIMARY KEY (`id`),
                INDEX `identifier` (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `phone_invoices` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `identifier` VARCHAR(50) NOT NULL,
                `sender` VARCHAR(50) NOT NULL,
                `receiver` VARCHAR(50) NOT NULL,
                `amount` INT(11) NOT NULL,
                `reason` VARCHAR(255) NOT NULL,
                `time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                `paid` TINYINT(1) DEFAULT 0,
                PRIMARY KEY (`id`),
                INDEX `identifier` (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]],
        [[
            CREATE TABLE IF NOT EXISTS `phone_calls` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `identifier` VARCHAR(50) NOT NULL,
                `caller` VARCHAR(10) NOT NULL,
                `receiver` VARCHAR(10) NOT NULL,
                `time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                `duration` INT(11) DEFAULT 0,
                `accepted` TINYINT(1) DEFAULT 0,
                PRIMARY KEY (`id`),
                INDEX `identifier` (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]]
    }

    for _, query in ipairs(queries) do
        MySQL.Sync.execute(query)
    end
end

-- Get Phone Data
local function GetPhoneData(source)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return nil end
    
    local identifier = Player.PlayerData.citizenid
    local phoneNumber = Player.PlayerData.charinfo.phone
    
    local result = {
        PlayerData = Player.PlayerData,
        MetaData = Player.PlayerData.metadata,
        Contacts = MySQL.Sync.fetchAll('SELECT * FROM phone_contacts WHERE identifier = ?', {identifier}),
        Messages = MySQL.Sync.fetchAll('SELECT * FROM phone_messages WHERE identifier = ? ORDER BY time DESC LIMIT 50', {identifier}),
        Tweets = MySQL.Sync.fetchAll('SELECT * FROM phone_tweets ORDER BY time DESC LIMIT 50'),
        Invoices = MySQL.Sync.fetchAll('SELECT * FROM phone_invoices WHERE identifier = ? AND paid = 0', {identifier}),
        Photos = MySQL.Sync.fetchAll('SELECT * FROM phone_photos WHERE identifier = ? ORDER BY time DESC', {identifier}),
        Calls = MySQL.Sync.fetchAll('SELECT * FROM phone_calls WHERE identifier = ? ORDER BY time DESC LIMIT 50', {identifier}),
    }
    
    return result
end

-- Add Contact
local function AddContact(source, name, number)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local identifier = Player.PlayerData.citizenid
    local success = MySQL.Sync.execute('INSERT INTO phone_contacts (identifier, name, number) VALUES (?, ?, ?)',
        {identifier, name, number})
    
    return success
end

-- Send Message
local function SendMessage(source, receiver, message, attachments)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local identifier = Player.PlayerData.citizenid
    local sender = Player.PlayerData.charinfo.phone
    
    local success = MySQL.Sync.execute('INSERT INTO phone_messages (identifier, sender, receiver, message, attachments) VALUES (?, ?, ?, ?, ?)',
        {identifier, sender, receiver, message, json.encode(attachments or {})})
    
    if success then
        local Target = SLCore.Functions.GetPlayerByPhone(receiver)
        if Target then
            TriggerClientEvent('sl-phone:client:ReceiveMessage', Target.PlayerData.source, {
                sender = sender,
                message = message,
                attachments = attachments,
                time = os.date()
            })
        end
    end
    
    return success
end

-- Callbacks
SLCore.Functions.CreateCallback('sl-phone:server:GetPhoneData', function(source, cb)
    local phoneData = GetPhoneData(source)
    cb(phoneData)
end)

-- Events
RegisterNetEvent('sl-phone:server:AddContact', function(data)
    local source = source
    local success = AddContact(source, data.name, data.number)
    if success then
        TriggerClientEvent('sl-phone:client:ContactAdded', source, data)
    end
end)

RegisterNetEvent('sl-phone:server:SendMessage', function(data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    local Target = SLCore.Functions.GetPlayerByPhone(data.number)

    if Target then
        TriggerClientEvent('sl-phone:client:ReceiveMessage', Target.PlayerData.source, {
            sender = Player.PlayerData.charinfo.phone,
            content = data.message,
            time = os.date('%H:%M')
        })
        
        -- Save to database
        MySQL.insert('INSERT INTO phone_messages (sender, receiver, message) VALUES (?, ?, ?)',
            {Player.PlayerData.charinfo.phone, data.number, data.message})
    end
end)

-- Load player messages
RegisterNetEvent('sl-phone:server:LoadMessages', function()
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    local messages = MySQL.query.await('SELECT * FROM phone_messages WHERE sender = ? OR receiver = ?',
        {Player.PlayerData.charinfo.phone, Player.PlayerData.charinfo.phone})
    
    TriggerClientEvent('sl-phone:client:LoadMessages', src, messages)
end)

-- Initialize
CreateThread(function()
    InitializeDatabase()
end)
