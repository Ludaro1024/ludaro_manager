
CREATE TABLE IF NOT EXISTS ludaro_manager_armories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    job_name VARCHAR(255) NOT NULL,
    weapons JSON NOT NULL,    -- JSON to store the weapons
    components JSON NOT NULL, -- JSON to store the components
    ammo JSON NOT NULL,       -- JSON to store the ammo
    extras JSON NOT NULL,     -- JSON to store any extras
    blip_data JSON NOT NULL   -- JSON4 to store the blip data
);


ALTER TABLE jobs
ADD COLUMN ludaro_manager_info JSON NOT NULL,
ADD COLUMN ludaro_manager_interactions JSON NOT NULL;


CREATE TABLE IF NOT EXISTS ludaro_manager_interactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    interaction_name VARCHAR(255) NOT NULL,
);