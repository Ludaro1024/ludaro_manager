function removeIndexIfPresent(tbl, index)
    for i, v in ipairs(tbl) do
        print(v, index)
        if v == index then
            table.remove(tbl, i)
            return tbl
        end
    end
end
-- TODO: DOBULE CHECK
function getEmployees(jobName)
    local employees = {}
    for k, v in pairs(ESX.GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(v)
        if xPlayer.job.name == jobName then
            fullname = xPlayer.getName()
            firstname = fullname:match("([^%s]+)")
            lastname = fullname:match("%s([^%s]+)")
            jobNamee = xPlayer.getJob().name
            grade = xPlayer.getJob().grade
            table.insert(employees, {
                identifier = xPlayer.identifier,
                firstname = firstname,
                lastname = lastname,
                job_grade = grade,
                job = jobNamee
            })
        end
    end
    -- save all idenetifiers from all online players in a table and for everyone who isnt online, get it from the database
    local identifiers = {}
    for k, v in pairs(ESX.GetExtendedPlayers()) do
        table.insert(identifiers, v.getIdentifier())
    end
    -- get all users from the databse that dontn match the identifiers
    print(ESX.DumpTable())
    restfromdatabase = MySQL.Sync.fetchAll('SELECT firstname, lastname, job_grade, job, identifier FROM users WHERE job = @job AND identifier NOT IN (@identifiers)', {
        ['@job'] = jobName,
        ['@identifiers'] = table.concat(identifiers, ',')
    })

   -- merge the two tables
    for k, v in pairs(restfromdatabase) do
        table.insert(employees, v)
    end


    return employees
end