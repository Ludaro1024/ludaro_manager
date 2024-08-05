-- society_management_callback_getSocietys
-- Retrieves the list of societies via a callback
-- @return table: Returns the list of societies
function society_management_callback_getSocietys()
    return lib.callback.await("ludaro_manager:getSocieties", false)
end

-- society_management_callback_deleteSociety
-- Deletes a society via a callback
-- @param society: The society to be deleted
-- @return boolean: Returns true if the deletion was successful, false otherwise
function society_management_callback_deleteSociety(society)
    return lib.callback.await("ludaro_manager:deleteSociety", false, society)
end

-- society_management_callback_addSociety
-- Adds a new society via a callback
-- @param society: The society to be added
-- @return boolean: Returns true if the addition was successful, false otherwise
function society_management_callback_addSociety(society)
    return lib.callback.await("ludaro_manager:addSociety", false, society)
end

-- society_managment_callback_editSociety
-- Edits an existing society via a callback
-- @param society: The society to be edited
-- @return boolean: Returns true if the edit was successful, false otherwise
function society_managment_callback_editSociety(society)
    return lib.callback.await("ludaro_manager:editSociety", false, society)
end

-- society_management_callback_withdrawSocietyMoney
-- Withdraws money from a society via a callback
-- @param society: The society to withdraw money from
-- @param amount: The amount of money to withdraw
-- @return boolean: Returns true if the withdrawal was successful, false otherwise
function society_management_callback_withdrawSocietyMoney(society, amount)
    return lib.callback.await("ludaro_manager:withdrawSocietyMoney", false, society, amount)
end

-- society_management_callback_depositSocietyMoney
-- Deposits money into a society via a callback
-- @param society: The society to deposit money into
-- @param amount: The amount of money to deposit
-- @return boolean: Returns true if the deposit was successful, false otherwise
function society_management_callback_depositSocietyMoney(society, amount)
    return lib.callback.await("ludaro_manager:depositSocietyMoney", false, society, amount)
end

-- society_management_callback_setSocietyMoney
-- Sets the amount of money in a society via a callback
-- @param society: The society to set the money for
-- @param amount: The amount of money to set
-- @return boolean: Returns true if the operation was successful, false otherwise
function society_management_callback_setSocietyMoney(society, amount)
    return lib.callback.await("ludaro_manager:setSocietyMoney", false, society, amount)
end
