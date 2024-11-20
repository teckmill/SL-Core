-- Create bans table if it doesn't exist
CREATE TABLE IF NOT EXISTS `bans` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) DEFAULT NULL,
    `license` varchar(50) DEFAULT NULL,
    `discord` varchar(50) DEFAULT NULL,
    `ip` varchar(50) DEFAULT NULL,
    `reason` text DEFAULT NULL,
    `expire` int(11) DEFAULT NULL,
    `bannedby` varchar(50) DEFAULT NULL,
    `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    KEY `license` (`license`),
    KEY `discord` (`discord`),
    KEY `ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create admin_logs table if it doesn't exist
CREATE TABLE IF NOT EXISTS `admin_logs` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `type` varchar(50) NOT NULL,
    `admin` varchar(50) NOT NULL,
    `target` varchar(50) DEFAULT NULL,
    `action` varchar(255) NOT NULL,
    `data` text DEFAULT NULL,
    `timestamp` int(11) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `type` (`type`),
    KEY `admin` (`admin`),
    KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create reports table if it doesn't exist
CREATE TABLE IF NOT EXISTS `reports` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `reporter` varchar(50) NOT NULL,
    `reported` varchar(50) DEFAULT NULL,
    `reason` text NOT NULL,
    `status` varchar(50) DEFAULT 'open',
    `handler` varchar(50) DEFAULT NULL,
    `notes` text DEFAULT NULL,
    `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    KEY `status` (`status`),
    KEY `reporter` (`reporter`),
    KEY `reported` (`reported`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
