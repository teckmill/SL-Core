CREATE TABLE IF NOT EXISTS `player_hud_settings` (
    `identifier` varchar(50) NOT NULL,
    `settings` longtext NOT NULL,
    `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
