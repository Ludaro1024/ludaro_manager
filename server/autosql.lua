MySQL.ready(function()

 query1 = [[
 ALTER TABLE jobs
ADD COLUMN ludaro_manager_bossmenu JSON DEFAULT NULL,
ADD COLUMN ludaro_manager_interactions JSON DEFAULT NULL,
ADD COLUMN ludaro_manager_garage JSON DEFAULT NULL,
ADD COLUMN ludaro_manager_onoffduty JSON DEFAULT NULL,
ADD COLUMN ludaro_manager_stashes JSON DEFAULT NULL,
ADD COLUMN ludaro_manager_shops JSON DEFAULT NULL,
ADD COLUMN ludaro_manager_processing JSON DEFAULT NULL;
ADD COLUMN ludaro_manager_vehicleShop JSON DEFAULT NULL;

 ]]
-- TODO: ADD DEFAULT []
 
 query2 = [[
 CREATE TABLE IF NOT EXISTS ludaro_manager_interactions (
     id INT AUTO_INCREMENT PRIMARY KEY,
     interaction_name VARCHAR(255) NOT NULL
 );]]
 
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
     end 
 end)
 end)
 