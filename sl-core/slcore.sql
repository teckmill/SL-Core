CREATE TABLE IF NOT EXISTS `players` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) NOT NULL,
    `cid` int(11) DEFAULT NULL,
    `license` varchar(255) NOT NULL,
    `name` varchar(255) NOT NULL,
    `money` text NOT NULL,
    `charinfo` text DEFAULT NULL,
    `job` text NOT NULL,
    `gang` text DEFAULT NULL,
    `position` text NOT NULL,
    `metadata` text NOT NULL,
    `inventory` longtext DEFAULT NULL,
    `permission` varchar(50) DEFAULT 'user',
    `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`),
    KEY `license` (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `player_vehicles` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `license` varchar(50) DEFAULT NULL,
    `citizenid` varchar(50) DEFAULT NULL,
    `vehicle` varchar(50) DEFAULT NULL,
    `hash` varchar(50) DEFAULT NULL,
    `mods` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
    `plate` varchar(50) NOT NULL,
    `fakeplate` varchar(50) DEFAULT NULL,
    `garage` varchar(50) DEFAULT NULL,
    `fuel` int(11) DEFAULT 100,
    `engine` float DEFAULT 1000,
    `body` float DEFAULT 1000,
    `state` int(11) DEFAULT 1,
    `depotprice` int(11) NOT NULL DEFAULT 0,
    `drivingdistance` int(50) DEFAULT NULL,
    `status` text DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `plate` (`plate`),
    KEY `citizenid` (`citizenid`),
    KEY `license` (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `player_apartments` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) DEFAULT NULL,
    `name` varchar(50) DEFAULT NULL,
    `type` varchar(50) DEFAULT NULL,
    `label` varchar(50) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `bans` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) DEFAULT NULL,
    `license` varchar(50) DEFAULT NULL,
    `discord` varchar(50) DEFAULT NULL,
    `ip` varchar(50) DEFAULT NULL,
    `reason` text DEFAULT NULL,
    `expire` int(11) DEFAULT NULL,
    `bannedby` varchar(255) NOT NULL DEFAULT 'SLCore',
    PRIMARY KEY (`id`),
    KEY `license` (`license`),
    KEY `discord` (`discord`),
    KEY `ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
