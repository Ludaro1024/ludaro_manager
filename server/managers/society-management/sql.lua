--[[
    Retrieves all societies from the database.

    This function fetches all societies from the `addon_account` table where `shared = 1`.
    It also retrieves the associated money from the `addon_account_data` table.

    @return table: A table containing all societies and their respective money.
]]
function society_management_callbacks_getSocieties()
    if ESX then
        local query = [[
            SELECT
                a.name,
                a.label,
                COALESCE(ad.money, 0) AS money
            FROM
                addon_account a
            LEFT JOIN
                addon_account_data ad ON a.name = ad.account_name
            WHERE
                a.shared = 1;
        ]]
        local societies = MySQL.query.await(query)
        return societies
    end
end

--[[
    Retrieves a specific society based on the job name.

    This function fetches the society corresponding to the given job name from the `addon_account` table.

    @param jobName (string): The name of the job for which to retrieve the society.
    
    @return table: A table containing the society's information, or nil if not found.
]]
function getSociety(jobName)
    local jobname = string.find(jobName, "society_") and jobName or "society_" .. jobName

    if ESX then
        local query = [[
            SELECT
                a.name,
                a.label,
                COALESCE(ad.money, 0) AS money
            FROM
                addon_account a
            LEFT JOIN
                addon_account_data ad ON a.name = ad.account_name
            WHERE
                a.name = @name AND a.shared = 1 LIMIT 1;
        ]]
        local society = MySQL.query.await(query, { ['@name'] = jobname })
        return society[1]
    end
end

--[[
    Deletes a specified society from the database.

    This function deletes the society from the `addon_account`, `addon_account_data`, and `addon_inventory` tables.

    @param society (table): The society to be deleted.
    
    @return boolean: Returns true if the society was successfully deleted, false otherwise.
]]
function society_management_callback_deleteSociety(society)
    if ESX and society then
        local query = [[DELETE FROM addon_account WHERE name = @name;]]
        MySQL.query.await(query, { ['@name'] = society.name })
        
        query = [[DELETE FROM addon_account_data WHERE account_name = @name;]]
        MySQL.query.await(query, { ['@name'] = society.name })
        
        query = [[DELETE FROM addon_inventory WHERE owner = @name;]]
        MySQL.query.await(query, { ['@name'] = society.name })
        
        return true
    end
end

--[[
    Adds a new society to the database.

    This function inserts a new society into the `addon_account` and `addon_account_data` tables.

    @param society (table): A table containing the society's name and label.
    
    @return table: Returns the newly created society.
]]
function society_management_callback_addSociety(society)
    if ESX and not society_management_callback_doesSocietyExist(society) then
        local query = [[INSERT INTO addon_account (name, label, shared) VALUES (@name, @label, 1);]]
        MySQL.query.await(query, { ['@name'] = society.name, ['@label'] = society.label })
        
        query = [[INSERT INTO addon_account_data (account_name, money) VALUES (@name, 0);]]
        MySQL.query.await(query, { ['@name'] = society.name })
        
        return getSociety(society.name)
    end
end

--[[
    Edits an existing society in the database.

    This function updates the label of an existing society in the `addon_account` table.

    @param society (table): A table containing the society's name and new label.
    
    @return boolean: Returns true if the society was successfully edited, false otherwise.
]]
function society_managment_callback_editSociety(society)
    if ESX and next(society) and society_management_callback_doesSocietyExist(society) then
        local query = [[UPDATE addon_account SET label = @label WHERE name = @name;]]
        MySQL.query.await(query, { ['@name'] = society.name, ['@label'] = society.label })
        return true
    end
end

--[[
    Withdraws money from a society's account.

    This function removes the specified amount from the society's balance and adds it to the player's balance.

    @param society (table): The society from which to withdraw money.
    @param amount (number): The amount of money to withdraw.
    @param source (number): The source identifier of the player making the withdrawal.
    
    @return boolean: Returns true if the withdrawal was successful, false otherwise.
]]
function society_management_callback_withdrawSocietyMoney(society, amount, source)
    if ESX and society_management_callback_doesSocietyExist(society) and society_management_framework_hasEnoughMoney(source, amount) then
        society_management_framework_addMoney(source, amount)

        local query = [[UPDATE addon_account_data SET money = money - @amount WHERE account_name = @name;]]
        MySQL.query.await(query, { ['@name'] = society.name, ['@amount'] = amount })
        return true
    else
        return false
    end
end

--[[
    Deposits money into a society's account.

    This function removes the specified amount from the player's balance and adds it to the society's balance.

    @param society (table): The society into which money is to be deposited.
    @param amount (number): The amount of money to deposit.
    @param source (number): The source identifier of the player making the deposit.
    
    @return boolean: Returns true if the deposit was successful, false otherwise.
]]
function society_management_callback_depositSocietyMoney(society, amount, source)
    if ESX and society_management_callback_doesSocietyExist(society) and society_management_framework_hasEnoughMoney(source, amount) then
        society_management_framework_withdrawMoney(source, amount)
        
        local query = [[UPDATE addon_account_data SET money = money + @amount WHERE account_name = @name;]]
        MySQL.query.await(query, { ['@name'] = society.name, ['@amount'] = amount })
        return true
    else
        showNotification(source, Locale("not_enough_money"))
        return false
    end
end

--[[
    Sets the amount of money in a society's account.

    This function sets the society's balance to a specific amount in the `addon_account_data` table.

    @param society (table|string): The society for which to set the balance. Can be a table or a string.
    @param amount (number): The amount of money to set as the society's balance.
    
    @return boolean: Returns true if the society's balance was successfully set, false otherwise.
]]
function society_management_callback_setSocietyMoney(society, amount)
    if type(society) == "table" then
        if ESX and next(society) and society_management_callback_doesSocietyExist(society.name) then
            local query = [[UPDATE addon_account_data SET money = @amount WHERE account_name = @name;]]
            MySQL.query.await(query, { ['@name'] = society.name, ['@amount'] = amount })
            return true
        end
    elseif type(society) == "string" then
        if ESX and society_management_callback_doesSocietyExist(society) then
            local query = [[UPDATE addon_account_data SET money = @amount WHERE account_name = @name;]]
            MySQL.query.await(query, { ['@name'] = society, ['@amount'] = amount })
            return true
        end
    end
end

--[[
    Checks if a society exists in the database.

    This function checks if a society exists in the `addon_account` table.

    @param society (table|string): The society to check for existence. Can be a table or a string.
    
    @return boolean: Returns true if the society exists, false otherwise.
]]
function society_management_callback_doesSocietyExist(society)
    local societyName

    if type(society) == "table" then
        societyName = society.name
    elseif type(society) == "string" then
        societyName = string.find(society, "society_") and society or "society_" .. society
    else
        return false
    end

    if ESX then
        local query = [[SELECT name FROM addon_account WHERE name = @name;]]
        local result = MySQL.query.await(query, { ['@name'] = societyName })
        return next(result) and true or false
    end
    return false
end
