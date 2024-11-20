local SLCore = exports['sl-core']:GetCoreObject()

-- Get weapon ammo
SLCore.Functions.CreateCallback('weapon:server:GetWeaponAmmo', function(source, cb, CurrentWeaponData)
    if not CurrentWeaponData then return cb(0) end
    
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return cb(0) end
    
    local weaponName = CurrentWeaponData.name
    if not weaponName then return cb(0) end
    
    -- Get weapon from player inventory
    local weaponItem = Player.Functions.GetItemByName(weaponName)
    if not weaponItem then return cb(0) end
    
    local ammo = 0
    if weaponItem.info and weaponItem.info.ammo then
        ammo = weaponItem.info.ammo
    end
    
    cb(ammo)
end)

-- Add weapon component
RegisterNetEvent('weapons:server:AddWeaponComponent')
AddEventHandler('weapons:server:AddWeaponComponent', function(component)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local weapon = Player.Functions.GetItemBySlot(Player.PlayerData.items[component.slot])
    if not weapon then return end
    
    local components = {}
    if weapon.info and weapon.info.attachments then
        components = weapon.info.attachments
    end
    
    local hasComponent = false
    for _, comp in pairs(components) do
        if comp.component == component.component then
            hasComponent = true
        end
    end
    
    if not hasComponent then
        table.insert(components, {
            component = component.component,
            label = component.label
        })
        
        Player.Functions.SetInventory(Player.PlayerData.items)
        TriggerClientEvent('inventory:client:ItemBox', src, component, "add")
    end
end)

-- Remove weapon component
RegisterNetEvent('weapons:server:RemoveWeaponComponent')
AddEventHandler('weapons:server:RemoveWeaponComponent', function(component, weaponSlot)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local weapon = Player.Functions.GetItemBySlot(weaponSlot)
    if not weapon then return end
    
    if weapon.info and weapon.info.attachments then
        local components = weapon.info.attachments
        for k, v in pairs(components) do
            if v.component == component.component then
                table.remove(components, k)
                Player.Functions.SetInventory(Player.PlayerData.items)
                TriggerClientEvent('inventory:client:ItemBox', src, component, "remove")
                break
            end
        end
    end
end)

-- Update weapon ammo
RegisterNetEvent('weapons:server:UpdateWeaponAmmo')
AddEventHandler('weapons:server:UpdateWeaponAmmo', function(weaponName, amount)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local weapon = Player.Functions.GetItemByName(weaponName)
    if not weapon then return end
    
    if not weapon.info then weapon.info = {} end
    weapon.info.ammo = amount
    
    Player.Functions.SetInventory(Player.PlayerData.items)
end)

-- Save weapon data
RegisterNetEvent('weapons:server:SaveWeaponData')
AddEventHandler('weapons:server:SaveWeaponData', function(weaponName, data)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local weapon = Player.Functions.GetItemByName(weaponName)
    if not weapon then return end
    
    if not weapon.info then weapon.info = {} end
    weapon.info.quality = data.quality or 100
    weapon.info.serie = data.serie or ''
    weapon.info.attachments = data.attachments or {}
    
    Player.Functions.SetInventory(Player.PlayerData.items)
end)
