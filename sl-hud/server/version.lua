local currentVersion = '1.0.0'
local resourceName = GetCurrentResourceName()
local versionCheckURL = 'https://raw.githubusercontent.com/SLCore/sl-hud/main/version.txt'

-- Version Check Function
local function CheckVersion()
    PerformHttpRequest(versionCheckURL, function(err, latestVersion, headers)
        if err == 200 then
            latestVersion = latestVersion:gsub("%s+", "") -- Remove whitespace
            
            if currentVersion ~= latestVersion then
                print('^1=================================^0')
                print('^1SL-HUD^0')
                print('^1Current version: ^0' .. currentVersion)
                print('^1Latest version: ^0' .. latestVersion)
                print('^1Please update to the latest version^0')
                print('^1=================================^0')
            else
                print('^2=================================^0')
                print('^2SL-HUD^0')
                print('^2Up to date!^0')
                print('^2Current version: ^0' .. currentVersion)
                print('^2=================================^0')
            end
        else
            print('^1=================================^0')
            print('^1SL-HUD^0')
            print('^1Failed to check version^0')
            print('^1Error: ^0' .. (err or 'unknown'))
            print('^1=================================^0')
        end
    end)
end

-- Check version on resource start
AddEventHandler('onResourceStart', function(resource)
    if resource == resourceName then
        Wait(1000)
        CheckVersion()
    end
end)

-- Export version for other resources
exports('GetVersion', function()
    return currentVersion
end)
