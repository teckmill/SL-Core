local SLCore = exports['sl-core']:GetCoreObject()
local PlayerData = {}
local CraftingBlips = {}
local CurrentStation = nil

-- Initialize
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    PlayerData = SLCore.Functions.GetPlayerData()
    CreateCraftingBlips()
end)

RegisterNetEvent('SLCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

-- Core Functions
function CreateCraftingBlips()
    for k, v in pairs(Config.CraftingLocations) do
        if v.blip then
            local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
            SetBlipSprite(blip, v.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, v.blip.scale)
            SetBlipColour(blip, v.blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.label)
            EndTextCommandSetBlipName(blip)
            CraftingBlips[k] = blip
        end
    end
end

function RemoveCraftingBlips()
    for _, blip in pairs(CraftingBlips) do
        RemoveBlip(blip)
    end
    CraftingBlips = {}
end

function SetupCraftingZones()
    for k, v in pairs(Config.CraftingLocations) do
        exports['sl-target']:AddBoxZone(
            "crafting_" .. k,
            v.coords,
            2.0, 2.0,
            {
                name = "crafting_" .. k,
                heading = 0,
                debugPoly = false,
                minZ = v.coords.z - 1,
                maxZ = v.coords.z + 2,
            },
            {
                options = {
                    {
                        type = "client",
                        event = "sl-crafting:client:openMenu",
                        icon = "fas fa-hammer",
                        label = Lang:t('info.crafting_menu'),
                        station = k,
                        canInteract = function()
                            return CanAccessStation(k)
                        end,
                    }
                },
                distance = v.radius or 3.0
            }
        )
    end
end

function CanAccessStation(station)
    local location = Config.CraftingLocations[station]
    if not location then return false end
    
    if location.job and (not PlayerData.job or PlayerData.job.name ~= location.job) then
        return false
    end
    
    return true
end

function HasRequiredItems(station, recipe)
    local requiredTools = Config.RequiredItems[station]
    if requiredTools then
        for item, amount in pairs(requiredTools) do
            local hasItem = SLCore.Functions.HasItem(item)
            if not hasItem or hasItem.amount < amount then
                return false
            end
        end
    end

    for item, amount in pairs(recipe.ingredients) do
        local hasItem = SLCore.Functions.HasItem(item)
        if not hasItem or hasItem.amount < amount then
            return false
        end
    end

    return true
end

function StartCrafting(station, item)
    local recipe = Config.Recipes[station][item]
    if not recipe then return end

    -- Check ingredients
    if not HasRequiredItems(station, recipe) then
        SLCore.Functions.Notify(Lang:t('error.not_enough_ingredients'), 'error')
        return
    end

    -- Start crafting animation
    local ped = PlayerPedId()
    local animDict = Config.Animations.dict
    local animName = Config.Animations.anim

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(10)
    end

    TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)

    -- Start progress bar
    SLCore.Functions.Progressbar("crafting_item", Lang:t('info.crafting_progress'), recipe.time, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(ped)
        TriggerServerEvent('sl-crafting:server:craftItem', station, item)
    end, function() -- Cancel
        ClearPedTasks(ped)
        SLCore.Functions.Notify(Lang:t('error.crafting_failed'), 'error')
    end)
end

-- Events
RegisterNetEvent('sl-crafting:client:openMenu', function(data)
    if not data.station then return end
    CurrentStation = data.station
    TriggerEvent('sl-crafting:client:openCraftingMenu', data.station)
end)

-- Initialize
CreateThread(function()
    Wait(1000)
    SetupCraftingZones()
end)

-- Cleanup
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    RemoveCraftingBlips()
end)
