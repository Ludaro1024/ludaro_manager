function getBossMenuData(jobName)
    -- get society money
    (doesSocietyExist(jobName))
    if doesSocietyExist(jobName) then
        society = { name = "society_" .. jobName, label = jobName }
            cb = addSociety(society)
            society = getSociety(jobName)
    else
        society = getSociety(jobName)
    end
 
 
    local grades = MySQL.query.await("SELECT * FROM job_grades WHERE job_name = @job_name", {['@job_name'] = jobName})
    local employees = getEmployees(jobName)
    local data = {
        society = society,
        grades = grades,
        employees = employees
    }   

    (ESX.DumpTable(data))

   
    return data
end

function setGradeSalary(jobName, grade, salary)
    (jobName, grade, salary)
    MySQL.Async.execute("UPDATE job_grades SET salary = @salary WHERE job_name = @job_name AND grade = @grade", {['@job_name'] = jobName, ['@grade'] = grade, ['@salary'] = salary})
    return true
end

function hirePlayer(jobName, player)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(player)
        (player)
        if xPlayer then
            ("what")

        xPlayer.setJob(jobName, 0)
        (jobName)

          fullname = xPlayer.getName()
            firstname = fullname:match("([^%s]+)")
            lastname = fullname:match("%s([^%s]+)")
        return { jobName = jobName, employee = {job_grade = 0, identifier = player, firstname = firstname, lastname = lastname} }
        end
    end
    return false
end