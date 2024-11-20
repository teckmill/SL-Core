SLCore = SLCore or {}
SLCore.Shared = SLCore.Shared or {}

-- String utilities
function SLCore.Shared.SplitStr(str, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(str, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
    end
    table.insert(result, string.sub(str, from))
    return result
end

function SLCore.Shared.Trim(value)
    if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

function SLCore.Shared.FirstToUpper(value)
    if not value then return nil end
    return (value:gsub("^%l", string.upper))
end

-- Table utilities
function SLCore.Shared.TableContains(table, element)
    for _, value in pairs(table) do
        if value == element then return true end
    end
    return false
end

function SLCore.Shared.DumpTable(table, nb)
    if nb == nil then nb = 0 end
    if type(table) == 'table' then
        local s = ''
        for i = 1, nb + 1 do s = s .. "    " end
        s = '{\n'
        for k,v in pairs(table) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            for i = 1, nb do s = s .. "    " end
            s = s .. '['..k..'] = ' .. SLCore.Shared.DumpTable(v, nb + 1) .. ',\n'
        end
        for i = 1, nb do s = s .. "    " end
        return s .. '}'
    else
        return tostring(table)
    end
end

-- Math utilities
function SLCore.Shared.Round(value, numDecimalPlaces)
    if not numDecimalPlaces then return math.floor(value + 0.5) end
    local power = 10 ^ numDecimalPlaces
    return math.floor((value * power) + 0.5) / power
end

function SLCore.Shared.GroupDigits(value)
    local left, num, right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

-- Random utilities
function SLCore.Shared.RandomStr(length)
    local res = ""
    for i = 1, length do
        res = res .. string.char(math.random(97, 122))
    end
    return res
end

function SLCore.Shared.RandomInt(length)
    local res = ""
    for i = 1, length do
        res = res .. tostring(math.random(0, 9))
    end
    return res
end

-- Validation utilities
function SLCore.Shared.IsValidJob(job)
    return SLCore.Shared.Jobs[job] ~= nil
end

function SLCore.Shared.IsValidGang(gang)
    return SLCore.Shared.Gangs[gang] ~= nil
end

-- Debug utilities
function SLCore.Shared.DebugPrint(...)
    if not SLCore.Config.Debug then return end
    print(string.format('[SL-Core] [DEBUG] %s', table.concat({...}, ' ')))
end

function SLCore.Shared.ShowError(message)
    print(string.format('^1[SL-Core] [ERROR] %s^0', message))
end

function SLCore.Shared.ShowSuccess(message)
    print(string.format('^2[SL-Core] [SUCCESS] %s^0', message))
end

-- Export the utilities
exports('GetSharedUtils', function()
    return SLCore.Shared
end)
