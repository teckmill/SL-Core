local Locale = {}
Locale.__index = Locale

local function translateKey(phrase, subs)
    if type(phrase) ~= 'string' then
        error('Invalid phrase type, must be string')
    end
    
    if not subs then return phrase end
    
    local result = phrase
    
    for k, v in pairs(subs) do
        result = result:gsub('{' .. k .. '}', tostring(v))
    end
    
    return result
end

function Locale.new(_, opts)
    local self = setmetatable({}, Locale)
    
    self.fallback = opts.fallback
    self.phrases = {}
    self.warnOnMissing = opts.warnOnMissing or false
    
    return self
end

function Locale:add(phrase, value)
    if not phrase or not value then return end
    self.phrases[phrase] = value
end

function Locale:has(phrase)
    return self.phrases[phrase] ~= nil
end

function Locale:delete(phrase)
    self.phrases[phrase] = nil
end

function Locale:clear()
    self.phrases = {}
end

function Locale:replace(phrases)
    for k, v in pairs(phrases) do
        self:add(k, v)
    end
end

function Locale:locale(phrase, subs)
    if not phrase then return '' end
    
    local result = self.phrases[phrase]
    if not result then
        if self.warnOnMissing then
            print(string.format('Missing phrase for key: %s', phrase))
        end
        if self.fallback then
            result = self.fallback.phrases[phrase]
        end
        if not result then
            return phrase
        end
    end
    
    return translateKey(result, subs)
end

setmetatable(Locale, {
    __call = Locale.new
})

_G.Locale = Locale
