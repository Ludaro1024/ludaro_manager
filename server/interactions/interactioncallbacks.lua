--[[
    ludaro_manager:getInteractionsFromPlayer

    This callback is used to get the interactions available to a player based on their job.

    @param source (number): The server ID of the player whose interactions are being retrieved.

    @return table: Returns a table containing the interactions available to the player.
]]
lib.callback.register("ludaro_manager:getInteractionsFromPlayer", function(source)
    Debug(3, "Retrieving interactions for player ID: " .. source)
    local job = framework_getJob(source)
    local interactions = interactions_getInteractionsFromPlayer(source)
    Debug(3, "Interactions retrieved for player ID: " .. source .. " Job: " .. job)
    return interactions
end)
