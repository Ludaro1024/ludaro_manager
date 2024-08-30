--[[
    removeIndexIfPresent
    Removes an element from a table if it matches the specified index.

    This function iterates through the provided table and removes the first occurrence
    of the specified index if found.

    @param tbl (table): The table to search through.
    @param index (any): The value to search for and remove from the table.

    @return table: The modified table with the element removed, if found.
]]
function removeIndexIfPresent(tbl, index)
    for i, v in ipairs(tbl) do
        if v == index then
            table.remove(tbl, i)
            return tbl
        end
    end
    return tbl
end

--[[
    getEmployees
    Retrieves a list of employees for a specified job, including both online and offline players.

    This function first gathers all online players with the specified job, then it fetches
    offline players from the database who have the same job but are not currently online.
    It combines these into a single list of employees.

    @param jobName (string): The name of the job to retrieve employees for.

    @return table: A table containing employee data (identifier, firstname, lastname, job_grade, job).
]]
function getEmployees(jobName)
    local employees = {}
    local onlineIdentifiers = {}

    -- Get online players with the specified job
    for _, playerId in pairs(ESX.GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer then
            if xPlayer.job.name == jobName then
                local fullname = xPlayer.getName()
                local firstname = fullname:match("([^%s]+)")
                local lastname = fullname:match("%s([^%s]+)")

                table.insert(employees, {
                    identifier = xPlayer.identifier,
                    firstname = firstname,
                    lastname = lastname,
                    job_grade = xPlayer.job.grade,
                    job = xPlayer.job.name
                })

                table.insert(onlineIdentifiers, xPlayer.identifier)
            end
        end
    end

    -- Fetch offline players with the specified job from the database
    local offlinePlayers = MySQL.Sync.fetchAll(
        'SELECT firstname, lastname, job_grade, job, identifier FROM users WHERE job = @job',
        { ['@job'] = jobName }
    )

    -- Add offline players to the employees table if they are not currently online
    for _, v in pairs(offlinePlayers) do
        local isOnline = false

        for _, identifier in ipairs(onlineIdentifiers) do
            if v.identifier == identifier then
                isOnline = true
                break
            end
        end

        if not isOnline then
            table.insert(employees, {
                identifier = v.identifier,
                firstname = v.firstname,
                lastname = v.lastname,
                job_grade = v.job_grade,
                job = v.job
            })
        end
    end

    return employees
end
