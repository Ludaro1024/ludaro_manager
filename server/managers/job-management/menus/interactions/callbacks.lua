--[[
    Callback Registration for Retrieving Interactions from a Job

    This callback handles the retrieval of interactions associated with a specific job.
]]

--[[
    Retrieves the interactions associated with the specified job.

    @param source (number): The source identifier of the player (optional).
    @param jobName (string): The name of the job for which to retrieve interactions.
    
    @return string: Returns a JSON-encoded string of interactions for the specified job.
]]
lib.callback.register("ludaro_manager:getInteractionsfromJob", function(source, jobName)
    return getInteractionsFromJob(jobName)
end)
