function removeIndexIfPresent(tbl, index)
    for i, v in ipairs(tbl) do
        if v == index then
            table.remove(tbl, i)
            return tbl
        end
    end
end

function getEmployees(jobName)
    local employees = {}
    local onlineIdentifiers = {}

    -- Get online players with the job
    for k, v in pairs(ESX.GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(v)
        if xPlayer.job.name == jobName then
            fullname = xPlayer.getName()
            firstname = fullname:match("([^%s]+)")
            lastname = fullname:match("%s([^%s]+)")
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

    -- Fetch offline players with the job from the database
    local offlinePlayers = MySQL.Sync.fetchAll('SELECT firstname, lastname, job_grade, job, identifier FROM users WHERE job = @job', {
        ['@job'] = jobName
    })

    -- Add offline players to the employees table if they are not online
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
