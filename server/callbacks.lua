--[[
    Callback Registration for Checking Permissions

    This callback checks whether a player is allowed to perform a certain action.
    
    @param source (number): The source identifier of the player.
    
    @return boolean: Returns true if the player is allowed, false otherwise.
]]
lib.callback.register("ludaro_manager:getAllowed", function(source)
    Debug(3, string.format("Checking if player %d is allowed.", source))
    local allowed = isAllowed(source)
    
    if allowed then
        Debug(2, string.format("Player %d is allowed.", source))
    else
        Debug(2, string.format("Player %d is not allowed.", source))
    end
    
    return allowed
end)
