--[[
    Callback Registrations for Society Management

    These callbacks handle various operations related to managing societies, 
    such as retrieving, adding, editing, deleting societies, and managing society funds.
]]

--[[
    Retrieves the list of societies associated with a specific job.

    @param source (number): The source identifier of the player (optional).
    @param job (string): The name of the job for which to retrieve societies.
    
    @return table: Returns a table containing societies associated with the specified job.
]]
lib.callback.register('ludaro_manager:getSocieties', function(source, job)
    return society_management_callbacks_getSocieties(job)
end)

--[[
    Deletes a specified society.

    @param source (number): The source identifier of the player (optional).
    @param society (string): The name of the society to be deleted.
    
    @return boolean: Returns true if the society was successfully deleted, false otherwise.
]]
lib.callback.register('ludaro_manager:deleteSociety', function(source, society)
    return society_management_callback_deleteSociety(society)
end)

--[[
    Adds a new society.

    @param source (number): The source identifier of the player (optional).
    @param society (table): A table containing the data of the society to be added.
    
    @return boolean: Returns true if the society was successfully added, false otherwise.
]]
lib.callback.register('ludaro_manager:addSociety', function(source, society)
    return society_management_callback_addSociety(society)
end)

--[[
    Edits an existing society.

    @param source (number): The source identifier of the player (optional).
    @param society (table): A table containing the updated data of the society.
    
    @return boolean: Returns true if the society was successfully edited, false otherwise.
]]
lib.callback.register('ludaro_manager:editSociety', function(source, society)
    return society_managment_callback_editSociety(society)
end)

--[[
    Withdraws money from a specified society.

    @param source (number): The source identifier of the player (optional).
    @param society (string): The name of the society from which money is to be withdrawn.
    @param amount (number): The amount of money to withdraw.
    
    @return boolean: Returns true if the money was successfully withdrawn, false otherwise.
]]
lib.callback.register('ludaro_manager:withdrawSocietyMoney', function(source, society, amount)
    return society_management_callback_withdrawSocietyMoney(society, amount, source)
end)

--[[
    Deposits money into a specified society.

    @param source (number): The source identifier of the player (optional).
    @param society (string): The name of the society to which money is to be deposited.
    @param amount (number): The amount of money to deposit.
    
    @return boolean: Returns true if the money was successfully deposited, false otherwise.
]]
lib.callback.register('ludaro_manager:depositSocietyMoney', function(source, society, amount)
    return society_management_callback_depositSocietyMoney(society, amount, source)
end)

--[[
    Sets the amount of money in a specified society's account.

    @param source (number): The source identifier of the player (optional).
    @param society (string): The name of the society.
    @param amount (number): The amount of money to set in the society's account.
    
    @return boolean: Returns true if the society's money was successfully set, false otherwise.
]]
lib.callback.register('ludaro_manager:setSocietyMoney', function(source, society, amount)
    return society_management_callback_setSocietyMoney(society, amount)
end)
