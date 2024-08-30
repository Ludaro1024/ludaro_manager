--[[
    Callback Registrations for Boss Menu and Job Management

    These callbacks handle various operations related to the boss menu and job management,
    such as retrieving boss menu data, getting job and grade information, setting grade salaries,
    and hiring players.
]]

--[[
    Retrieves boss menu data for a specified job.
    
    @param source (number): The source identifier of the player (optional).
    @param jobName (string): The name of the job to retrieve boss menu data for.
    
    @return table: Returns a table containing the boss menu data for the specified job.
]]
lib.callback.register("getBossMenuData", function(source, jobName)
    return jobmenu_bossmenu_getBossMenuData(jobName)
end)

--[[
    Retrieves the job and grade for a player or another player specified by ID.
    
    @param source (number): The source identifier of the player making the request (optional).
    @param otherplayerid (number): The identifier of the player whose job and grade are to be retrieved.
    
    @return string, number: Returns the job and grade of the specified player.
]]
lib.callback.register("ludaro_manager:getJobandGrade", function(source, otherplayerid)
    return getJob(source, otherplayerid), getGrade(source, otherplayerid)
end)

--[[
    Sets the salary for a specific grade within a job.
    
    @param source (number): The source identifier of the player (optional).
    @param jobName (string): The name of the job where the grade salary will be set.
    @param grade (number): The grade level within the job.
    @param salary (number): The salary to be set for the specified grade.
    
    @return boolean: Returns true if the salary was successfully set, false otherwise.
]]
lib.callback.register("ludaro_manager:setGradeSalary", function(source, jobName, grade, salary)
    return jobmenu_bossmenu_setGradeSalary(jobName, grade, salary)
end)

--[[
    Hires a player into a specified job.
    
    @param source (number): The source identifier of the player (optional).
    @param jobName (string): The name of the job to hire the player into.
    @param player (table): A table containing the player data to be hired.
    
    @return boolean: Returns true if the player was successfully hired, false otherwise.
]]
lib.callback.register("ludaro_manager:hirePlayer", function(source, jobName, player)
    return jobmenu_bossmenu_hirePlayer(jobName, player)
end)
