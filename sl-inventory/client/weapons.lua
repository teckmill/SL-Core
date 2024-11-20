local SLCore = exports['sl-core']:GetCoreObject()
local CurrentWeaponData = nil

-- Weapon draw animations
local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

-- Get weapon label
local function GetWeaponLabel(name)
    name = string.upper(name)
    if SLCore.Shared.Weapons[name] then
        return SLCore.Shared.Weapons[name]["label"]
    end
    return name
end

-- Equip weapon
RegisterNetEvent('sl-inventory:client:UseWeapon')
AddEventHandler('sl-inventory:client:UseWeapon', function(weaponData)
    local playerPed = PlayerPedId()
    local weaponName = tostring(weaponData.name)
    
    if currentWeapon == weaponName then
        SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
        RemoveAllPedWeapons(playerPed, true)
        TriggerEvent('weapons:client:SetCurrentWeapon', nil, shootbool)
        currentWeapon = nil
        return
    end
    
    if weaponName == "weapon_unarmed" then
        SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
        RemoveAllPedWeapons(playerPed, true)
        TriggerEvent('weapons:client:SetCurrentWeapon', nil, shootbool)
        currentWeapon = nil
        return
    end
    
    TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
    SLCore.Functions.TriggerCallback("weapon:server:GetWeaponAmmo", function(result)
        local ammo = tonumber(result)
        if weaponName == "weapon_petrolcan" or weaponName == "weapon_fireextinguisher" then
            ammo = 4000
        end
        
        GiveWeaponToPed(playerPed, GetHashKey(weaponName), ammo, false, false)
        SetPedAmmo(playerPed, GetHashKey(weaponName), ammo)
        SetCurrentPedWeapon(playerPed, GetHashKey(weaponName), true)
        
        if weaponData.info.attachments then
            for _, attachment in pairs(weaponData.info.attachments) do
                GiveWeaponComponentToPed(playerPed, GetHashKey(weaponName), GetHashKey(attachment.component))
            end
        end
        
        currentWeapon = weaponName
    end, CurrentWeaponData)
end)

-- Remove current weapon
RegisterNetEvent('sl-inventory:client:RemoveCurrentWeapon')
AddEventHandler('sl-inventory:client:RemoveCurrentWeapon', function()
    local ped = PlayerPedId()
    local pedWeapon = GetSelectedPedWeapon(ped)
    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
    RemoveAllPedWeapons(ped, true)
    currentWeapon = nil
end)
