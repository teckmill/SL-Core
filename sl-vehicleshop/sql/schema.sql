-- Vehicle Finance Table
CREATE TABLE IF NOT EXISTS `vehicle_finance` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) NOT NULL,
    `vehicle` longtext NOT NULL,
    `model` varchar(50) NOT NULL,
    `plate` varchar(15) NOT NULL,
    `price` int(11) NOT NULL,
    `down_payment` int(11) NOT NULL,
    `monthly_payment` int(11) NOT NULL,
    `payments_remaining` int(11) NOT NULL,
    `interest_rate` float NOT NULL,
    `next_payment` int(11) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`),
    KEY `plate` (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Vehicle Sales Table
CREATE TABLE IF NOT EXISTS `vehicle_sales` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `seller_id` varchar(50) NOT NULL,
    `vehicle_model` varchar(50) NOT NULL,
    `sale_price` int(11) NOT NULL,
    `commission` int(11) NOT NULL,
    `sale_date` int(11) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `seller_id` (`seller_id`),
    KEY `sale_date` (`sale_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Vehicle Stock Table
CREATE TABLE IF NOT EXISTS `vehicle_stock` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `shop` varchar(50) NOT NULL,
    `model` varchar(50) NOT NULL,
    `stock` int(11) NOT NULL DEFAULT '0',
    `price` int(11) NOT NULL,
    `category` varchar(50) NOT NULL,
    `last_restock` int(11) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `shop_model` (`shop`, `model`),
    KEY `shop` (`shop`),
    KEY `category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
