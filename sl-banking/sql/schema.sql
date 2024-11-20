-- Banking System Schema

-- Accounts Table
CREATE TABLE IF NOT EXISTS `sl_bank_accounts` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `account_number` VARCHAR(20) UNIQUE NOT NULL,
    `owner_identifier` VARCHAR(50) NOT NULL,
    `type` ENUM('checking', 'savings', 'business') NOT NULL,
    `balance` DECIMAL(15, 2) DEFAULT 0.00,
    `pin` VARCHAR(6) NOT NULL,
    `status` ENUM('active', 'frozen', 'closed') DEFAULT 'active',
    `credit_score` INT DEFAULT 700,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_owner` (`owner_identifier`),
    INDEX `idx_account_number` (`account_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Transactions Table
CREATE TABLE IF NOT EXISTS `sl_bank_transactions` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `account_id` INT NOT NULL,
    `type` ENUM('deposit', 'withdraw', 'transfer_in', 'transfer_out', 'loan_payment', 'investment_deposit', 'investment_withdraw') NOT NULL,
    `amount` DECIMAL(15, 2) NOT NULL,
    `balance_after` DECIMAL(15, 2) NOT NULL,
    `description` VARCHAR(255),
    `reference_id` VARCHAR(50),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`account_id`) REFERENCES `sl_bank_accounts`(`id`) ON DELETE CASCADE,
    INDEX `idx_account_date` (`account_id`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Investments Table
CREATE TABLE IF NOT EXISTS `sl_bank_investments` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `account_id` INT NOT NULL,
    `type` ENUM('stocks', 'bonds', 'crypto') NOT NULL,
    `amount` DECIMAL(15, 2) NOT NULL,
    `return_rate` DECIMAL(5, 2) NOT NULL,
    `status` ENUM('active', 'withdrawn') DEFAULT 'active',
    `start_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `end_date` TIMESTAMP NULL,
    FOREIGN KEY (`account_id`) REFERENCES `sl_bank_accounts`(`id`) ON DELETE CASCADE,
    INDEX `idx_account_status` (`account_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Loans Table
CREATE TABLE IF NOT EXISTS `sl_bank_loans` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `account_id` INT NOT NULL,
    `type` ENUM('personal', 'business', 'mortgage') NOT NULL,
    `amount` DECIMAL(15, 2) NOT NULL,
    `interest_rate` DECIMAL(5, 2) NOT NULL,
    `term_months` INT NOT NULL,
    `remaining_amount` DECIMAL(15, 2) NOT NULL,
    `status` ENUM('pending', 'active', 'paid', 'defaulted') DEFAULT 'pending',
    `start_date` TIMESTAMP NULL,
    `next_payment_date` TIMESTAMP NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`account_id`) REFERENCES `sl_bank_accounts`(`id`) ON DELETE CASCADE,
    INDEX `idx_account_status` (`account_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Loan Payments Table
CREATE TABLE IF NOT EXISTS `sl_bank_loan_payments` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `loan_id` INT NOT NULL,
    `amount` DECIMAL(15, 2) NOT NULL,
    `remaining_after` DECIMAL(15, 2) NOT NULL,
    `payment_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`loan_id`) REFERENCES `sl_bank_loans`(`id`) ON DELETE CASCADE,
    INDEX `idx_loan_date` (`loan_id`, `payment_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Account Access Table (for shared business accounts)
CREATE TABLE IF NOT EXISTS `sl_bank_account_access` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `account_id` INT NOT NULL,
    `user_identifier` VARCHAR(50) NOT NULL,
    `access_level` ENUM('view', 'deposit', 'withdraw', 'manage') NOT NULL,
    `granted_by` VARCHAR(50) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`account_id`) REFERENCES `sl_bank_accounts`(`id`) ON DELETE CASCADE,
    UNIQUE KEY `unique_access` (`account_id`, `user_identifier`),
    INDEX `idx_user` (`user_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ATM Transactions Table (for logging ATM usage)
CREATE TABLE IF NOT EXISTS `sl_bank_atm_transactions` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `transaction_id` INT NOT NULL,
    `location` VARCHAR(100) NOT NULL,
    `ip_address` VARCHAR(45) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`transaction_id`) REFERENCES `sl_bank_transactions`(`id`) ON DELETE CASCADE,
    INDEX `idx_location` (`location`),
    INDEX `idx_date` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Credit Score History Table
CREATE TABLE IF NOT EXISTS `sl_bank_credit_history` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `account_id` INT NOT NULL,
    `old_score` INT NOT NULL,
    `new_score` INT NOT NULL,
    `reason` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`account_id`) REFERENCES `sl_bank_accounts`(`id`) ON DELETE CASCADE,
    INDEX `idx_account_date` (`account_id`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
