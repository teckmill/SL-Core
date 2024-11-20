local SLCore = exports['sl-core']:GetCoreObject()
local PlayerData = {}
local isLoggedIn = false
local HUD = {
    visible = false,
    cinematicMode = false
}

-- Initialize HUD
local function InitializeHUD()
    DisplayRadar(false)
    SendNUIMessage({
        action = 'toggleHud',
        show = false
    })
end

-- Show HUD after player is fully loaded
local function ShowHUD()
    if not isLoggedIn then return end
    
    HUD.visible = true
    DisplayRadar(true)
    SendNUIMessage({
        action = 'toggleHud',
        show = true
    })
end

-- Update Status
local function UpdateStatus()
    if not isLoggedIn or not HUD.visible then return end
    
    local player = PlayerPedId()
    local health = GetEntityHealth(player) - 100
    local armor = GetPedArmour(player)
    local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
    
    SendNUIMessage({
        action = 'updateStatus',
        status = 'health',
        value = health
    })
    SendNUIMessage({
        action = 'updateStatus',
        status = 'armor',
        value = armor
    })
    SendNUIMessage({
        action = 'updateStatus',
        status = 'stamina',
        value = stamina
    })
    SendNUIMessage({
        action = 'updateStatus',
        status = 'hunger',
        value = PlayerData.metadata.hunger
    })
    SendNUIMessage({
        action = 'updateStatus',
        status = 'thirst',
        value = PlayerData.metadata.thirst
    })
    SendNUIMessage({
        action = 'updateStatus',
        status = 'stress',
        value = PlayerData.metadata.stress
    })
end

-- Update Vehicle Info
local function UpdateVehicle()
    if not isLoggedIn or not HUD.visible then return end
    
    local player = PlayerPedId()
    if IsPedInAnyVehicle(player, false) then
        local vehicle = GetVehiclePedIsIn(player, false)
        local speed = GetEntitySpeed(vehicle) * 2.236936 -- Convert to MPH
        local fuel = exports['LegacyFuel']:GetFuel(vehicle)
        local engineHealth = GetVehicleEngineHealth(vehicle)
        
        SendNUIMessage({
            action = 'updateVehicle',
            show = true,
            speed = speed,
            fuel = fuel,
            engineHealth = engineHealth
        })
    else
        SendNUIMessage({
            action = 'updateVehicle',
            show = false
        })
    end
end

-- Update Voice Status
local function UpdateVoice()
    if not isLoggedIn or not HUD.visible then return end
    
    local voiceData = exports['pma-voice']:getVoiceData()
    SendNUIMessage({
        action = 'updateVoice',
        range = voiceData.mode,
        isTalking = voiceData.talking
    })
end

-- Update Money Display
local function UpdateMoney()
    if not isLoggedIn or not HUD.visible then return end
    
    SendNUIMessage({
        action = 'updateMoney',
        cash = PlayerData.money.cash,
        bank = PlayerData.money.bank,
        oldCash = PlayerData.money.oldcash,
        oldBank = PlayerData.money.oldbank
    })
end

-- Update Job Info
local function UpdateJob()
    if not isLoggedIn or not HUD.visible then return end
    
    SendNUIMessage({
        action = 'updateJob',
        name = PlayerData.job.label,
        grade = PlayerData.job.grade.name,
        onDuty = PlayerData.job.onduty
    })
end

-- Update Gang Info
local function UpdateGang()
    if not isLoggedIn or not HUD.visible then return end
    
    SendNUIMessage({
        action = 'updateGang',
        name = PlayerData.gang.label,
        rank = PlayerData.gang.grade.name
    })
end

-- Update Weapon Info
local function UpdateWeapon()
    if not isLoggedIn or not HUD.visible then return end
    
    local player = PlayerPedId()
    local weapon = GetSelectedPedWeapon(player)
    local weaponData = SLCore.Shared.Weapons[weapon]
    
    if weaponData then
        local ammoCount = GetAmmoInPedWeapon(player, weapon)
        SendNUIMessage({
            action = 'updateWeapon',
            name = weaponData.label,
            ammo = ammoCount,
            maxAmmo = weaponData.maxammo
        })
    else
        SendNUIMessage({
            action = 'updateWeapon',
            name = 'Unarmed',
            ammo = 0,
            maxAmmo = 0
        })
    end
end

-- Update Street Name
local function UpdateStreet()
    if not isLoggedIn or not HUD.visible then return end
    
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
    local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
    
    SendNUIMessage({
        action = 'updateStreet',
        street = street,
        zone = zone
    })
end

-- Update Compass
local function UpdateCompass()
    if not isLoggedIn or not HUD.visible then return end
    
    local player = PlayerPedId()
    local heading = GetEntityHeading(player)
    
    SendNUIMessage({
        action = 'updateCompass',
        heading = heading
    })
end

-- Toggle Cinematic Mode
local function ToggleCinematicMode()
    HUD.cinematicMode = not HUD.cinematicMode
    DisplayRadar(not HUD.cinematicMode)
    
    SendNUIMessage({
        action = 'toggleCinematic',
        enabled = HUD.cinematicMode
    })
end

-- Event Handlers
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    PlayerData = SLCore.Functions.GetPlayerData()
    isLoggedIn = true
    InitializeHUD()
    Wait(2000)
    ShowHUD()
end)

RegisterNetEvent('SLCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    PlayerData = {}
    SendNUIMessage({
        action = 'toggleHud',
        show = false
    })
    DisplayRadar(false)
end)

RegisterNetEvent('SLCore:Player:SetPlayerData', function(data)
    PlayerData = data
    UpdateMoney()
    UpdateJob()
    UpdateGang()
end)

RegisterNetEvent('hud:client:UpdateNeeds', function(needs)
    PlayerData.metadata.hunger = needs.hunger
    PlayerData.metadata.thirst = needs.thirst
    UpdateStatus()
end)

RegisterNetEvent('hud:client:UpdateStress', function(stress)
    PlayerData.metadata.stress = stress
    UpdateStatus()
end)

-- Commands
RegisterCommand('cinematicmode', function()
    ToggleCinematicMode()
end)

RegisterCommand('togglehud', function()
    HUD.visible = not HUD.visible
    SendNUIMessage({
        action = 'toggleHud',
        show = HUD.visible
    })
end)

-- Threads
CreateThread(function()
    while true do
        if isLoggedIn then
            UpdateStatus()
            UpdateVehicle()
            UpdateVoice()
            UpdateWeapon()
            UpdateStreet()
            UpdateCompass()
        end
        Wait(200)
    end
end)

-- Exports
exports('ToggleHUD', function(visible)
    HUD.visible = visible
    SendNUIMessage({
        action = 'toggleHud',
        show = HUD.visible
    })
end)

exports('ToggleCinematicMode', function(enabled)
    HUD.cinematicMode = enabled
    DisplayRadar(not HUD.cinematicMode)
    SendNUIMessage({
        action = 'toggleCinematic',
        enabled = HUD.cinematicMode
    })
end)

-- Initialize on resource start
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    Wait(1000)
    InitializeHUD()
end)
