--[[
    ludaro_manager:getInteractionsFromPlayer

    This callback is used to get the interactions available to a player based on their job.

    @param source (number): The server ID of the player whose interactions are being retrieved.

    @return table: Returns a table containing the interactions available to the player.
]]
function interactions_getInteractionsFromPlayer()
    return lib.callback.await("ludaro_manager:getInteractionsFromPlayer", false)
end