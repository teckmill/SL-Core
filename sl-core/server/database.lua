local function InitializeDatabase()
    -- Create database if it doesn't exist
    MySQL.query('CREATE DATABASE IF NOT EXISTS slframework')
    MySQL.query('USE slframework')
    
    -- Load and execute all SQL files
    local resources = {
        'sl-core',
        'sl-vehicles',
        'sl-jobs',
        'sl-ambulance',
        'sl-police',
        'sl-garage',
        'sl-dealership',
        'sl-phone'
    }
    
    for _, resource in ipairs(resources) do
        local sqlFile = LoadResourceFile(resource, 'sql/' .. resource:sub(4) .. '.sql')
        if sqlFile then
            print('^2Initializing database for: ^7' .. resource)
            -- Split SQL file into individual statements
            for statement in sqlFile:gmatch("([^;]+);") do
                statement = statement:gsub("^%s+", ""):gsub("%s+$", "") -- Trim whitespace
                if statement ~= "" then
                    local success = pcall(function()
                        MySQL.query(statement)
                    end)
                    if not success then
                        print('^1Error executing SQL statement for ' .. resource .. '^7')
                    end
                end
            end
        end
    end
    
    print('^2Database initialization complete!^7')
end

-- Initialize on resource start
CreateThread(function()
    Wait(1000) -- Wait for MySQL to be ready
    InitializeDatabase()
end)

-- Export for other resources
exports('InitializeDatabase', InitializeDatabase)