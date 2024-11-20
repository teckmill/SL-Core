local SLCore = exports['sl-core']:GetCoreObject()

-- Core Ready Check
local CoreReady = false
AddEventHandler('SLCore:Server:OnCoreReady', function()
    CoreReady = true
end)

-- Database Functions
function GetPlayerApartments(citizenid)
    local result = MySQL.Sync.fetchAll('SELECT * FROM player_apartments WHERE citizenid = ?', {citizenid})
    return result
end

function AddPlayerApartment(citizenid, apartment, interior)
    MySQL.Async.insert('INSERT INTO player_apartments (citizenid, apartment, interior) VALUES (?, ?, ?)',
        {citizenid, apartment, interior})
end

function RemovePlayerApartment(citizenid, apartment)
    MySQL.Async.execute('DELETE FROM player_apartments WHERE citizenid = ? AND apartment = ?',
        {citizenid, apartment})
end

-- Apartment Management
RegisterNetEvent('sl-apartments:server:BuyApartment', function(apartment, interior)
    if not CoreReady then return end
    
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local apartmentData = Config.Locations[apartment]
    if not apartmentData then return end
    
    local interiorData = apartmentData.interiors[interior]
    if not interiorData then return end
    
    -- Check if player can afford apartment
    if Player.PlayerData.money.bank < interiorData.price then
        TriggerClientEvent('SLCore:Notify', src, 'Not enough money', 'error')
        return
    end
    
    -- Check if player already owns this apartment
    local owned = GetPlayerApartments(Player.PlayerData.citizenid)
    for _, v in pairs(owned) do
        if v.apartment == apartment then
            TriggerClientEvent('SLCore:Notify', src, 'You already own this apartment', 'error')
            return
        end
    end
    
    -- Buy apartment
    Player.Functions.RemoveMoney('bank', interiorData.price, "apartment-bought")
    AddPlayerApartment(Player.PlayerData.citizenid, apartment, interior)
    
    TriggerClientEvent('SLCore:Notify', src, 'Apartment purchased for $' .. interiorData.price, 'success')
    TriggerClientEvent('sl-apartments:client:SetOwned', src, apartment, interior)
end)

RegisterNetEvent('sl-apartments:server:SellApartment', function(apartment)
    if not CoreReady then return end
    
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local apartmentData = Config.Locations[apartment]
    if not apartmentData then return end
    
    -- Check if player owns this apartment
    local owned = GetPlayerApartments(Player.PlayerData.citizenid)
    local hasApartment = false
    local interior = nil
    
    for _, v in pairs(owned) do
        if v.apartment == apartment then
            hasApartment = true
            interior = v.interior
            break
        end
    end
    
    if not hasApartment then
        TriggerClientEvent('SLCore:Notify', src, 'You don\'t own this apartment', 'error')
        return
    end
    
    -- Calculate refund (50% of original price)
    local interiorData = apartmentData.interiors[interior]
    local refund = math.floor(interiorData.price * 0.5)
    
    -- Sell apartment
    Player.Functions.AddMoney('bank', refund, "apartment-sold")
    RemovePlayerApartment(Player.PlayerData.citizenid, apartment)
    
    TriggerClientEvent('SLCore:Notify', src, 'Apartment sold for $' .. refund, 'success')
    TriggerClientEvent('sl-apartments:client:RemoveOwned', src, apartment)
end)

RegisterNetEvent('sl-apartments:server:EnterApartment', function(apartment)
    if not CoreReady then return end
    
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Check if player owns this apartment
    local owned = GetPlayerApartments(Player.PlayerData.citizenid)
    local hasApartment = false
    local interior = nil
    
    for _, v in pairs(owned) do
        if v.apartment == apartment then
            hasApartment = true
            interior = v.interior
            break
        end
    end
    
    if not hasApartment then
        TriggerClientEvent('SLCore:Notify', src, 'You don\'t own this apartment', 'error')
        return
    end
    
    TriggerClientEvent('sl-apartments:client:EnterApartment', src, apartment, interior)
end)

-- Callbacks
SLCore.Functions.CreateCallback('sl-apartments:server:GetOwnedApartments', function(source, cb)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end
    
    local owned = GetPlayerApartments(Player.PlayerData.citizenid)
    cb(owned)
end)

-- Initialize
CreateThread(function()
    Wait(1000)
    -- Create database table if it doesn't exist
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS player_apartments (
            id INT AUTO_INCREMENT PRIMARY KEY,
            citizenid VARCHAR(50),
            apartment VARCHAR(50),
            interior VARCHAR(50),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            UNIQUE KEY unique_apartment (citizenid, apartment)
        )
    ]])
end)
