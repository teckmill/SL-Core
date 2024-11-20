local SLCore = exports['sl-core']:GetCoreObject()

-- Weapon Variables
local isEnabled = true
local currentWeapon = nil
local weaponAmmo = 0
local weaponType = nil

-- Weapon Types
local weaponTypes = {
    [-1609580060] = "Unarmed",
    [970310034] = "Melee",
    [-1569615261] = "Melee",
    [1548507267] = "Throwable",
    [4257178988] = "Pistol",
    [1159398588] = "SMG",
    [3082541095] = "Shotgun",
    [2725924767] = "Assault Rifle",
    [3337201093] = "Sniper",
    [2578778090] = "Heavy Weapon"
}

-- Update Weapon Display
local function UpdateWeaponHUD()
    if not isEnabled then return end
    
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    
    -- Only update if weapon changed
    if weapon ~= currentWeapon then
        currentWeapon = weapon
        weaponType = weaponTypes[GetWeapontypeGroup(weapon)]
        
        if weaponType then
            local ammo = GetAmmoInPedWeapon(ped, weapon)
            weaponAmmo = ammo
            
            SendNUIMessage({
                action = "updateWeapon",
                weapon = weaponType,
                ammo = ammo,
                show = true
            })
        else
            SendNUIMessage({
                action = "updateWeapon",
                show = false
            })
        end
    else
        -- Update ammo count
        local ammo = GetAmmoInPedWeapon(ped, weapon)
        if ammo ~= weaponAmmo then
            weaponAmmo = ammo
            SendNUIMessage({
                action = "updateAmmo",
                ammo = ammo
            })
        end
    end
end

-- Toggle Weapon Display
RegisterCommand('toggleweapon', function()
    isEnabled = not isEnabled
    SendNUIMessage({
        action = "updateWeapon",
        show = isEnabled
    })
end)

-- Weapon Update Loop
CreateThread(function()
    while true do
        Wait(200)
        UpdateWeaponHUD()
    end
end)

-- Weapon Wheel Events
AddEventHandler('weaponWheel:update', function(data)
    if not isEnabled then return end
    
    SendNUIMessage({
        action = "updateWeaponWheel",
        weapons = data.weapons,
        selected = data.selected,
        show = true
    })
end)

-- Reloading Animation
RegisterNetEvent('sl-hud:client:OnReload')
AddEventHandler('sl-hud:client:OnReload', function()
    if not isEnabled then return end
    
    SendNUIMessage({
        action = "showReload",
        show = true
    })
    
    Wait(1000)
    
    SendNUIMessage({
        action = "showReload",
        show = false
    })
end)
