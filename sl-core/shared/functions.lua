SLCore = {}
SLCore.Functions = {}
SLCore.Commands = {}
SLCore.Players = {}
SLCore.RequestId = 0
SLCore.Shared = {}
SLCore.Shared.Languages = {}
SLCore.Shared.CurrentLanguage = 'en'

-- Locale System
function SLCore.Shared.Locale(language, translations)
    if not language or not translations then return end
    
    if not SLCore.Shared.Languages[language] then
        SLCore.Shared.Languages[language] = {}
    end
    
    for key, value in pairs(translations) do
        if type(value) == 'table' then
            if not SLCore.Shared.Languages[language][key] then
                SLCore.Shared.Languages[language][key] = {}
            end
            for subKey, subValue in pairs(value) do
                SLCore.Shared.Languages[language][key][subKey] = subValue
            end
        else
            SLCore.Shared.Languages[language][key] = value
        end
    end
end

function SLCore.Shared.GetLocale(key, language)
    language = language or SLCore.Shared.CurrentLanguage
    
    if not SLCore.Shared.Languages[language] then return key end
    
    local keys = {}
    for k in string.gmatch(key, "[^%.]+") do
        table.insert(keys, k)
    end
    
    local value = SLCore.Shared.Languages[language]
    for _, k in ipairs(keys) do
        if type(value) ~= 'table' then return key end
        value = value[k]
        if not value then return key end
    end
    
    return value
end

function SLCore.Functions.CreateCallback(name, cb)
    SLCore.ServerCallbacks[name] = cb
end

function SLCore.Functions.TriggerCallback(name, cb, ...)
    SLCore.ServerCallbacks[name] = cb
    TriggerServerEvent('SLCore:Server:TriggerCallback', name, ...)
end

function SLCore.Functions.GetPlayerData(cb)
    if cb then
        cb(SLCore.PlayerData)
    else
        return SLCore.PlayerData
    end
end

function SLCore.Functions.DrawText(x, y, width, height, scale, r, g, b, a, text)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end