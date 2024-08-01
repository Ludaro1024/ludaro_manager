MySQL.ready(function()
    query1 = [[CREATE TABLE IF NOT EXISTS ludaro_manager_armories (
     id INT AUTO_INCREMENT PRIMARY KEY,
     job_name VARCHAR(255) NOT NULL,
     weapons JSON NOT NULL,    -- JSON to store the weapons
     components JSON NOT NULL, -- JSON to store the components
     ammo JSON NOT NULL,       -- JSON to store the ammo
     extras JSON NOT NULL,     -- JSON to store any extras
     blip_data JSON NOT NULL   -- JSON to store the blip data
 );]]
 
 query2 = [[
 ALTER TABLE jobs
 ADD COLUMN ludaro_manager_info JSON NOT NULL,
 ADD COLUMN ludaro_manager_interactions JSON NOT NULL;
 ]]
 
 query3 = [[
 CREATE TABLE IF NOT EXISTS ludaro_manager_interactions (
     id INT AUTO_INCREMENT PRIMARY KEY,
     interaction_name VARCHAR(255) NOT NULL
 );]]
 
 -- Check if table ludaro_manager_armories exists, if not create tables
 checkquery = [[ SELECT * FROM information_schema.tables WHERE table_name = 'ludaro_manager_armories' LIMIT 1; ]]
 
 MySQL.Async.fetchAll(checkquery, {}, function(result)
     if result == nil or next(result) == nil then
         MySQL.Async.execute(query1, {}, function()
             print("Created table ludaro_manager_armories")
         end)
         MySQL.Async.execute(query2, {}, function()
             print("Added columns ludaro_manager_info and interactions to jobs table")
         end)
         MySQL.Async.execute(query3, {}, function()
             print("Created table ludaro_manager_interactions")
         end)
     end 
 end)
 end)
 