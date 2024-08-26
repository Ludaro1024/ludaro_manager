function jobmenu_bossmenu_getBossMenuData(jobName)
    -- get society money
    if society_management_callback_doesSocietyExist(jobName) then
        society = { name = "society_" .. jobName, label = jobName }
            cb = society_management_callback_addSociety(society)
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

   
    return data
end

function jobmenu_bossmenu_setGradeSalary(jobName, grade, salary)
    MySQL.Async.execute("UPDATE job_grades SET salary = @salary WHERE job_name = @job_name AND grade = @grade", {['@job_name'] = jobName, ['@grade'] = grade, ['@salary'] = salary})
    return true
end

function jobmenu_bossmenu_hirePlayer(jobName, player)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(player)
      
        if xPlayer then
      

        xPlayer.setJob(jobName, 0)

          fullname = xPlayer.getName()
            firstname = fullname:match("([^%s]+)")
            lastname = fullname:match("%s([^%s]+)")
        return { jobName = jobName, employee = {job_grade = 0, identifier = player, firstname = firstname, lastname = lastname} }
        end
    end
    return false
end