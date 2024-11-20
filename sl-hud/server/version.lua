local currentVersion = '1.0.0'
local resourceName = GetCurrentResourceName()

-- Version Info
print('^2=================================^0')
print('^2SL-HUD^0')
print('^2Version: ^0' .. currentVersion)
print('^2=================================^0')

-- Export version for other resources
exports('GetVersion', function()
    return currentVersion
end)
