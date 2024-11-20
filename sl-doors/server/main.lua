local SLCore = nil
local DoorStates = {}

-- Initialize SLCore
CreateThread(function()
    while SLCore == nil do
        if GetResourceState('sl-core') == 'started' then
            SLCore = exports['sl-core']:GetCoreObject()
        end
        Wait(100)
    end
    
    InitializeDoors()
end)

-- Initialize doors from database
function InitializeDoors()
    local success, error = pcall(function()
        MySQL.query.await([[
            CREATE TABLE IF NOT EXISTS `sl_doors` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `door_id` varchar(50) NOT NULL,
                `state` tinyint(1) NOT NULL DEFAULT 1,
                `keys` longtext DEFAULT NULL,
                `last_modified` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
                PRIMARY KEY (`id`),
                UNIQUE KEY `door_id` (`door_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])
    end)
    
    if not success then
        print('^1Error initializing sl_doors table: ' .. tostring(error) .. '^0')
        return
    end
    
    -- Load door states from database
    local results = MySQL.query.await('SELECT * FROM sl_doors')
    if results then
        for _, data in ipairs(results) do
            DoorStates[data.door_id] = {
                state = data.state == 1,
                keys = json.decode(data.keys or '[]')
            }
        end
    end
end

-- Event Handlers
RegisterNetEvent('sl-doors:server:RequestDoorStates', function()
    local src = source
    TriggerClientEvent('sl-doors:client:SetDoorStates', src, DoorStates)
end)

RegisterNetEvent('sl-doors:server:UpdateDoorState', function(doorId, state)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local door = Config.Doors[doorId]
    if not door then return end
    
    -- Check access
    local hasAccess = false
    if DoorStates[doorId] and DoorStates[doorId].keys then
        if TableContains(DoorStates[doorId].keys, Player.PlayerData.citizenid) then
            hasAccess = true
        end
    end
    
    if door.group and Config.DoorGroups[door.group] then
        local group = Config.DoorGroups[door.group]
        if group.jobs[Player.PlayerData.job.name] then
            local minGrade = group.jobs[Player.PlayerData.job.name]
            if Player.PlayerData.job.grade.level >= minGrade then
                hasAccess = true
            end
        end
    end
    
    if not hasAccess then
        TriggerClientEvent('sl-core:client:Notify', src, Lang:t('error.no_access'), 'error')
        return
    end
    
    -- Update state
    DoorStates[doorId] = DoorStates[doorId] or {}
    DoorStates[doorId].state = state
    
    -- Save to database
    MySQL.query('INSERT INTO sl_doors (door_id, state) VALUES (?, ?) ON DUPLICATE KEY UPDATE state = ?',
        {doorId, state and 1 or 0, state and 1 or 0})
    
    -- Broadcast update
    TriggerClientEvent('sl-doors:client:UpdateDoorState', -1, doorId, state)
end)

RegisterNetEvent('sl-doors:server:GiveKeys', function(doorId, targetId)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    local Target = SLCore.Functions.GetPlayer(targetId)
    if not Player or not Target then return end
    
    local door = Config.Doors[doorId]
    if not door then return end
    
    -- Check if player has access to give keys
    if not DoorStates[doorId] or not DoorStates[doorId].keys or not TableContains(DoorStates[doorId].keys, Player.PlayerData.citizenid) then
        TriggerClientEvent('sl-core:client:Notify', src, Lang:t('error.no_access'), 'error')
        return
    end
    
    -- Check max keys
    if #DoorStates[doorId].keys >= Config.MaxKeys then
        TriggerClientEvent('sl-core:client:Notify', src, Lang:t('error.max_keys'), 'error')
        return
    end
    
    -- Add keys
    table.insert(DoorStates[doorId].keys, Target.PlayerData.citizenid)
    
    -- Save to database
    MySQL.query('UPDATE sl_doors SET keys = ? WHERE door_id = ?',
        {json.encode(DoorStates[doorId].keys), doorId})
    
    -- Notify players
    TriggerClientEvent('sl-core:client:Notify', src, Lang:t('success.key_given'), 'success')
    TriggerClientEvent('sl-core:client:Notify', targetId, Lang:t('success.received_key'), 'success')
end)

RegisterNetEvent('sl-doors:server:RemoveKeys', function(doorId, targetId)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    local Target = SLCore.Functions.GetPlayer(targetId)
    if not Player or not Target then return end
    
    local door = Config.Doors[doorId]
    if not door then return end
    
    -- Check if player has access to remove keys
    if not DoorStates[doorId] or not DoorStates[doorId].keys or not TableContains(DoorStates[doorId].keys, Player.PlayerData.citizenid) then
        TriggerClientEvent('sl-core:client:Notify', src, Lang:t('error.no_access'), 'error')
        return
    end
    
    -- Remove keys
    for i, citizenid in ipairs(DoorStates[doorId].keys) do
        if citizenid == Target.PlayerData.citizenid then
            table.remove(DoorStates[doorId].keys, i)
            break
        end
    end
    
    -- Save to database
    MySQL.query('UPDATE sl_doors SET keys = ? WHERE door_id = ?',
        {json.encode(DoorStates[doorId].keys), doorId})
    
    -- Notify players
    TriggerClientEvent('sl-core:client:Notify', src, Lang:t('success.key_taken'), 'success')
    TriggerClientEvent('sl-core:client:Notify', targetId, Lang:t('info.lost_key'), 'primary')
end)

RegisterNetEvent('sl-doors:server:RemoveLockpick', function()
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    Player.Functions.RemoveItem('lockpick', 1)
end)

-- Utility Functions
function TableContains(table, element)
    if not table or not element then return false end
    
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

-- Exports
exports('GetDoorState', function(doorId)
    return DoorStates[doorId]
end)

exports('HasKeys', function(doorId, citizenid)
    if not DoorStates[doorId] or not DoorStates[doorId].keys then return false end
    return TableContains(DoorStates[doorId].keys, citizenid)
end)
