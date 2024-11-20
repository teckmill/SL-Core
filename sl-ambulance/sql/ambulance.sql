CREATE TABLE IF NOT EXISTS `ambulance_reports` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) NOT NULL,
    `title` varchar(255) NOT NULL,
    `description` text NOT NULL,
    `wounds` longtext DEFAULT NULL,
    `medications` longtext DEFAULT NULL,
    `author` varchar(50) NOT NULL,
    `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `patient_records` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) NOT NULL,
    `blood_type` varchar(10) DEFAULT NULL,
    `allergies` text DEFAULT NULL,
    `medications` text DEFAULT NULL,
    `notes` text DEFAULT NULL,
    `updated_by` varchar(50) NOT NULL,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `hospital_beds` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `bed_id` varchar(50) NOT NULL,
    `citizenid` varchar(50) DEFAULT NULL,
    `reason` text DEFAULT NULL,
    `admitted_by` varchar(50) DEFAULT NULL,
    `admitted_at` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `bed_id` (`bed_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 