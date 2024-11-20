local SLCore = exports['sl-core']:GetCoreObject()

-- Outfit management
local function SaveOutfit(outfitName)
    local ped = PlayerPedId()
    local outfitData = {
        outfitName = outfitName,
        model = GetEntityModel(ped),
        components = {}
    }
    
    for i = 0, 11 do
        outfitData.components[i] = {
            drawable = GetPedDrawableVariation(ped, i),
            texture = GetPedTextureVariation(ped, i),
            palette = GetPedPaletteVariation(ped, i)
        }
    end
    
    TriggerServerEvent('sl-clothing:server:saveOutfit', outfitData)
end

RegisterNetEvent('sl-clothing:client:loadOutfit')
AddEventHandler('sl-clothing:client:loadOutfit', function(outfit)
    local ped = PlayerPedId()
    
    if outfit.model ~= GetEntityModel(ped) then
        return SLCore.Functions.Notify('This outfit is for a different character model', 'error')
    end
    
    for component, data in pairs(outfit.components) do
        SetPedComponentVariation(ped, tonumber(component), data.drawable, data.texture, data.palette)
    end
    
    SLCore.Functions.Notify('Outfit loaded!', 'success')
end)
