CREATE TABLE IF NOT EXISTS `mdt_reports` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) NOT NULL,
    `title` varchar(255) NOT NULL,
    `incident` longtext NOT NULL,
    `evidence` longtext DEFAULT NULL,
    `officers` longtext DEFAULT NULL,
    `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `author` varchar(50) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `mdt_warrants` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) NOT NULL,
    `description` text NOT NULL,
    `author` varchar(50) NOT NULL,
    `status` varchar(50) DEFAULT 'active',
    `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `police_evidence` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) NOT NULL,
    `type` varchar(50) NOT NULL,
    `description` text NOT NULL,
    `evidence` longtext NOT NULL,
    `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `police_fingerprints` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) NOT NULL,
    `fingerprint` varchar(50) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `fingerprint` (`fingerprint`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 