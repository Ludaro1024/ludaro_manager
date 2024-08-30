--[[
    Retrieves interactions associated with a specific job from the database.

    This function queries the database to fetch all interactions related to the provided job name.
    The results are then JSON-encoded and returned.

    @param jobName (string): The name of the job for which to retrieve interactions.
    
    @return string: Returns a JSON-encoded string of interactions for the specified job, or nil if no interactions are found.
]]
function getInteractionsFromJob(jobName)
    -- Fetch interactions from the database for the given job name and JSON-encode the result
    return nil or json.encode(MySQL.Sync.fetchAll("SELECT * FROM ludaro_manager_interactions WHERE job = @job", {['@job'] = jobName}))
end
