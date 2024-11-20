CREATE TABLE IF NOT EXISTS `player_garages` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) NOT NULL,
    `garage` varchar(50) NOT NULL,
    `plate` varchar(15) NOT NULL,
    `stored` tinyint(1) DEFAULT 1,
    `impounded` tinyint(1) DEFAULT 0,
    `impound_fee` int(11) DEFAULT 0,
    `parking_fee` int(11) DEFAULT 0,
    `last_stored` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`),
    KEY `plate` (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 