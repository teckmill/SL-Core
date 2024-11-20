local Translations = {}

local function _U(str, ...)
    if Translations[str] then
        return string.format(Translations[str], ...)
    end
    return str
end

local function AddLocale(lang, tbl)
    for k,v in pairs(tbl) do
        Translations[k] = v
    end
end

exports('AddLocale', AddLocale)
exports('_U', _U)
