--[[
    framework_getJob

    This function retrieves the job name of a player based on their server ID.

    @param source (number): The server ID of the player whose job is being retrieved.

    @return string|nil: Returns the job name if the player is found, or nil if the player is not found.
]]
function framework_getJob(source)
    if ESX then
        xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            Debug(3, "Retrieved job for player ID: " .. source .. " Job: " .. xPlayer.job.name)
            return xPlayer.job.name
        else
            Debug(2, "Player not found for job retrieval. Player ID: " .. source)
        end
    else
        Debug(1, "ESX framework is not initialized.")
    end
    return nil
end
