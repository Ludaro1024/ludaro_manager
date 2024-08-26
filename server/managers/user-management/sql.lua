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

