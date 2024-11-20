local currentVersion = '1.0.0'
local resourceName = GetCurrentResourceName()

local function checkVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/SLFramework/sl-admin/main/version.txt', function(err, text, headers)
        if err == 200 then
            local latestVersion = text:gsub("%s+", "")
            if currentVersion ~= latestVersion then
                print('^3[' .. resourceName .. '] ^1Resource is outdated!')
                print('^3[' .. resourceName .. '] ^1Current version: ' .. currentVersion)
                print('^3[' .. resourceName .. '] ^1Latest version: ' .. latestVersion)
                print('^3[' .. resourceName .. '] ^1Please update from: ^5https://github.com/SLFramework/sl-admin^1')
            else
                print('^3[' .. resourceName .. '] ^2Resource is up to date! (v' .. currentVersion .. ')')
            end
        else
            print('^3[' .. resourceName .. '] ^1Failed to check version.')
        end
    end)
end

CreateThread(function()
    Wait(5000)
    checkVersion()
end)
