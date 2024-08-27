

-- ludaro_manager:getInteractionsFromPlayer
-- Used to get the interactions from a player.
-- @param int source The player's server ID.
-- @return table The interactions.
lib.callback.register("ludaro_manager:getInteractionsFromPlayer", function(source)
    job = framework_getJob(source)
    return interactions_getInteractionsFromPlayer(source)
end)
