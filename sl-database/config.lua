Config = {}

-- Database Configuration
Config.DefaultPool = 5 -- Default connection pool size
Config.MaxPool = 10 -- Maximum connection pool size
Config.IdleTimeout = 60 -- Seconds before an idle connection is closed

-- Query Settings
Config.SlowQueryWarning = 100 -- Milliseconds threshold for slow query warnings
Config.QueryTimeout = 10000 -- Milliseconds before query timeout
Config.EnableQueryLogging = true -- Enable logging of all queries
Config.LogSlowQueriesOnly = false -- Only log queries that exceed SlowQueryWarning

-- Cache Settings
Config.EnableQueryCache = true -- Enable query result caching
Config.CacheTimeout = 300 -- Seconds before cache entry expires
Config.MaxCacheSize = 1000 -- Maximum number of cached queries

-- Backup Settings
Config.EnableAutoBackup = true -- Enable automatic database backups
Config.BackupInterval = 24 -- Hours between backups
Config.MaxBackups = 7 -- Maximum number of backup files to keep
Config.BackupPath = 'backups/' -- Path to store backup files

-- Migration Settings
Config.EnableAutoMigrations = true -- Enable automatic database migrations
Config.MigrationsPath = 'migrations/' -- Path to migration files
Config.MigrationTable = 'sl_migrations' -- Table to track migrations
