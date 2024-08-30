--[[
    Callback Registrations for User Management

    These callbacks handle operations related to retrieving and updating user data.
]]

--[[
    Retrieves a list of users from the database.

    @return table: Returns a table containing all users and their associated data.
]]
lib.callback.register("ludaro_manager:getUsers", function()
    return user_management_getUsers()
end)

--[[
    Updates a user's data within the framework.

    This callback updates user data (e.g., group, job, name) within the ESX framework, and falls back to the database if the user is offline.

    @param source (number): The source identifier of the player (optional).
    @param user (table): A table containing the user's data to be updated.
    
    @return boolean: Returns true if the user was successfully updated, false otherwise.
]]
lib.callback.register("ludaro_manager:updateUser", function(source, user)
    return user_management_updateUserInFramework(user)
end)

--[[
    Updates a user's data in the database.

    This callback directly updates user data in the SQL database.

    @param source (number): The source identifier of the player (optional).
    @param user (table): A table containing the user's data to be updated.
    
    @return boolean: Returns true if the user was successfully updated, false otherwise.
]]
lib.callback.register("ludaro_manager:updateUserSQL", function(source, user)
    return user_management_updateUserSQL(user)
end)
