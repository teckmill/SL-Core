local SLCore = exports['sl-core']:GetCoreObject()

-- Utility function to validate coordinates
local function ValidateCoords(coords)
    if not coords then return false end
    if type(coords) ~= 'vector3' and type(coords) ~= 'vector4' then return false end
    if coords.x == 0 and coords.y == 0 and coords.z == 0 then return false end
    return true
end

-- Utility function to check if a player is nearby
local function IsPlayerNearby(source, coords, distance)
    if not source or not coords then return false end
    distance = distance or 5.0
    
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local ped = GetPlayerPed(source)
    if not ped then return false end
    
    local playerCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - coords)
    
    return dist <= distance
end

-- Utility function to format currency
local function FormatCurrency(amount)
    local formatted = tostring(math.floor(amount))
    local k
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return '$' .. formatted
end

-- Utility function to validate property data
local function ValidatePropertyData(data)
    if type(data) ~= 'table' then return false end
    
    -- Required fields
    if not data.id or type(data.id) ~= 'string' then return false end
    if not data.label or type(data.label) ~= 'string' then return false end
    if not data.price or type(data.price) ~= 'number' then return false end
    if not data.coords or not ValidateCoords(data.coords) then return false end
    
    -- Optional fields with type validation
    if data.shell and type(data.shell) ~= 'string' then return false end
    if data.garage and not ValidateCoords(data.garage) then return false end
    if data.rentPrice and type(data.rentPrice) ~= 'number' then return false end
    
    return true
end

-- Utility function to get all online players
local function GetOnlinePlayers()
    local players = {}
    for _, player in ipairs(GetPlayers()) do
        local Player = SLCore.Functions.GetPlayer(tonumber(player))
        if Player then
            players[#players + 1] = {
                source = player,
                citizenid = Player.PlayerData.citizenid,
                name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
            }
        end
    end
    return players
end

-- Utility function to log property actions
local function LogPropertyAction(propertyId, action, data)
    if not propertyId or not action then return end
    
    local logData = {
        timestamp = os.date('%Y-%m-%d %H:%M:%S'),
        property = propertyId,
        action = action,
        data = json.encode(data or {})
    }
    
    MySQL.insert('INSERT INTO sl_property_logs (property_id, action, data, created_at) VALUES (?, ?, ?, NOW())', {
        propertyId,
        action,
        logData.data
    })
end

-- Export utility functions
exports('ValidateCoords', ValidateCoords)
exports('IsPlayerNearby', IsPlayerNearby)
exports('FormatCurrency', FormatCurrency)
exports('ValidatePropertyData', ValidatePropertyData)
exports('GetOnlinePlayers', GetOnlinePlayers)
exports('LogPropertyAction', LogPropertyAction)
