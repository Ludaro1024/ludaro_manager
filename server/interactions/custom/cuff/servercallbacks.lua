--[[
    ludaro_manager:getCuffStatus

    This callback checks whether a player is currently cuffed.

    @param source (number): The server ID of the player requesting the status.
    @param id (number): The server ID of the player whose cuff status is being checked.

    @return boolean: Returns true if the player is cuffed, false otherwise.
]]
lib.callback.register("ludaro_manager:getCuffStatus", function(source, id)
    Debug(3, "Callback received to check cuff status for player: " .. id)
    return IsCuffed(id)
end)
