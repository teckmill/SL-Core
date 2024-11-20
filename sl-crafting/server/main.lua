local SLCore = exports['sl-core']:GetCoreObject()

-- Database initialization
CreateThread(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS player_crafting (
            citizenid VARCHAR(50) NOT NULL,
            station VARCHAR(50) NOT NULL,
            experience INT DEFAULT 0,
            PRIMARY KEY (citizenid, station)
        )
    ]])
end)

-- Core Functions
function GetPlayerCraftingLevel(citizenid, station)
    local result = MySQL.scalar.await('SELECT experience FROM player_crafting WHERE citizenid = ? AND station = ?', {
        citizenid,
        station
    })
    
    return result or 0
end

function UpdatePlayerExperience(citizenid, station, amount)
    MySQL.insert('INSERT INTO player_crafting (citizenid, station, experience) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE experience = experience + ?', {
        citizenid,
        station,
        amount,
        amount
    })
end

function GetCraftingLevel(experience)
    local level = 0
    for exp, data in pairs(Config.Experience.levels) do
        if experience >= exp then
            level = exp
        else
            break
        end
    end
    return level
end

function CanCraftItem(source, station, item)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end

    local recipe = Config.Recipes[station][item]
    if not recipe then return false end

    -- Check job requirement
    local location = Config.CraftingLocations[station]
    if location.job and Player.PlayerData.job.name ~= location.job then
        TriggerClientEvent('SLCore:Notify', source, Lang:t('error.wrong_job'), 'error')
        return false
    end

    -- Check required tools
    local requiredTools = Config.RequiredItems[station]
    if requiredTools then
        for item, amount in pairs(requiredTools) do
            local hasItem = Player.Functions.GetItemByName(item)
            if not hasItem or hasItem.amount < amount then
                TriggerClientEvent('SLCore:Notify', source, Lang:t('error.missing_required_tools'), 'error')
                return false
            end
        end
    end

    -- Check ingredients
    for item, amount in pairs(recipe.ingredients) do
        local hasItem = Player.Functions.GetItemByName(item)
        if not hasItem or hasItem.amount < amount then
            TriggerClientEvent('SLCore:Notify', source, Lang:t('error.not_enough_ingredients'), 'error')
            return false
        end
    end

    -- Check skill level if enabled
    if Config.Experience.enabled then
        local experience = GetPlayerCraftingLevel(Player.PlayerData.citizenid, station)
        local level = GetCraftingLevel(experience)
        local levelData = Config.Experience.levels[level]
        
        if math.random() < levelData.failChance then
            TriggerClientEvent('SLCore:Notify', source, Lang:t('error.crafting_failed'), 'error')
            return false
        end
    end

    return true
end

-- Events
RegisterNetEvent('sl-crafting:server:craftItem', function(station, item)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end

    if not CanCraftItem(src, station, item) then return end

    local recipe = Config.Recipes[station][item]
    
    -- Remove ingredients
    for ingredient, amount in pairs(recipe.ingredients) do
        Player.Functions.RemoveItem(ingredient, amount)
        TriggerClientEvent('inventory:client:ItemBox', src, SLCore.Shared.Items[ingredient], "remove")
    end

    -- Add crafted item
    Player.Functions.AddItem(item, 1)
    TriggerClientEvent('inventory:client:ItemBox', src, SLCore.Shared.Items[item], "add")
    TriggerClientEvent('SLCore:Notify', src, Lang:t('success.item_crafted', {item = recipe.label}), 'success')

    -- Update experience if enabled
    if Config.Experience.enabled then
        local citizenid = Player.PlayerData.citizenid
        UpdatePlayerExperience(citizenid, station, Config.Experience.gainPerCraft)
        
        local newExperience = GetPlayerCraftingLevel(citizenid, station) + Config.Experience.gainPerCraft
        local newLevel = GetCraftingLevel(newExperience)
        local oldLevel = GetCraftingLevel(newExperience - Config.Experience.gainPerCraft)
        
        if newLevel > oldLevel then
            TriggerClientEvent('SLCore:Notify', src, Lang:t('success.skill_increased', {level = Config.Experience.levels[newLevel].label}), 'success')
        end
    end
end)

-- Callbacks
SLCore.Functions.CreateCallback('sl-crafting:server:getPlayerExperience', function(source, cb, station)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb(0) end

    local experience = GetPlayerCraftingLevel(Player.PlayerData.citizenid, station)
    cb(experience)
end)
