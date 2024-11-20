local SLCore = exports['sl-core']:GetCoreObject()
local currentShop = nil
local inMenu = false
local cam = nil
local headingToCam = nil
local currentOutfit = nil

-- Initialize
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('sl-clothing:server:LoadOutfits')
end)

-- Menu Functions
function OpenClothingMenu(shopType, shopData)
    if inMenu then return end
    inMenu = true
    currentShop = shopData
    
    -- Create camera
    CreateClothingCam()
    
    -- Open NUI
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open",
        shopType = shopType,
        maxValues = GetMaxValues()
    })
end

function CloseMenu()
    if not inMenu then return end
    inMenu = false
    
    -- Destroy camera
    DestroyClothingCam()
    
    -- Close NUI
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "close"
    })
end

-- Camera Functions
function CreateClothingCam()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, true)
    
    headingToCam = GetEntityHeading(ped)
    local camOffset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.5)
    SetCamCoord(cam, camOffset.x, camOffset.y, camOffset.z)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z)
end

function DestroyClothingCam()
    RenderScriptCams(false, true, 1000, true, true)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    cam = nil
end

-- NUI Callbacks
RegisterNUICallback('close', function(data, cb)
    CloseMenu()
    cb('ok')
end)

RegisterNUICallback('save', function(data, cb)
    local ped = PlayerPedId()
    local outfitData = data.outfitData
    
    TriggerServerEvent('sl-clothing:server:SaveOutfit', data.outfitName, outfitData)
    CloseMenu()
    cb('ok')
end)

RegisterNUICallback('updateClothing', function(data, cb)
    local ped = PlayerPedId()
    local clothingData = data.clothingData
    
    for component, value in pairs(clothingData) do
        SetPedComponentVariation(ped, value.componentId, value.drawableId, value.textureId, 2)
    end
    cb('ok')
end)

-- Export
exports('OpenClothingMenu', OpenClothingMenu) 