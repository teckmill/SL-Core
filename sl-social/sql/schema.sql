-- sl-social schema

-- Phone contacts
CREATE TABLE IF NOT EXISTS `phone_contacts` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `owner` VARCHAR(50) NOT NULL,
    `contact_name` VARCHAR(50) NOT NULL,
    `number` VARCHAR(20) NOT NULL,
    `favorite` BOOLEAN DEFAULT FALSE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_owner` (`owner`),
    INDEX `idx_number` (`number`)
);

-- Phone messages
CREATE TABLE IF NOT EXISTS `phone_messages` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `sender` VARCHAR(50) NOT NULL,
    `receiver` VARCHAR(50) NOT NULL,
    `message` TEXT NOT NULL,
    `is_read` BOOLEAN DEFAULT FALSE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_sender` (`sender`),
    INDEX `idx_receiver` (`receiver`)
);

-- Social media posts
CREATE TABLE IF NOT EXISTS `social_posts` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `author` VARCHAR(50) NOT NULL,
    `content` TEXT NOT NULL,
    `image_url` VARCHAR(255),
    `likes` INT DEFAULT 0,
    `comments` INT DEFAULT 0,
    `is_private` BOOLEAN DEFAULT FALSE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_author` (`author`)
);

-- Social media comments
CREATE TABLE IF NOT EXISTS `social_comments` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `post_id` INT NOT NULL,
    `author` VARCHAR(50) NOT NULL,
    `content` TEXT NOT NULL,
    `likes` INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`post_id`) REFERENCES `social_posts`(`id`) ON DELETE CASCADE,
    INDEX `idx_post_id` (`post_id`),
    INDEX `idx_author` (`author`)
);

-- Social media follows
CREATE TABLE IF NOT EXISTS `social_follows` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `follower` VARCHAR(50) NOT NULL,
    `following` VARCHAR(50) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_follow` (`follower`, `following`),
    INDEX `idx_follower` (`follower`),
    INDEX `idx_following` (`following`)
);

-- Dating profiles
CREATE TABLE IF NOT EXISTS `dating_profiles` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `citizen_id` VARCHAR(50) NOT NULL UNIQUE,
    `display_name` VARCHAR(50) NOT NULL,
    `bio` TEXT,
    `interests` JSON,
    `photos` JSON,
    `preferences` JSON,
    `last_active` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_citizen_id` (`citizen_id`)
);

-- Dating matches
CREATE TABLE IF NOT EXISTS `dating_matches` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user1_id` VARCHAR(50) NOT NULL,
    `user2_id` VARCHAR(50) NOT NULL,
    `status` ENUM('pending', 'matched', 'rejected') DEFAULT 'pending',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_match` (`user1_id`, `user2_id`),
    INDEX `idx_user1` (`user1_id`),
    INDEX `idx_user2` (`user2_id`)
);

-- Reputation system
CREATE TABLE IF NOT EXISTS `reputation` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `citizen_id` VARCHAR(50) NOT NULL,
    `category` VARCHAR(50) NOT NULL,
    `score` INT DEFAULT 0,
    `total_ratings` INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_category_rating` (`citizen_id`, `category`),
    INDEX `idx_citizen_id` (`citizen_id`)
);

-- Reputation ratings
CREATE TABLE IF NOT EXISTS `reputation_ratings` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `rater_id` VARCHAR(50) NOT NULL,
    `rated_id` VARCHAR(50) NOT NULL,
    `category` VARCHAR(50) NOT NULL,
    `rating` INT NOT NULL,
    `comment` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_rating` (`rater_id`, `rated_id`, `category`),
    INDEX `idx_rater` (`rater_id`),
    INDEX `idx_rated` (`rated_id`)
);
