local SL = exports['sl-core']:GetCoreObject()
local QueryCache = {}
local ActiveConnections = 0

-- Database Connection Management
local function GetConnection()
    if ActiveConnections >= Config.MaxPool then
        return nil, 'Connection pool exhausted'
    end
    ActiveConnections = ActiveConnections + 1
    return true
end

local function ReleaseConnection()
    if ActiveConnections > 0 then
        ActiveConnections = ActiveConnections - 1
    end
end

-- Query Cache Management
local function CacheQuery(query, result)
    if not Config.EnableQueryCache then return end
    
    QueryCache[query] = {
        result = result,
        timestamp = os.time()
    }
    
    -- Clean old cache entries
    for q, data in pairs(QueryCache) do
        if os.time() - data.timestamp > Config.CacheTimeout then
            QueryCache[q] = nil
        end
    end
end

local function GetCachedQuery(query)
    if not Config.EnableQueryCache then return nil end
    
    local cached = QueryCache[query]
    if cached and os.time() - cached.timestamp <= Config.CacheTimeout then
        return cached.result
    end
    return nil
end

-- Query Execution
local function ExecuteQuery(query, params)
    local start = os.clock()
    local success, result = pcall(function()
        return MySQL.query.await(query, params or {})
    end)
    local duration = (os.clock() - start) * 1000
    
    if duration > Config.SlowQueryWarning then
        print(string.format('^3[WARNING] Slow query detected (%.2fms): %s^0', duration, query))
    end
    
    if success then
        CacheQuery(query, result)
        return result
    else
        print(string.format('^1[ERROR] Query failed: %s^0', result))
        return nil, result
    end
end

-- Database Backup
local function CreateBackup()
    if not Config.EnableAutoBackup then return end
    
    local timestamp = os.date('%Y%m%d_%H%M%S')
    local filename = string.format('%s/backup_%s.sql', Config.BackupPath, timestamp)
    
    -- Execute mysqldump command
    local command = string.format(
        'mysqldump -u %s -p%s %s > %s',
        GetConvar('mysql_username', 'root'),
        GetConvar('mysql_password', ''),
        GetConvar('mysql_database', 'slframework'),
        filename
    )
    
    os.execute(command)
    
    -- Clean old backups
    local files = {}
    local dir = io.popen('dir "'..Config.BackupPath..'" /b')
    for file in dir:lines() do
        table.insert(files, file)
    end
    dir:close()
    
    table.sort(files)
    while #files > Config.MaxBackups do
        os.remove(Config.BackupPath..'/'..files[1])
        table.remove(files, 1)
    end
end

-- Database Migrations
local function RunMigrations()
    if not Config.EnableAutoMigrations then return end
    
    -- Create migrations table if it doesn't exist
    ExecuteQuery([[
        CREATE TABLE IF NOT EXISTS ]]..Config.MigrationTable..[[ (
            id INT AUTO_INCREMENT PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
            executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ]])
    
    -- Get list of executed migrations
    local executed = {}
    local results = ExecuteQuery('SELECT name FROM '..Config.MigrationTable)
    for _, row in ipairs(results or {}) do
        executed[row.name] = true
    end
    
    -- Run pending migrations
    local dir = io.popen('dir "'..Config.MigrationsPath..'" /b')
    for file in dir:lines() do
        if not executed[file] then
            local f = io.open(Config.MigrationsPath..'/'..file, 'r')
            if f then
                local content = f:read('*all')
                f:close()
                
                local success = ExecuteQuery(content)
                if success then
                    ExecuteQuery('INSERT INTO '..Config.MigrationTable..' (name) VALUES (?)', {file})
                    print('^2[INFO] Executed migration: '..file..'^0')
                end
            end
        end
    end
    dir:close()
end

-- Initialize Database Tables
CreateThread(function()
    MySQL.ready(function()
        -- Load and execute SQL file
        local sqlFile = LoadResourceFile(GetCurrentResourceName(), 'sql/tables.sql')
        if sqlFile then
            -- Split and execute SQL statements
            for statement in sqlFile:gmatch("([^;]+);") do
                statement = statement:gsub("^%s+", ""):gsub("%s+$", "") -- Trim whitespace
                if statement ~= "" then
                    MySQL.Sync.execute(statement)
                end
            end
            print('[SL-Database] Database tables initialized successfully')
        else
            print('[SL-Database] Error: Could not load SQL file')
        end
    end)
end)

-- Exports
exports('ExecuteQuery', ExecuteQuery)
exports('GetCachedQuery', GetCachedQuery)
exports('CreateBackup', CreateBackup)

-- Initialize
CreateThread(function()
    RunMigrations()
    
    -- Start backup timer if enabled
    if Config.EnableAutoBackup then
        CreateThread(function()
            while true do
                CreateBackup()
                Wait(Config.BackupInterval * 3600000) -- Convert hours to milliseconds
            end
        end)
    end
end)
