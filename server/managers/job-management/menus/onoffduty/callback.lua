--[[
    Callback Registration for Getting Duty Status

    This callback retrieves the on-duty status of the player.
    
    @param source (number): The source identifier of the player.
    
    @return boolean: Returns true if the player is on duty, false otherwise.
]]
lib.callback.register("ludaro_manager:getDuty", function(source)
    return job_management_onoffduty_getDuty(source)
end)
