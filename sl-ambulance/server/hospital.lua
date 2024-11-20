local SLCore = exports['sl-core']:GetCoreObject()

-- Store active hospitals and their staff
local hospitals = {}
local hospitalStaff = {}

-- Function to update hospital status
RegisterNetEvent('sl-ambulance:server:UpdateHospital', function(hospital)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local citizenid = Player.PlayerData.citizenid
    
    -- Remove player from previous hospital if any
    for hospital, staff in pairs(hospitalStaff) do
        for i, id in ipairs(staff) do
            if id == citizenid then
                table.remove(hospitalStaff[hospital], i)
                break
            end
        end
    end
    
    -- Add player to new hospital if provided
    if hospital then
        if not hospitalStaff[hospital] then
            hospitalStaff[hospital] = {}
        end
        table.insert(hospitalStaff[hospital], citizenid)
    end
end)

-- Function to get hospital staff count
local function getHospitalStaffCount(hospital)
    if not hospitalStaff[hospital] then return 0 end
    return #hospitalStaff[hospital]
end

-- Function to check if hospital has staff
local function hasActiveStaff(hospital)
    return getHospitalStaffCount(hospital) > 0
end

-- Function to get nearest hospital with staff
local function getNearestActiveHospital(coords)
    local nearestHospital = nil
    local shortestDistance = math.huge
    
    for hospital, staff in pairs(hospitalStaff) do
        if #staff > 0 then
            local hospitalCoords = Config.Hospitals[hospital].coords
            local distance = #(coords - hospitalCoords)
            
            if distance < shortestDistance then
                shortestDistance = distance
                nearestHospital = hospital
            end
        end
    end
    
    return nearestHospital
end

-- Export functions
exports('GetHospitalStaffCount', getHospitalStaffCount)
exports('HasActiveStaff', hasActiveStaff)
exports('GetNearestActiveHospital', getNearestActiveHospital)

-- Cleanup on player drop
AddEventHandler('playerDropped', function()
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local citizenid = Player.PlayerData.citizenid
    
    -- Remove player from hospital staff
    for hospital, staff in pairs(hospitalStaff) do
        for i, id in ipairs(staff) do
            if id == citizenid then
                table.remove(hospitalStaff[hospital], i)
                break
            end
        end
    end
end)
