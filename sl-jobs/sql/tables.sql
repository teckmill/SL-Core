CREATE TABLE IF NOT EXISTS `job_societies` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `money` int(11) NOT NULL DEFAULT 0,
    `owner` varchar(60) DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Insert default societies
INSERT IGNORE INTO `job_societies` (`name`, `money`, `owner`) VALUES
('police', 0, NULL),
('ambulance', 0, NULL),
('mechanic', 0, NULL),
('taxi', 0, NULL);
