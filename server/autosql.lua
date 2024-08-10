MySQL.ready(function()
    query1 = [[
 ALTER TABLE jobs
ADD COLUMN ludaro_manager_bossmenu JSON DEFAULT NULL,
ADD COLUMN ludaro_manager_interactions JSON DEFAULT NULL,
ADD COLUMN ludaro_manager_garage JSON DEFAULT NULL,
ADD COLUMN ludaro_manager_onoffduty JSON DEFAULT NULL,
ADD COLUMN ludaro_manager_stashes JSON DEFAULT NULL,
ADD COLUMN ludaro_manager_vehicleShop JSON DEFAULT NULL;
ADD COLUMN ludaro_manager_societyPaid INT DEFAULT 0;
 ]]

    query2 = [[
 CREATE TABLE IF NOT EXISTS ludaro_manager_interactions (
     id INT AUTO_INCREMENT PRIMARY KEY,
     interaction_name VARCHAR(255) NOT NULL,
     interaction_label VARCHAR(255) NOT NULL
     grade INT(11) DEFAULT 0
 );]]

 query3 = [[
 
 ALTER TABLE owned_vehicles
 ADD COLUMN ludaro_manager_job VARCHAR(255) DEFAULT NULL;
 ADD COLUMN ludaro_manager_grade INT(11) DEFAULT NULL;
 ]]

    -- Check if table ludaro_manager_armories exists, if not create tables
    checkquery = [[ SELECT * FROM information_schema.tables WHERE table_name = 'ludaro_manager_interactions' LIMIT 1; ]]

    MySQL.Async.fetchAll(checkquery, {}, function(result)
        if result == nil or next(result) == nil then
            MySQL.Async.execute(query1, {}, function()
                print("Added columns ludaro_manager_info and interactions to jobs table")
            end)
            MySQL.Async.execute(query2, {}, function()
                print("Created table ludaro_manager_interactions")
            end)
            MySQL.Async.execute(query3, {}, function()
                print("Added column ludaro_manager_job to owned_vehicles table")
            end)
        end
    end)
end)
