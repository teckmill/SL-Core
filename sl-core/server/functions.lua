-- Core Functions
SLCore.Functions = SLCore.Functions or {}

-- Get Identifier
function SLCore.Functions.GetIdentifier(source, idtype)
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in pairs(identifiers) do
        if string.find(identifier, idtype) then
            return identifier
        end
    end
    return nil
end

-- Get Source
function SLCore.Functions.GetSource(identifier)
    for src, _ in pairs(SLCore.Players) do
        local idens = GetPlayerIdentifiers(src)
        for _, id in pairs(idens) do
            if identifier == id then
                return src
            end
        end
    end
    return nil
end

-- Create Callback
function SLCore.Functions.CreateCallback(name, cb)
    SLCore.ServerCallbacks[name] = cb
end

-- Trigger Callback
function SLCore.Functions.TriggerCallback(name, source, cb, ...)
    if SLCore.ServerCallbacks[name] then
        SLCore.ServerCallbacks[name](source, cb, ...)
    end
end

-- Create Use Item
function SLCore.Functions.CreateUseableItem(item, cb)
    SLCore.UseableItems[item] = cb
end

-- Get Random String
function SLCore.Functions.GetRandomString(length)
    local charset = {}
    for i = 48, 57 do table.insert(charset, string.char(i)) end
    for i = 65, 90 do table.insert(charset, string.char(i)) end
    for i = 97, 122 do table.insert(charset, string.char(i)) end
    
    if not length or length <= 0 then length = 10 end
    math.randomseed(os.clock()^5)
    
    local retVal = ""
    for i = 1, length do
        retVal = retVal .. charset[math.random(1, #charset)]
    end
    return retVal
end

-- Get Random Int
function SLCore.Functions.GetRandomInt(length)
    local charset = {}
    for i = 48, 57 do table.insert(charset, string.char(i)) end
    
    if not length or length <= 0 then length = 10 end
    math.randomseed(os.clock()^5)
    
    local retVal = ""
    for i = 1, length do
        retVal = retVal .. charset[math.random(1, #charset)]
    end
    return retVal
end

-- Split String
function SLCore.Functions.SplitStr(str, delimiter)
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

-- Round Number
function SLCore.Functions.Round(value, numDecimalPlaces)
    if not numDecimalPlaces then return math.floor(value + 0.5) end
    local power = 10^numDecimalPlaces
    return math.floor((value * power) + 0.5) / (power)
end

-- UUID
function SLCore.Functions.UUID()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

-- Get Coords
function SLCore.Functions.GetCoords(entity)
    local coords = GetEntityCoords(entity)
    local heading = GetEntityHeading(entity)
    return vector4(coords.x, coords.y, coords.z, heading)
end

-- Title Case
function SLCore.Functions.TitleCase(str)
    return str:gsub("(%a)([%w_']*)", function(first, rest)
        return first:upper()..rest:lower()
    end)
end

-- Load JSON File
function SLCore.Functions.LoadJSON(file)
    local content = LoadResourceFile(GetCurrentResourceName(), file)
    if content then
        return json.decode(content)
    end
    return nil
end

-- Save JSON File
function SLCore.Functions.SaveJSON(file, data)
    SaveResourceFile(GetCurrentResourceName(), file, json.encode(data, {indent = true}), -1)
end

-- Print Table
function SLCore.Functions.PrintTable(table, indent)
    indent = indent or 0
    for k, v in pairs(table) do
        local tblType = type(v)
        local formatting = string.rep("  ", indent) .. k .. ": "
        
        if tblType == "table" then
            print(formatting)
            SLCore.Functions.PrintTable(v, indent + 1)
        elseif tblType == "boolean" then
            print(formatting .. tostring(v))
        else
            print(formatting .. v)
        end
    end
end

-- Debug
function SLCore.Debug(resource, obj, depth)
    TriggerEvent('sl-core:server:debug', resource, obj, depth)
end
