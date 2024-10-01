

MySQL.ready(function()

    --- Add missing columns to a specified table if they do not already exist.
    -- @param string tableName The name of the table to modify.
    -- @param table columns A list of columns to check and add if missing. Each column is a table with 'name' and 'type'.
    -- @return nil This function modifies the database directly.
    local function addMissingColumns(tableName, columns)
        for _, column in ipairs(columns) do
            local query = string.format("ALTER TABLE %s ADD COLUMN IF NOT EXISTS %s %s;", tableName, column.name, column.type)
            local affectedRows = MySQL.query.await(query, {})
            if affectedRows then
                Debug(2, string.format("Column '%s' added to table '%s'.", column.name, tableName))
                print(string.format("^2[Ludaro-Manager]^0: ^3%s^0 column '^3%s^0' added to table '^3%s^0'.", os.date("%X"), column.name, tableName))
            else
                Debug(1, string.format("Failed to add column '%s' to table '%s'.", column.name, tableName))
            end
        end
    end

    --- Check if columns exist in a specified table and adds them if they don't exist.
    -- @param string tableName The name of the table to check.
    -- @param table columns A list of columns to check and potentially add. Each column is a table with 'name' and 'type'.
    -- @return nil This function triggers the addition of missing columns if needed.
    local function checkAndAddColumns(tableName, columns)
        Debug(3, string.format("Checking for missing columns in table '%s'.", tableName))
        local checkQuery = string.format("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '%s'", tableName)
        local existingColumns = MySQL.query.await(checkQuery, {})
        
        local existingColumnNames = {}
        for _, row in ipairs(existingColumns) do
            existingColumnNames[row.COLUMN_NAME] = true
        end

        local columnsToAdd = {}
        for _, column in ipairs(columns) do
            if not existingColumnNames[column.name] then
                table.insert(columnsToAdd, column)
            end
        end

        if #columnsToAdd > 0 then
            Debug(3, string.format("Adding %d missing columns to table '%s'.", #columnsToAdd, tableName))
            addMissingColumns(tableName, columnsToAdd)
        else
            Debug(3, string.format("No missing columns found in table '%s'.", tableName))
        end
    end


    --- Creates the 'ludaro_manager_interactions' table if it does not already exist and inserts default data.
    -- @return nil This function creates the table and inserts default data directly in the database.
    function createInteractionsTable()
        Debug(3, "Checking if 'ludaro_manager_interactions' table exists.")
        -- Check if the table exists
        local checkQuery = string.format("SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '%s'", "ludaro_manager_interactions")
        local exists = MySQL.query.await(checkQuery, {})
        if #exists > 0 then
            Debug(3, "'ludaro_manager_interactions' table already exists.")
            return
        end

        local queries = {
            {
                query = [[
                    CREATE TABLE IF NOT EXISTS `ludaro_manager_interactions` (
                        `id` INT AUTO_INCREMENT PRIMARY KEY,
                        `interaction_name` VARCHAR(255) NOT NULL,
                        `interaction_label` VARCHAR(255) NOT NULL,
                        `grade` INT DEFAULT 0
                    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
                ]],
                values = {}
            },
            {
                query = [[
                    INSERT IGNORE INTO `ludaro_manager_interactions` (`interaction_name`, `interaction_label`, `grade`)
                    VALUES
                        ('cuff', 'Cuff / Uncuff', 0),
                        ('search', 'Search People', 0),
                        ('revive', 'Revive Nearby People', 0);
                ]],
                values = {}
            }
        }

        local success = MySQL.transaction.await(queries)
        if success then
            Debug(2, "Table 'ludaro_manager_interactions' created and default data inserted.")
            print("^2[Ludaro-Manager]^0: ^3" .. os.date("%X") .. "^0 Table '^3ludaro_manager_interactions^0' created and default data inserted.^0")
        else
            Debug(1, "Failed to create table or insert default data for 'ludaro_manager_interactions'.")
            print("^1[Ludaro-Manager]^0: ^3" .. os.date("%X") .. "^0 Failed to create table or insert default data for '^3ludaro_manager_interactions^0'.^0")
        end
    end

    --- Creates the 'ludaro_manager_farmingspots' table if it does not already exist.
    -- @return nil This function creates the table directly in the database.
    local function createFarmingSpotsTable()
        Debug(3, "Checking if 'ludaro_manager_farmingspots' table exists.")
        -- Check if the table exists
        local checkQuery = "SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ludaro_manager_farmingspots'"
        local exists = MySQL.query.await(checkQuery, {})

        if #exists == 0 then
            Debug(2, "Creating 'ludaro_manager_farmingspots' table.")
            local createTableQuery = [[
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
            ]]

            local affectedRows = MySQL.query.await(createTableQuery, {})
            if affectedRows then
                Debug(2, "Table 'ludaro_manager_farmingspots' created successfully.")
                print("^2[Ludaro-Manager]^0: ^3" .. os.date("%X") .. "^0 Table '^3ludaro_manager_farmingspots^0' created.^0")
            else
                Debug(1, "Failed to create 'ludaro_manager_farmingspots' table.")
            end
        else
            Debug(3, "'ludaro_manager_farmingspots' table already exists.")
        end
    end

    --- Ensures that the necessary tables and columns exist in the database.
    -- @return nil This function checks and modifies the database structure as needed.
    local function checkDatabaseStructure()
        Debug(3, "Checking database structure for necessary tables and columns.")
        -- Define the tables and their columns
        local tables = {
            jobs = {
                { name = "ludaro_manager_bossmenu",     type = "JSON DEFAULT NULL" },
                { name = "ludaro_manager_interactions", type = "JSON DEFAULT NULL" },
                { name = "ludaro_manager_garage",       type = "JSON DEFAULT NULL" },
                { name = "ludaro_manager_onoffduty",    type = "JSON DEFAULT NULL" },
                { name = "ludaro_manager_stashes",      type = "JSON DEFAULT NULL" },
                { name = "ludaro_manager_vehicleShop",  type = "JSON DEFAULT NULL" },
                { name = "ludaro_manager_societyPaid",  type = "INT DEFAULT 0" },
                { name = "ludaro_manager_clothing",     type = "JSON DEFAULT NULL" }
            },
            owned_vehicles = {
                { name = "ludaro_manager_job",   type = "VARCHAR(255) DEFAULT NULL" },
                { name = "ludaro_manager_grade", type = "INT(11) DEFAULT NULL" }
            }
        }

        -- Check each table
        for tableName, columns in pairs(tables) do
            checkAndAddColumns(tableName, columns)
        end
    end

    --- Ensures the database setup is complete by checking and creating necessary tables and columns.
    -- @return nil This function continually checks until the setup is complete.
    local function ensureDatabaseSetup()
        Debug(3, "Starting database setup process.")
        -- Create required tables first
        createFarmingSpotsTable()
        createInteractionsTable()

        -- Check and add missing columns
        checkDatabaseStructure()

        Debug(2, "Database setup complete.")
        print("^2[Ludaro-Manager]^0: ^3" .. os.date("%X") .. "^0 Database setup complete.^0")
    end

    -- Initialize database setup.
    ensureDatabaseSetup()
end)
