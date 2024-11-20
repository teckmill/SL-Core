local SLCore = exports['sl-core']:GetCoreObject()
local currentWeapon = nil
local shooting = false

-- Initialize weapon durability system
CreateThread(function()
    while true do
        if currentWeapon and shooting then
            local decrease = Config.DurabilityDecrease[currentWeapon] or 0.1
            TriggerServerEvent('sl-weapons:server:UpdateDurability', currentWeapon, decrease)
        end
        Wait(1000)
    end
end)

-- Handle shooting state
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        shooting = IsPedShooting(ped)
        Wait(0)
    end
end)

-- Update current weapon
RegisterNetEvent('weapons:client:SetCurrentWeapon')
AddEventHandler('weapons:client:SetCurrentWeapon', function(weapon)
    currentWeapon = weapon and weapon.name or nil
end)

-- Add weapon attachment
RegisterNetEvent('weapons:client:AddAttachment')
AddEventHandler('weapons:client:AddAttachment', function(component)
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    local weaponName = SLCore.Shared.Weapons[weapon]
    
    if not weaponName then return end
    
    if Config.WeaponAttachments[weaponName] and table.contains(Config.WeaponAttachments[weaponName], component) then
        GiveWeaponComponentToPed(ped, weapon, GetHashKey(component))
    else
        TriggerEvent('SLCore:Notify', Lang:t('error.attachment_incompatible'), 'error')
    end
end)

-- Remove weapon attachment
RegisterNetEvent('weapons:client:RemoveAttachment')
AddEventHandler('weapons:client:RemoveAttachment', function(component)
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    
    if HasPedGotWeaponComponent(ped, weapon, GetHashKey(component)) then
        RemoveWeaponComponentFromPed(ped, weapon, GetHashKey(component))
    else
        TriggerEvent('SLCore:Notify', Lang:t('error.no_attachment'), 'error')
    end
end)

-- Repair weapon
RegisterNetEvent('weapons:client:RepairWeapon')
AddEventHandler('weapons:client:RepairWeapon', function()
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    local weaponName = SLCore.Shared.Weapons[weapon]
    
    if not weaponName then
        TriggerEvent('SLCore:Notify', Lang:t('error.no_weapon'), 'error')
        return
    end
    
    if not Config.WeaponRepairCosts[weaponName] then
        TriggerEvent('SLCore:Notify', Lang:t('error.cant_repair'), 'error')
        return
    end
    
    SLCore.Functions.Progressbar('repairing_weapon', Lang:t('info.repairing_weapon'), 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
        anim = 'machinic_loop_mechandplayer',
        flags = 49,
    }, {}, {}, function() -- Done
        TriggerServerEvent('sl-weapons:server:RepairWeapon', weaponName)
    end, function() -- Cancel
        TriggerEvent('SLCore:Notify', Lang:t('error.repair_failed'), 'error')
    end)
end)

-- Helper function to check if table contains value
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end
