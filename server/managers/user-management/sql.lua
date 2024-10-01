--[[
    Retrieves a list of users from the database.

    This function fetches all users from the `users` table, along with their associated data,
    such as accounts, job information, personal details, and more.

    @return table: Returns a table containing all users and their associated data.
]]
function user_management_getUsers()
    local query = [[
        SELECT
            u.identifier,
            u.accounts,
            u.group,
            u.job,
            u.job_grade,
            JSON_EXTRACT(u.metadata, '$.armor') AS armor,
            JSON_EXTRACT(u.metadata, '$.health') AS health,
            u.firstname,
            u.lastname,
            u.dateofbirth,
            u.sex,
            u.height,
            u.created_at,
            u.last_seen,
            u.phone_number
        FROM
            users u
        ORDER BY
            u.identifier;
    ]]
    local users = MySQL.query.await(query)
    return users
end

--[[
    Updates a user's basic information in the SQL database.

    This function updates the `dateofbirth`, `sex`, and `height` fields for a specific user in the `users` table.

    @param data (table): A table containing the user's data to be updated.
    
    @return boolean: Returns true if the user was successfully updated, false otherwise.
]]
function user_management_updateUserSQL(data)
    local query = [[
        UPDATE
            users
        SET
            `dateofbirth` = @dateofbirth,
            `sex` = @sex,
            `height` = @height
        WHERE
            identifier = @identifier;
    ]]
    local affectedRows = MySQL.query.await(query, {
        ['@dateofbirth'] = data.dateofbirth,
        ['@sex'] = data.sex,
        ['@height'] = data.height,
        ['@identifier'] = data.identifier
    })
    return #affectedRows > 0
end
