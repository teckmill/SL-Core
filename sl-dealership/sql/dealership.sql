CREATE TABLE IF NOT EXISTS `dealership_sales` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) NOT NULL,
    `vehicle` varchar(50) NOT NULL,
    `plate` varchar(15) NOT NULL,
    `price` int(11) NOT NULL,
    `finance` tinyint(1) DEFAULT 0,
    `downpayment` int(11) DEFAULT NULL,
    `monthly_payment` int(11) DEFAULT NULL,
    `months_remaining` int(11) DEFAULT NULL,
    `next_payment` timestamp NULL DEFAULT NULL,
    `salesperson` varchar(50) DEFAULT NULL,
    `commission` int(11) DEFAULT NULL,
    `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`),
    KEY `plate` (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `dealership_testdrives` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) NOT NULL,
    `vehicle` varchar(50) NOT NULL,
    `start_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `end_time` timestamp NULL DEFAULT NULL,
    `deposit` int(11) NOT NULL,
    `deposit_returned` tinyint(1) DEFAULT 0,
    `damage_fee` int(11) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `dealership_stock` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `model` varchar(50) NOT NULL,
    `stock` int(11) NOT NULL DEFAULT 0,
    `price_multiplier` float NOT NULL DEFAULT 1.0,
    `last_restock` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `model` (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `dealership_finances` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) NOT NULL,
    `credit_score` int(11) NOT NULL DEFAULT 500,
    `total_loans` int(11) NOT NULL DEFAULT 0,
    `active_loans` int(11) NOT NULL DEFAULT 0,
    `missed_payments` int(11) NOT NULL DEFAULT 0,
    `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 