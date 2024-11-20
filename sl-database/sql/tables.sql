-- Create query_cache table for storing cached query results
CREATE TABLE IF NOT EXISTS `query_cache` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `query_hash` varchar(64) NOT NULL,
    `result` longtext NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `expires_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `query_hash` (`query_hash`),
    KEY `expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create query_logs table for tracking slow queries and errors
CREATE TABLE IF NOT EXISTS `query_logs` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `query` text NOT NULL,
    `params` text DEFAULT NULL,
    `execution_time` float NOT NULL,
    `error` text DEFAULT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create database_migrations table for tracking schema changes
CREATE TABLE IF NOT EXISTS `database_migrations` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `batch` int(11) NOT NULL,
    `migration_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create job_societies table for managing job accounts
CREATE TABLE IF NOT EXISTS `job_societies` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `job_name` varchar(50) NOT NULL,
    `money` int(11) NOT NULL DEFAULT 0,
    `owner` varchar(60) DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `job_name` (`job_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
