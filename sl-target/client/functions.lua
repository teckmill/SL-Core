local SLCore = exports['sl-core']:GetCoreObject()

-- Local Variables
local targetActive = false
local targetData = {}
local currentZones = {}
local currentTargets = {}
local playerPed = nil
local playerCoords = nil

-- Utility Functions
local function isValidTarget(target)
    if not target or not target.options then return false end
    if not target.models and not target.coords then return false end
    return true
end

local function isEntityBlacklisted(entity)
    if not entity then return true end
    local model = GetEntityModel(entity)
    return Config.BlacklistedEntities[model] ~= nil
end

local function getTargetCoords(target)
    if target.coords then return target.coords end
    if target.entity then return GetEntityCoords(target.entity) end
    return nil
end

local function checkTargetDistance(coords, target)
    if not coords or not target then return false end
    local distance = #(coords - getTargetCoords(target))
    return distance <= (target.distance or Config.DefaultDistance)
end

local function hasRequiredJob(option)
    if not option.job then return true end
    local Player = SLCore.Functions.GetPlayerData()
    if type(option.job) == 'table' then
        for _, job in ipairs(option.job) do
            if Player.job.name == job then return true end
        end
        return false
    end
    return Player.job.name == option.job
end

local function filterOptions(options)
    if not options then return {} end
    local filtered = {}
    for _, option in ipairs(options) do
        if not option.job or hasRequiredJob(option) then
            table.insert(filtered, option)
        end
    end
    return filtered
end

-- Target Management Functions
function AddTargetEntity(entity, options, distance)
    if not entity or not DoesEntityExist(entity) then return false end
    local entityType = GetEntityType(entity)
    if entityType == 0 then return false end
    
    local entId = NetworkGetNetworkIdFromEntity(entity)
    currentTargets[entId] = {
        entity = entity,
        options = options,
        distance = distance or Config.DefaultDistance
    }
    return true
end

function RemoveTargetEntity(entity)
    if not entity then return false end
    local entId = NetworkGetNetworkIdFromEntity(entity)
    if currentTargets[entId] then
        currentTargets[entId] = nil
        return true
    end
    return false
end

function AddTargetModel(models, options, distance)
    if type(models) == 'string' or type(models) == 'number' then
        models = {models}
    end
    
    for _, model in ipairs(models) do
        if type(model) == 'string' then
            model = GetHashKey(model)
        end
        currentTargets[model] = {
            models = {model},
            options = options,
            distance = distance or Config.DefaultDistance
        }
    end
    return true
end

function RemoveTargetModel(models)
    if type(models) == 'string' or type(models) == 'number' then
        models = {models}
    end
    
    for _, model in ipairs(models) do
        if type(model) == 'string' then
            model = GetHashKey(model)
        end
        currentTargets[model] = nil
    end
    return true
end

function AddTargetBone(bones, options, distance)
    if type(bones) == 'string' then
        bones = {bones}
    end
    
    for _, bone in ipairs(bones) do
        currentTargets[bone] = {
            bones = {bone},
            options = options,
            distance = distance or Config.DefaultDistance
        }
    end
    return true
end

function RemoveTargetBone(bones)
    if type(bones) == 'string' then
        bones = {bones}
    end
    
    for _, bone in ipairs(bones) do
        currentTargets[bone] = nil
    end
    return true
end

function AddTargetZone(name, coords, length, width, options, targetoptions)
    if not coords or not length or not width then return false end
    
    currentZones[name] = {
        name = name,
        coords = coords,
        length = length,
        width = width,
        heading = targetoptions and targetoptions.heading or 0.0,
        minZ = targetoptions and targetoptions.minZ or coords.z - 1.0,
        maxZ = targetoptions and targetoptions.maxZ or coords.z + 1.0,
        options = options,
        distance = targetoptions and targetoptions.distance or Config.DefaultDistance
    }
    return true
end

function RemoveTargetZone(name)
    if not name then return false end
    if currentZones[name] then
        currentZones[name] = nil
        return true
    end
    return false
end

-- Export these functions
exports('AddTargetEntity', AddTargetEntity)
exports('RemoveTargetEntity', RemoveTargetEntity)
exports('AddTargetModel', AddTargetModel)
exports('RemoveTargetModel', RemoveTargetModel)
exports('AddTargetBone', AddTargetBone)
exports('RemoveTargetBone', RemoveTargetBone)
exports('AddTargetZone', AddTargetZone)
exports('RemoveTargetZone', RemoveTargetZone)
