function getBossMenuData(jobName)
    -- get society money
    
    local society = getSociety(jobName)
    if society == nil or next(society) == nil then
        society = { name = "society_" .. jobName, label = jobName }
            cb = addSociety(society)
            society = getSociety(jobName)
        end
    local grades = MySQL.query.await("SELECT * FROM job_grades WHERE job_name = @job_name", {['@job_name'] = jobName})
    local employees = getEmployees(jobName)
    local data = {
        society = society,
        grades = grades,
        employees = employees
    }

   
    return data
end

function setGradeSalary(jobName, grade, salary)
    print(jobName, grade, salary)
    MySQL.Async.execute("UPDATE job_grades SET salary = @salary WHERE job_name = @job_name AND grade = @grade", {['@job_name'] = jobName, ['@grade'] = grade, ['@salary'] = salary})
    return true
end