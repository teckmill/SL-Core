local SLCore = nil
local CoreReady = false

-- Initialize Database
local function InitializeDatabase()
    MySQL.ready(function()
        MySQL.Sync.execute([[
            CREATE TABLE IF NOT EXISTS `player_houses` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `owner` varchar(60) DEFAULT NULL,
                `identifier` varchar(255) NOT NULL,
                `label` varchar(255) DEFAULT NULL,
                `price` int(11) NOT NULL DEFAULT 0,
                `position` text NOT NULL,
                `owned` tinyint(1) NOT NULL DEFAULT 0,
                `garage` text DEFAULT NULL,
                `furniture` text DEFAULT NULL,
                PRIMARY KEY (`id`),
                UNIQUE KEY `identifier` (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])

        MySQL.Sync.execute([[
            CREATE TABLE IF NOT EXISTS `house_keys` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `house_id` int(11) NOT NULL,
                `identifier` varchar(60) NOT NULL,
                `type` varchar(50) NOT NULL DEFAULT 'guest',
                PRIMARY KEY (`id`),
                KEY `house_id` (`house_id`),
                KEY `identifier` (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])

        print('^2[SL-Housing:Houses] ^7Database tables initialized successfully')
    end)
end

-- Register Server Callbacks
local function RegisterCallbacks()
    if not CoreReady then return end

    SLCore.Functions.CreateCallback('sl-housing:server:GetHouses', function(source, cb)
        local Player = SLCore.Functions.GetPlayer(source)
        if not Player then return cb({}) end
        
        local result = MySQL.Sync.fetchAll('SELECT * FROM player_houses WHERE owner = ?', {
            Player.PlayerData.citizenid
        })
        cb(result)
    end)

    SLCore.Functions.CreateCallback('sl-housing:server:GetHouseKeys', function(source, cb, houseId)
        local result = MySQL.Sync.fetchAll('SELECT * FROM house_keys WHERE house_id = ?', {
            houseId
        })
        cb(result)
    end)

    print('^2[SL-Housing:Houses] ^7Callbacks registered successfully')
end

-- Wait for core to be ready
CreateThread(function()
    while SLCore == nil do
        if GetResourceState('sl-core') == 'started' then
            SLCore = exports['sl-core']:GetCoreObject()
            if SLCore then
                CoreReady = true
                print('^2[SL-Housing:Houses] ^7Successfully connected to SL-Core')
                InitializeDatabase()
                RegisterCallbacks()
                break
            end
        end
        Wait(100)
    end
end)

-- House Management Functions
local Houses = {}

local function LoadHouses()
    if not CoreReady then return end
    local result = MySQL.Sync.fetchAll('SELECT * FROM player_houses')
    for _, house in ipairs(result) do
        Houses[house.house] = {
            owner = house.owner,
            locked = house.locked == 1,
            furniture = json.decode(house.furniture or '[]'),
            keyholders = json.decode(house.keyholders or '[]'),
            decorations = json.decode(house.decorations or '[]'),
            storage = json.decode(house.storage or '{}')
        }
    end
end

-- Events and Callbacks
RegisterNetEvent('sl-housing:server:buyHouse', function(house)
    if not CoreReady then return end
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end

    -- Implementation here
end)

RegisterNetEvent('sl-housing:server:sellHouse', function(house)
    if not CoreReady then return end
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end

    -- Implementation here
end)

-- Exports
exports('GetHouses', function() return Houses end)
exports('GetHouse', function(house) return Houses[house] end)
