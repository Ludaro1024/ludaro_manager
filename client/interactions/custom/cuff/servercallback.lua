--[[
    isPlayerCuffed

    This function checks whether a player is currently cuffed by querying the server.

    @param id (number): The server ID of the player to check cuff status for.
    
    @return boolean: Returns true if the player is cuffed, false otherwise.
]]
function isPlayerCuffed(id)
    Debug(3, "Checking cuff status for player with server ID: " .. id)
    return lib.callback.await("ludaro_manager:getCuffStatus", id)
end
