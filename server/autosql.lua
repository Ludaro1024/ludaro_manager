MySQL.ready(function()
    local function addMissingColumns(tableName, columns)
        for _, column in ipairs(columns) do
            local query = string.format("ALTER TABLE %s ADD COLUMN IF NOT EXISTS %s %s;", tableName, column.name, column.type)
            MySQL.Async.execute(query, {}, function()
                print("Added missing column '" .. column.name .. "' to table '" .. tableName .. "'")
            end)
        end
    end

    local function checkAndAddColumns(tableName, columns)
        local columnsToAdd = {}

        local checkQuery = string.format("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '%s'", tableName)
        MySQL.Async.fetchAll(checkQuery, {}, function(existingColumns)
            local existingColumnNames = {}
            for _, row in ipairs(existingColumns) do
                existingColumnNames[row.COLUMN_NAME] = true
            end

            for _, column in ipairs(columns) do
                if not existingColumnNames[column.name] then
                    table.insert(columnsToAdd, column)
                end
            end

            if #columnsToAdd > 0 then
                addMissingColumns(tableName, columnsToAdd)
            end
        end)
    end

    local function checkDatabaseStructure()
        -- Define the tables and their columns
        local tables = {
            jobs = {
                { name = "ludaro_manager_bossmenu", type = "JSON DEFAULT NULL" },
                { name = "ludaro_manager_interactions", type = "JSON DEFAULT NULL" },
                { name = "ludaro_manager_garage", type = "JSON DEFAULT NULL" },
                { name = "ludaro_manager_onoffduty", type = "JSON DEFAULT NULL" },
                { name = "ludaro_manager_stashes", type = "JSON DEFAULT NULL" },
                { name = "ludaro_manager_vehicleShop", type = "JSON DEFAULT NULL" },
                { name = "ludaro_manager_societyPaid", type = "INT DEFAULT 0" },
                { name = "ludaro_manager_clothing", type = "JSON DEFAULT NULL" }
            },
            owned_vehicles = {
                { name = "ludaro_manager_job", type = "VARCHAR(255) DEFAULT NULL" },
                { name = "ludaro_manager_grade", type = "INT(11) DEFAULT NULL" }
            }
        }

        -- Check each table
        for tableName, columns in pairs(tables) do
            checkAndAddColumns(tableName, columns)
        end
    end

    local function ensureDatabaseSetup()
        local allSetup = false

        while not allSetup do
            local checkquery = "SELECT 1 FROM information_schema.tables WHERE table_name = 'jobs' LIMIT 1;"
            MySQL.Async.fetchAll(checkquery, {}, function(result)
                if result ~= nil and next(result) ~= nil then
                    -- Check and add missing columns
                    checkDatabaseStructure()

                    -- Check if everything is set up correctly
                    MySQL.Async.fetchAll(checkquery, {}, function(result)
                        if result ~= nil and next(result) ~= nil then
                            allSetup = true
                            print("Database setup completed.")
                        end
                    end)
                else
                    print("Database setup incomplete. Retrying...")
                end
            end)

            Citizen.Wait(1000) -- Wait for a second before retrying
        end
    end

    ensureDatabaseSetup()
end)
