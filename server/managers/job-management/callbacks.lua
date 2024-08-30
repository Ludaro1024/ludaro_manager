--[[
    Callback Registrations for ludaro_manager

    These callbacks handle various operations related to job management,
    such as retrieving, saving, adding, and deleting jobs, grades, interactions, vehicles,
    armories, clothing, stashes, and shops. Each callback calls the corresponding function
    to perform the required operation.
]]

-- Job Management Callbacks

--[[
    Retrieves the list of all jobs.
    @param source (number): The source identifier of the player (optional).
    @return table: A table containing all job data.
]]
lib.callback.register('ludaro_manager:getJobs', function(source)
   return job_management_sql_GetJobs()
end)

--[[
   Saves a job to the database.
   @param source (number): The source identifier of the player (optional).
   @param job (table): A table containing job data to be saved.
   @return boolean: Returns true if the job was saved successfully, false otherwise.
]]
lib.callback.register('ludaro_manager:saveJob', function(source, job)
   return job_management_callback_saveJob(job)
end)

--[[
   Deletes a job from the database.
   @param source (number): The source identifier of the player (optional).
   @param jobId (number): The ID of the job to be deleted.
   @return boolean: Returns true if the job was deleted successfully, false otherwise.
]]
lib.callback.register('ludaro_manager:deleteJob', function(source, jobId)
   return job_management_callback_deleteJob(jobId)
end)

--[[
   Adds a new job to the database.
   @param source (number): The source identifier of the player (optional).
   @param job (table): A table containing job data to be added.
   @return boolean: Returns true if the job was added successfully, false otherwise.
]]
lib.callback.register('ludaro_manager:addJob', function(source, job)
   return job_management_callback_addJob(job)
end)

-- Grade Management Callbacks

--[[
   Adds a new grade to a job.
   @param source (number): The source identifier of the player (optional).
   @param jobName (string): The name of the job to which the grade is added.
   @param gradeName (string): The name of the grade to be added.
   @param gradeLabel (string): The label of the grade to be added.
   @param salary (number): The salary associated with the grade.
   @return boolean: Returns true if the grade was added successfully, false otherwise.
]]
lib.callback.register('ludaro_manager:addGrade', function(source, jobName, gradeName, gradeLabel, salary)
   return job_management_callback_addGrade(jobName, gradeName, gradeLabel, salary)
end)

--[[
   Deletes a grade from a job.
   @param source (number): The source identifier of the player (optional).
   @param jobName (string): The name of the job from which the grade is to be deleted.
   @param index (number): The index of the grade to be deleted.
   @return boolean: Returns true if the grade was deleted successfully, false otherwise.
]]
lib.callback.register('ludaro_manager:deleteGrade', function(source, jobName, index)
   return job_management_callback_deleteGrade(jobName, index)
end)

--[[
   Retrieves all grades from the database.
   @param source (number): The source identifier of the player (optional).
   @return table: A table containing all grade data.
]]
lib.callback.register('ludaro_manager:getAllGrades', function(source)
   return job_management_sql_GetAllGrades()
end)

--[[
   Saves a grade to the database.
   @param source (number): The source identifier of the player (optional).
   @param jobName (string): The name of the job to which the grade belongs.
   @param grade (table): A table containing the grade data to be saved.
   @return boolean: Returns true if the grade was saved successfully, false otherwise.
]]
lib.callback.register('ludaro_manager:saveGrade', function(source, jobName, grade)
   return job_management_sql_saveGrade(jobName, grade)
end)

-- Interaction Management Callbacks

--[[
   Retrieves all interactions from the database.
   @param source (number): The source identifier of the player (optional).
   @return table: A table containing all interaction data.
]]
lib.callback.register('ludaro_manager:getInteractions', function(source)
   return job_management_sql_getAllInteractions()
end)

--[[
   Adds an interaction to a job.
   @param source (number): The source identifier of the player (optional).
   @param jobName (string): The name of the job to which the interaction is added.
   @param interaction (table): A table containing the interaction data to be added.
   @return boolean: Returns true if the interaction was added successfully, false otherwise.
]]
lib.callback.register('ludaro_manager:addInteractionfromjob', function(source, jobName, interaction)
   return addInteractiontoJob(jobName, interaction)
end)

