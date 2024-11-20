local SLCore = exports['sl-core']:GetCoreObject()
local PlayerData = {}
local isLoggedIn = false
local HUD = {
    visible = true,
    cinematicMode = false
}

-- Initialize HUD
local function InitializeHUD()
    DisplayRadar(true)
    SendNUIMessage({
        type = 'settings',
        data = {
            visible = HUD.visible,
            cinematicMode = HUD.cinematicMode
        }
    })
end

-- Update Status
local function UpdateStatus()
    if not isLoggedIn then return end
    
    local player = PlayerPedId()
    local health = GetEntityHealth(player) - 100
    local armor = GetPedArmour(player)
    local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
    
    SendNUIMessage({
        type = 'status',
        data = {
            health = health,
            armor = armor,
            stamina = stamina,
            hunger = PlayerData.metadata.hunger,
            thirst = PlayerData.metadata.thirst,
            stress = PlayerData.metadata.stress
        }
    })
end

-- Update Vehicle Info
local function UpdateVehicle()
    if not isLoggedIn then return end
    
    local player = PlayerPedId()
    if IsPedInAnyVehicle(player, false) then
        local vehicle = GetVehiclePedIsIn(player, false)
        local speed = GetEntitySpeed(vehicle) * 2.236936 -- Convert to MPH
        local fuel = exports['LegacyFuel']:GetFuel(vehicle)
        local vehicleHealth = GetVehicleEngineHealth(vehicle)
        
        SendNUIMessage({
            type = 'vehicle',
            data = {
                isInVehicle = true,
                speed = speed,
                fuel = fuel,
                health = vehicleHealth
            }
        })
    else
        SendNUIMessage({
            type = 'vehicle',
            data = {
                isInVehicle = false
            }
        })
    end
end

-- Update Voice Status
local function UpdateVoice()
    if not isLoggedIn then return end
    
    local voiceData = exports['pma-voice']:getVoiceData()
    SendNUIMessage({
        type = 'voice',
        data = {
            range = voiceData.mode,
            isTalking = voiceData.talking
        }
    })
end

-- Update Money Display
local function UpdateMoney()
    if not isLoggedIn then return end
    
    SendNUIMessage({
        type = 'money',
        data = {
            cash = PlayerData.money.cash,
            bank = PlayerData.money.bank,
            oldCash = PlayerData.money.oldcash,
            oldBank = PlayerData.money.oldbank
        }
    })
end

-- Update Job Info
local function UpdateJob()
    if not isLoggedIn then return end
    
    SendNUIMessage({
        type = 'job',
        data = {
            name = PlayerData.job.label,
            grade = PlayerData.job.grade.name,
            onDuty = PlayerData.job.onduty
        }
    })
end

-- Update Gang Info
local function UpdateGang()
    if not isLoggedIn then return end
    
    SendNUIMessage({
        type = 'gang',
        data = {
            name = PlayerData.gang.label,
            rank = PlayerData.gang.grade.name
        }
    })
end

-- Update Weapon Info
local function UpdateWeapon()
    if not isLoggedIn then return end
    
    local player = PlayerPedId()
    local weapon = GetSelectedPedWeapon(player)
    local weaponData = SLCore.Shared.Weapons[weapon]
    
    if weaponData then
        local ammoCount = GetAmmoInPedWeapon(player, weapon)
        SendNUIMessage({
            type = 'weapon',
            data = {
                name = weaponData.label,
                ammo = ammoCount,
                maxAmmo = weaponData.maxammo
            }
        })
    else
        SendNUIMessage({
            type = 'weapon',
            data = {
                name = 'Unarmed',
                ammo = 0,
                maxAmmo = 0
            }
        })
    end
end

-- Update Street Name
local function UpdateStreet()
    if not isLoggedIn then return end
    
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
    local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
    
    SendNUIMessage({
        type = 'street',
        data = {
            street = street,
            zone = zone
        }
    })
end

-- Update Compass
local function UpdateCompass()
    if not isLoggedIn then return end
    
    local player = PlayerPedId()
    local heading = GetEntityHeading(player)
    
    SendNUIMessage({
        type = 'compass',
        data = {
            heading = heading
        }
    })
end

-- Toggle Cinematic Mode
local function ToggleCinematicMode()
    HUD.cinematicMode = not HUD.cinematicMode
    DisplayRadar(not HUD.cinematicMode)
    
    SendNUIMessage({
        type = 'cinematic',
        enabled = HUD.cinematicMode
    })
end

-- Event Handlers
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    PlayerData = SLCore.Functions.GetPlayerData()
    isLoggedIn = true
    InitializeHUD()
end)

RegisterNetEvent('SLCore:Client:OnPlayerUnload', function()
    PlayerData = {}
    isLoggedIn = false
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
        type = 'settings',
        data = {
            visible = HUD.visible
        }
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
        type = 'settings',
        data = {
            visible = HUD.visible
        }
    })
end)

exports('ToggleCinematicMode', function(enabled)
    HUD.cinematicMode = enabled
    DisplayRadar(not HUD.cinematicMode)
    SendNUIMessage({
        type = 'cinematic',
        enabled = HUD.cinematicMode
    })
end)
