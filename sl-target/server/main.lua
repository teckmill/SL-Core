local SLCore = exports['sl-core']:GetCoreObject()

-- Server-side validation of target options
local function ValidateOptions(options)
    if not options then return false end
    for _, option in ipairs(options) do
        if not option.type or not option.event or not option.label then
            return false
        end
        if option.type ~= 'client' and option.type ~= 'server' then
            return false
        end
    end
    return true
end

-- Server events for target synchronization
RegisterNetEvent('sl-target:server:syncTargets', function(targets)
    local src = source
    if not targets then return end
    
    -- Validate targets before syncing
    for _, target in pairs(targets) do
        if not ValidateOptions(target.options) then
            return
        end
    end
    
    -- Sync targets to all clients
    TriggerClientEvent('sl-target:client:syncTargets', -1, targets)
end)

-- Debug command to reload all targets
RegisterCommand('reloadtargets', function(source, args)
    local src = source
    if not SLCore.Functions.HasPermission(src, 'admin') then
        TriggerClientEvent('SLCore:Notify', src, Lang:t('error.not_authorized'), 'error')
        return
    end
    
    TriggerClientEvent('sl-target:client:reloadTargets', -1)
    TriggerClientEvent('SLCore:Notify', src, 'All targets have been reloaded', 'success')
end)
