--[[
    jobmanagement_zones_npcs_getJobandGrade
    Retrieves the job and grade of a player via a callback.

    @param source (number, optional): The source identifier of the player. If not provided, defaults to the current player.
    
    @return table: Returns a table containing the job and grade data of the player.
]]
function jobmanagement_zones_npcs_getJobandGrade(source)
    -- Use a callback to retrieve job and grade information from the server
    return lib.callback.await("ludaro_manager:getJobandGrade", false, source)
end

--[[
    jobmanagement_zones_getDuty
    Retrieves the duty status of the player via a callback.

    @return boolean: Returns true if the player is on duty, false otherwise.
]]
function jobmanagement_zones_getDuty()
    -- Use a callback to retrieve the player's duty status from the server
    return lib.callback.await("ludaro_manager:getDuty", false)
end
