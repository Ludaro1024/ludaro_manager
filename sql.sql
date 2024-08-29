-- Check if the table 'ludaro_manager_interactions' exists, and create it if it doesn't
CREATE TABLE IF NOT EXISTS `ludaro_manager_interactions` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `interaction_name` VARCHAR(255) NOT NULL,
    `interaction_label` VARCHAR(255) NOT NULL,
    `grade` INT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Check if the table 'ludaro_manager_farmingspots' exists, and create it if it doesn't
CREATE TABLE IF NOT EXISTS `ludaro_manager_farmingspots` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `job` VARCHAR(255) DEFAULT NULL,
    `grade` INT DEFAULT 0,
    `coords` JSON NOT NULL,
    `animation` VARCHAR(255) DEFAULT NULL,
    `time` INT DEFAULT 5,
    `progressbar` BOOLEAN DEFAULT TRUE,
    `items_in` JSON DEFAULT NULL,
    `items_out` JSON DEFAULT NULL,
    `money_required` INT DEFAULT 0,
    `money_type` VARCHAR(50) DEFAULT 'money',
    `society_name` VARCHAR(255) DEFAULT NULL,
    `society_percentage` INT DEFAULT 0,
    `custom_code` TEXT DEFAULT NULL,
    `multi_step` BOOLEAN DEFAULT FALSE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Add missing columns to 'jobs' table
ALTER TABLE `jobs` 
ADD COLUMN IF NOT EXISTS `ludaro_manager_bossmenu` JSON DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `ludaro_manager_interactions` JSON DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `ludaro_manager_garage` JSON DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `ludaro_manager_onoffduty` JSON DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `ludaro_manager_stashes` JSON DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `ludaro_manager_vehicleShop` JSON DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `ludaro_manager_societyPaid` INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS `ludaro_manager_clothing` JSON DEFAULT NULL;

-- Add missing columns to 'owned_vehicles' table
ALTER TABLE `owned_vehicles` 
ADD COLUMN IF NOT EXISTS `ludaro_manager_job` VARCHAR(255) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `ludaro_manager_grade` INT(11) DEFAULT NULL;

-- Notify that the database setup is complete
SELECT 'Database setup complete' AS status;
