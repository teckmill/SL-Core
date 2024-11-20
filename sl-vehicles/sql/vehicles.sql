CREATE TABLE IF NOT EXISTS `player_vehicles` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) NOT NULL,
    `vehicle` varchar(50) NOT NULL,
    `plate` varchar(15) NOT NULL,
    `hash` varchar(50) NOT NULL,
    `mods` longtext,
    `state` tinyint(1) NOT NULL DEFAULT '0',
    `stored` varchar(50) DEFAULT 'garage',
    `damage` longtext,
    `fuel` int(11) NOT NULL DEFAULT '100',
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`),
    KEY `plate` (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vehicle_categories` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `label` varchar(50) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vehicle_shops` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `label` varchar(50) NOT NULL,
    `type` varchar(50) NOT NULL,
    `coords` longtext,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vehicle_inventory` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `plate` varchar(15) NOT NULL,
    `items` longtext,
    PRIMARY KEY (`id`),
    KEY `plate` (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vehicle_keys` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) NOT NULL,
    `plate` varchar(15) NOT NULL,
    `type` varchar(20) DEFAULT 'main',
    `given_by` varchar(50) DEFAULT NULL,
    `date_given` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`),
    KEY `plate` (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 