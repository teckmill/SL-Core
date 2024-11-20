local SLCore = exports['sl-core']:GetCoreObject()

-- Debug Print Function
local function debugPrint(...)
    if SLCore.Config.Server.Debug then
        print('^3[sl-core]^7', ...)
    end
end

-- Debug Log Function
local function debugLog(...)
    if SLCore.Config.Server.Debug then
        print('^3[sl-core]^7', ...)
        local msg = table.concat({...}, ' ')
        local file = io.open(GetResourcePath(GetCurrentResourceName())..'/logs/debug.log', 'a')
        if file then
            local timestamp = os.date('%Y-%m-%d %H:%M:%S')
            file:write(string.format('[%s] %s\n', timestamp, msg))
            file:close()
        end
    end
end

-- Export Debug Functions
exports('DebugPrint', debugPrint)
exports('DebugLog', debugLog)

-- Debug Commands
SLCore.Commands.Add('debugmode', 'Toggle debug mode', {}, false, function(source)
    if SLCore.Functions.HasPermission(source, 'admin') then
        SLCore.Config.Server.Debug = not SLCore.Config.Server.Debug
        TriggerClientEvent('SLCore:Notify', source, 'Debug Mode: '..tostring(SLCore.Config.Server.Debug), 'success')
    end
end, 'admin')
