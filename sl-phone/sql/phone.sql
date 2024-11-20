CREATE TABLE IF NOT EXISTS `phone_bank_transactions` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(50) NOT NULL,
    `type` VARCHAR(50) NOT NULL,
    `amount` INT(11) NOT NULL,
    `description` VARCHAR(255) NOT NULL,
    `time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 