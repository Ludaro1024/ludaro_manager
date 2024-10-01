--[[
    Callback Registrations for Garage Management

    These callbacks handle operations related to vehicle parking and retrieval in a garage,
    as well as checking vehicle ownership.
]]

--[[
    Retrieves garage data (shared and personal vehicles) for the player based on their job.
    
    @param source (number): The source identifier of the player (optional).
    
    @return table: Returns shared and personal vehicles associated with the player's job.
]]
lib.callback.register("ludaro_manager:getGarageData", function(source)
    return getGarageData(source, framework_getJob(source))
end)

--[[
    Parks a vehicle into the garage, marking it as stored.
    
    @param source (number): The source identifier of the player.
    @param vehicle (table): The vehicle data to be stored.
    
    @return boolean: Returns true if the vehicle was successfully parked, false otherwise.
]]
lib.callback.register("ludaro_manager:parkin", function(source, vehicle)
    return parkin(source, vehicle)
end)

--[[
    Retrieves a vehicle from the garage, marking it as not stored.
    
    @param source (number): The source identifier of the player.
    @param vehicle (table): The vehicle data to be retrieved.
    
    @return boolean: Returns true if the vehicle was successfully retrieved, false otherwise.
]]
lib.callback.register("ludaro_manager:parkout", function(source, vehicle)
    return parkout(source, vehicle)
end)

--[[
    Checks if a vehicle with a given plate is owned by the player or their job.
    
    @param source (number): The source identifier of the player.
    @param plate (string): The plate of the vehicle to check ownership for.
    
    @return boolean: Returns true if the vehicle is owned by the player or their job, false otherwise.
]]
lib.callback.register("ludaro_manager:isOwned", function(source, plate)
    return isOwned(source, plate)
end)
