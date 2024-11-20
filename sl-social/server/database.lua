local function LoadDatabase()
    local sqlFile = LoadResourceFile(GetCurrentResourceName(), 'sql/install.sql')
    if not sqlFile then
        print('^1[ERROR] Could not load sql/install.sql^0')
        return
    end

    -- Split the SQL file into individual statements
    local statements = {}
    for statement in sqlFile:gmatch("([^;]+);") do
        statement = statement:gsub('%-%-[^\n]*\n', '') -- Remove comments
        statement = statement:gsub('%s+', ' ') -- Normalize whitespace
        statement = statement:gsub('^%s+', '') -- Trim leading whitespace
        statement = statement:gsub('%s+$', '') -- Trim trailing whitespace
        
        if statement ~= '' then
            table.insert(statements, statement)
        end
    end

    -- Execute each statement separately
    for _, statement in ipairs(statements) do
        MySQL.query(statement, function(result)
            if not result then
                print('^1[ERROR] Failed to execute SQL statement^0')
                print(statement)
            end
        end)
    end
    
    print('^2[INFO] Database tables installed successfully^0')
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    LoadDatabase()
end)