--[[
   Deletes an interaction from a job.
   @param source (number): The source identifier of the player (optional).
   @param jobName (string): The name of the job from which the interaction is to be deleted.
   @param index (number): The index of the interaction to be deleted.
   @return boolean: Returns true if the interaction was deleted successfully, false otherwise.
]]
lib.callback.register('ludaro_manager:deleteInteractionfromjob', function(source, jobName, index)
   return job_management_sql_removeInteractionfromjob(jobName, index)
end)

-- Vehicle Management Callback

--[[
   Deletes a vehicle from a job's list.
   @param source (number): The source identifier of the player (optional).
   @param jobName (string): The name of the job from which the vehicle is to be deleted.
   @param index (number): The index of the vehicle to be deleted.
   @return boolean: Returns true if the vehicle was deleted successfully, false otherwise.
]]
lib.callback.register('ludaro_manager:deleteVehicle', function(source, jobName, index)
   return job_management_callback_deleteVehicle(jobName, index)
end)

-- -- Armory Management Callback

-- --[[
--    Saves armory data for a job.
--    @param source (number): The source identifier of the player (optional).
--    @param jobName (string): The name of the job to which the armory data belongs.
--    @param armory (table): A table containing the armory data to be saved.
--    @return boolean: Returns true if the armory data was saved successfully, false otherwise.
-- ]]
-- lib.callback.register('ludaro_manager:saveArmory', function(source, jobName, armory)
--    return job_management_callback_saveArmory(jobName, armory)
-- end)

-- Clothing Management Callback

--[[
   Saves clothing data for a job.
   @param source (number): The source identifier of the player (optional).
   @param jobName (string): The name of the job to which the clothing data belongs.
   @param clothing (table): A table containing the clothing data to be saved.
   @return boolean: Returns true if the clothing data was saved successfully, false otherwise.
]]
lib.callback.register('ludaro_manager:saveClothing', function(source, jobName, clothing)
   return job_management_callback_saveClothing(jobName, clothing)
end)

-- Stash Management Callback

--[[
   Saves stash data for a job.
   @param source (number): The source identifier of the player (optional).
   @param jobName (string): The name of the job to which the stash data belongs.
   @param stashes (table): A table containing the stash data to be saved.
   @return boolean: Returns true if the stash data was saved successfully, false otherwise.
]]
lib.callback.register('ludaro_manager:saveStashes', function(source, jobName, stashes)
   return job_management_callback_saveStashes(jobName, stashes)
end)

-- -- Shop Management Callback

-- --[[
--    Saves shop data for a job.
--    @param source (number): The source identifier of the player (optional).
--    @param jobName (string): The name of the job to which the shop data belongs.
--    @param shop (table): A table containing the shop data to be saved.
--    @return boolean: Returns true if the shop data was saved successfully, false otherwise.
-- ]]
-- lib.callback.register('ludaro_manager:saveShop', function(source, jobName, shop)
--    return job_management_callback_saveShop(jobName, shop)
-- end)

-- Boss Menu and Employee Management Callbacks

--[[
   Saves boss menu data.
   @param source (number): The source identifier of the player (optional).
   @param data (table): A table containing the boss menu data to be saved.
   @return boolean: Returns true if the boss menu data was saved successfully, false otherwise.
]]
lib.callback.register("ludaro_manager:saveBossMenu", function(source, data)
   return job_management_callback_saveBossMenu(data)
end)

--[[
   Saves employee data for a job.
   @param source (number): The source identifier of the player (optional).
   @param data (table): A table containing the employee data to be saved.
   @return boolean: Returns true if the employee data was saved successfully, false otherwise.
]]
lib.callback.register("ludaro_manager:saveEmployee", function(source, data)
   return job_management_callback_saveEmployee(data)
end)

-- NPC Data Management Callback

--[[
   Retrieves NPC data.
   @param source (number): The source identifier of the player (optional).
   @return table: A table containing NPC data.
]]
lib.callback.register("ludaro_manager:getNPCData", function(source, data)
   return jobmanagement_zones_npcs_getNPCData()
end)

-- Player Name Retrieval Callback

--[[
   Retrieves the player's name based on their identifier.
   @param source (number): The source identifier of the player (optional).
   @param id (string): The identifier of the player whose name is to be retrieved.
   @return string: Returns the player's name.
]]
lib.callback.register('ludaro_manager:getName', function(source, id)
   return framework_getPlayerName(id)
end)
