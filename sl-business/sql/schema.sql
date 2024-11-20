-- SL Business Management System Database Schema

-- Businesses Table
CREATE TABLE IF NOT EXISTS `businesses` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `type` VARCHAR(50) NOT NULL,
    `owner` VARCHAR(50) NOT NULL,
    `funds` INT(11) DEFAULT 0,
    `inventory_slots` INT(11) DEFAULT 50,
    `reputation` INT(11) DEFAULT 50,
    `zone` VARCHAR(50) NOT NULL,
    `coords` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Business Employees
CREATE TABLE IF NOT EXISTS `business_employees` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `business_id` INT(11) NOT NULL,
    `citizen_id` VARCHAR(50) NOT NULL,
    `role` VARCHAR(50) NOT NULL,
    `wage` INT(11) NOT NULL,
    `hired_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`business_id`) REFERENCES `businesses`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Business Upgrades
CREATE TABLE IF NOT EXISTS `business_upgrades` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `business_id` INT(11) NOT NULL,
    `upgrade_type` VARCHAR(50) NOT NULL,
    `level` INT(11) NOT NULL DEFAULT 0,
    `purchased_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`business_id`) REFERENCES `businesses`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Business Inventory
CREATE TABLE IF NOT EXISTS `business_inventory` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `business_id` INT(11) NOT NULL,
    `item` VARCHAR(50) NOT NULL,
    `amount` INT(11) NOT NULL DEFAULT 0,
    `buy_price` INT(11) NOT NULL DEFAULT 0,
    `sell_price` INT(11) NOT NULL DEFAULT 0,
    `last_restock` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`business_id`) REFERENCES `businesses`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Business Transactions
CREATE TABLE IF NOT EXISTS `business_transactions` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `business_id` INT(11) NOT NULL,
    `type` VARCHAR(50) NOT NULL,
    `amount` INT(11) NOT NULL,
    `description` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`business_id`) REFERENCES `businesses`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Business Events
CREATE TABLE IF NOT EXISTS `business_events` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `business_id` INT(11) NOT NULL,
    `type` VARCHAR(50) NOT NULL,
    `start_time` TIMESTAMP NOT NULL,
    `end_time` TIMESTAMP NOT NULL,
    `details` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`business_id`) REFERENCES `businesses`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Business Loans
CREATE TABLE IF NOT EXISTS `business_loans` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `business_id` INT(11) NOT NULL,
    `amount` INT(11) NOT NULL,
    `interest_rate` FLOAT NOT NULL,
    `term_months` INT(11) NOT NULL,
    `remaining_balance` INT(11) NOT NULL,
    `next_payment` TIMESTAMP NOT NULL,
    `status` VARCHAR(50) NOT NULL DEFAULT 'active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`business_id`) REFERENCES `businesses`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Business Analytics
CREATE TABLE IF NOT EXISTS `business_analytics` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `business_id` INT(11) NOT NULL,
    `date` DATE NOT NULL,
    `revenue` INT(11) NOT NULL DEFAULT 0,
    `expenses` INT(11) NOT NULL DEFAULT 0,
    `customer_count` INT(11) NOT NULL DEFAULT 0,
    `average_transaction` FLOAT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`business_id`) REFERENCES `businesses`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
