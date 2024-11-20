local SLCore = exports['sl-core']:GetCoreObject()

-- Register radio item in shared items
SLCore.Functions.CreateUseableItem('radio', function(source)
    TriggerClientEvent('sl-radio:client:UseRadio', source)
end)

-- Callback to check if player has radio
SLCore.Functions.CreateCallback('sl-radio:server:GetItem', function(source, cb, item)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    local RadioItem = Player.Functions.GetItemByName(item)
    cb(RadioItem ~= nil)
end)

-- Event to give radio to player
RegisterNetEvent('sl-radio:server:GiveRadio', function()
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    Player.Functions.AddItem('radio', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, SLCore.Shared.Items['radio'], 'add')
end)

-- Event to remove radio from player
RegisterNetEvent('sl-radio:server:RemoveRadio', function()
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    Player.Functions.RemoveItem('radio', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, SLCore.Shared.Items['radio'], 'remove')
end)

-- Event to join radio channel
RegisterNetEvent('sl-radio:server:JoinRadio', function(channel)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Check if player has radio item
    local RadioItem = Player.Functions.GetItemByName('radio')
    if not RadioItem then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.no_radio'), 'error')
        return
    end
    
    -- Check if channel is restricted
    if Config.RestrictedChannels[channel] then
        if not Config.RestrictedChannels[channel][Player.PlayerData.job.name] then
            TriggerClientEvent('SLCore:Notify', src, Lang:t('error.restricted_channel'), 'error')
            return
        end
    end
    
    -- Join radio channel
    exports['pma-voice']:setPlayerRadio(src, channel)
    TriggerClientEvent('sl-radio:client:JoinRadio', src, channel)
end)

-- Event to leave radio channel
RegisterNetEvent('sl-radio:server:LeaveRadio', function()
    local src = source
    exports['pma-voice']:setPlayerRadio(src, 0)
    TriggerClientEvent('sl-radio:client:LeaveRadio', src)
end)

-- Cleanup on player drop
AddEventHandler('playerDropped', function()
    local src = source
    exports['pma-voice']:setPlayerRadio(src, 0)
end)
