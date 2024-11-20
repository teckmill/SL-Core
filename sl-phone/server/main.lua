local SLCore = nil
local CoreReady = false

-- Initialize Database
local function InitializeDatabase()
    MySQL.ready(function()
        MySQL.Sync.execute([[
            CREATE TABLE IF NOT EXISTS `phone_contacts` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `owner` varchar(60) NOT NULL,
                `name` varchar(60) NOT NULL,
                `number` varchar(20) NOT NULL,
                PRIMARY KEY (`id`),
                KEY `owner` (`owner`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])

        MySQL.Sync.execute([[
            CREATE TABLE IF NOT EXISTS `phone_messages` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `sender` varchar(60) NOT NULL,
                `receiver` varchar(60) NOT NULL,
                `message` text NOT NULL,
                `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
                `read` tinyint(1) NOT NULL DEFAULT '0',
                PRIMARY KEY (`id`),
                KEY `sender` (`sender`),
                KEY `receiver` (`receiver`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])

        MySQL.Sync.execute([[
            CREATE TABLE IF NOT EXISTS `phone_calls` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `caller` varchar(60) NOT NULL,
                `receiver` varchar(60) NOT NULL,
                `start_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
                `end_time` timestamp NULL DEFAULT NULL,
                `duration` int(11) DEFAULT NULL,
                `status` enum('missed','answered','rejected') NOT NULL,
                PRIMARY KEY (`id`),
                KEY `caller` (`caller`),
                KEY `receiver` (`receiver`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])

        print('^2[SL-Phone] ^7Database tables initialized successfully')
    end)
end

-- Register Server Callbacks
local function RegisterCallbacks()
    if not CoreReady then return end

    SLCore.Functions.CreateCallback('sl-phone:server:GetContacts', function(source, cb)
        local Player = SLCore.Functions.GetPlayer(source)
        if not Player then return cb({}) end
        
        local result = MySQL.Sync.fetchAll('SELECT * FROM phone_contacts WHERE owner = ?', {
            Player.PlayerData.citizenid
        })
        cb(result)
    end)

    SLCore.Functions.CreateCallback('sl-phone:server:GetMessages', function(source, cb)
        local Player = SLCore.Functions.GetPlayer(source)
        if not Player then return cb({}) end
        
        local result = MySQL.Sync.fetchAll('SELECT * FROM phone_messages WHERE sender = ? OR receiver = ? ORDER BY timestamp DESC', {
            Player.PlayerData.citizenid,
            Player.PlayerData.citizenid
        })
        cb(result)
    end)

    SLCore.Functions.CreateCallback('sl-phone:server:GetPhoneData', function(source, cb)
        if not CoreReady then cb(nil) return end
        local phoneData = GetPhoneData(source)
        cb(phoneData)
    end)
    
    SLCore.Functions.CreateCallback('sl-phone:server:GetContacts', function(source, cb)
        if not CoreReady then cb({}) return end
        local contacts = GetContacts(source)
        cb(contacts)
    end)
    
    print('^2[SL-Phone] ^7Callbacks registered successfully')
end

-- Wait for core to be ready
CreateThread(function()
    while SLCore == nil do
        if GetResourceState('sl-core') == 'started' then
            SLCore = exports['sl-core']:GetCoreObject()
            if SLCore then
                CoreReady = true
                print('^2[SL-Phone] ^7Successfully connected to SL-Core')
                InitializeDatabase()
                RegisterCallbacks()
                break
            end
        end
        Wait(100)
    end
end)

-- Get Phone Data
local function GetPhoneData(source)
    if not CoreReady then return nil end
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

-- Get Contacts
local function GetContacts(source)
    if not CoreReady then return {} end
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return {} end
    
    local identifier = Player.PlayerData.citizenid
    
    local result = MySQL.Sync.fetchAll('SELECT * FROM phone_contacts WHERE identifier = ?', {identifier})
    
    return result
end

-- Add Contact
local function AddContact(source, name, number)
    if not CoreReady then return false end
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local identifier = Player.PlayerData.citizenid
    local success = MySQL.Sync.execute('INSERT INTO phone_contacts (identifier, name, number) VALUES (?, ?, ?)',
        {identifier, name, number})
    
    return success
end

-- Send Message
local function SendMessage(source, receiver, message, attachments)
    if not CoreReady then return false end
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

-- Events
RegisterNetEvent('sl-phone:server:AddContact', function(data)
    if not CoreReady or not SLCore then return end
    local source = source
    local success = AddContact(source, data.name, data.number)
    if success then
        TriggerClientEvent('sl-phone:client:ContactAdded', source)
    end
end)

RegisterNetEvent('sl-phone:server:SendMessage', function(data)
    if not CoreReady or not SLCore then return end
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
    if not CoreReady or not SLCore then return end
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    local messages = MySQL.query.await('SELECT * FROM phone_messages WHERE sender = ? OR receiver = ?',
        {Player.PlayerData.charinfo.phone, Player.PlayerData.charinfo.phone})
    
    TriggerClientEvent('sl-phone:client:LoadMessages', src, messages)
end)
