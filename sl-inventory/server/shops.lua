local SLCore = exports['sl-core']:GetCoreObject()

-- Helper Functions
local function HasLicense(source, license)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    -- Check if player has required license
    -- This should be implemented based on your licensing system
    return Player.PlayerData.metadata.licenses and Player.PlayerData.metadata.licenses[license]
end

local function CanAffordItem(source, price, currency)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    if currency == 'money' then
        return Player.PlayerData.money['cash'] >= price
    elseif currency == 'bank' then
        return Player.PlayerData.money['bank'] >= price
    elseif currency == 'crypto' then
        return Player.PlayerData.money['crypto'] >= price
    else
        -- Check if player has required item as currency
        local item = Player.Functions.GetItemByName(currency)
        return item and item.amount >= price
    end
end

local function RemovePayment(source, price, currency)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    if currency == 'money' then
        Player.Functions.RemoveMoney('cash', price)
    elseif currency == 'bank' then
        Player.Functions.RemoveMoney('bank', price)
    elseif currency == 'crypto' then
        Player.Functions.RemoveMoney('crypto', price)
    else
        -- Remove item used as currency
        Player.Functions.RemoveItem(currency, price)
    end
    
    return true
end

-- Event Handlers
RegisterNetEvent('sl-inventory:server:OpenShop', function(shopType)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local shop = Config.Shops[shopType]
    if not shop then
        TriggerClientEvent('sl-inventory:client:SendMessage', src, Lang:t('error.invalid_shop'))
        return
    end
    
    -- Check if player is near a shop location
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    local isNearShop = false
    
    for _, coords in ipairs(shop.coords) do
        if #(playerCoords - coords) < 3.0 then
            isNearShop = true
            break
        end
    end
    
    if not isNearShop then
        TriggerClientEvent('sl-inventory:client:SendMessage', src, Lang:t('error.too_far'))
        return
    end
    
    -- Open shop inventory
    TriggerClientEvent('sl-inventory:client:OpenInventory', src, 'shop', {
        shopType = shopType,
        items = shop.items
    })
end)

RegisterNetEvent('sl-inventory:server:BuyItem', function(shopType, item, amount)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Validate shop and item
    local shop = Config.Shops[shopType]
    if not shop then
        TriggerClientEvent('sl-inventory:client:SendMessage', src, Lang:t('error.invalid_shop'))
        return
    end
    
    local itemData = shop.items[item]
    if not itemData then
        TriggerClientEvent('sl-inventory:client:SendMessage', src, Lang:t('error.item_not_available'))
        return
    end
    
    -- Check license if required
    if itemData.license and not HasLicense(src, itemData.license) then
        TriggerClientEvent('sl-inventory:client:SendMessage', src, Lang:t('error.license_required'))
        return
    end
    
    -- Calculate total price
    local totalPrice = itemData.price * amount
    
    -- Check if player can afford item
    if not CanAffordItem(src, totalPrice, itemData.currency) then
        TriggerClientEvent('sl-inventory:client:SendMessage', src, Lang:t('error.cant_afford'))
        return
    end
    
    -- Check if player can carry item
    if not exports['sl-inventory']:CanCarryItem(src, item, amount) then
        TriggerClientEvent('sl-inventory:client:SendMessage', src, Lang:t('error.cant_carry'))
        return
    end
    
    -- Remove payment
    if not RemovePayment(src, totalPrice, itemData.currency) then
        TriggerClientEvent('sl-inventory:client:SendMessage', src, Lang:t('error.payment_failed'))
        return
    end
    
    -- Add item to player inventory
    local success = exports['sl-inventory']:AddItem(src, item, amount)
    if success then
        TriggerClientEvent('sl-inventory:client:SendMessage', src, Lang:t('success.item_purchased'))
        
        -- Log transaction
        TriggerEvent('sl-log:server:CreateLog', 'shopping', 'Item Purchase', 'green', string.format('%s purchased %dx %s for %d %s', 
            GetPlayerName(src), amount, item, totalPrice, itemData.currency))
    else
        -- Refund payment if adding item failed
        if itemData.currency == 'money' then
            Player.Functions.AddMoney('cash', totalPrice)
        elseif itemData.currency == 'bank' then
            Player.Functions.AddMoney('bank', totalPrice)
        elseif itemData.currency == 'crypto' then
            Player.Functions.AddMoney('crypto', totalPrice)
        else
            Player.Functions.AddItem(itemData.currency, totalPrice)
        end
        
        TriggerClientEvent('sl-inventory:client:SendMessage', src, Lang:t('error.purchase_failed'))
    end
end)

-- Exports
exports('GetShopItems', function(shopType)
    return Config.Shops[shopType] and Config.Shops[shopType].items or {}
end)

exports('IsShopOpen', function(source)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    -- Check if player is near any shop
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    
    for shopType, shop in pairs(Config.Shops) do
        for _, coords in ipairs(shop.coords) do
            if #(playerCoords - coords) < 3.0 then
                return true
            end
        end
    end
    
    return false
end)

exports('GetNearestShop', function(source)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return nil end
    
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local nearestShop = nil
    local nearestDistance = 999999.9
    
    for shopType, shop in pairs(Config.Shops) do
        for _, coords in ipairs(shop.coords) do
            local distance = #(playerCoords - coords)
            if distance < nearestDistance then
                nearestDistance = distance
                nearestShop = shopType
            end
        end
    end
    
    return nearestShop
end)
