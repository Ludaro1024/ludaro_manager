--[[
    jobmenu_bossmenu_getBossMenuData
    Retrieves the data needed for the boss menu, including society information, job grades, and employees.

    This function first checks if a society exists for the given job name. If it exists, it retrieves the society information.
    If not, it creates a new society. It then fetches the job grades and employees associated with the job name from the database.

    @param jobName (string): The name of the job for which to retrieve boss menu data.
    
    @return table: Returns a table containing society information, job grades, and employee data.
]]
function jobmenu_bossmenu_getBossMenuData(jobName)
    local society

    -- Check if the society exists and retrieve or create it
    if society_management_callback_doesSocietyExist(jobName) then
        society = { name = "society_" .. jobName, label = jobName }
        society_management_callback_addSociety(society)
        society = getSociety(jobName)
    else
        society = getSociety(jobName)
    end

    -- Fetch job grades and employees from the database
    local grades = MySQL.query.await("SELECT * FROM job_grades WHERE job_name = @job_name", {['@job_name'] = jobName})
    local employees = getEmployees(jobName)
    
    -- Prepare the data to be returned
    local data = {
        society = society,
        grades = grades,
        employees = employees
    }

    return data
end

--[[
    jobmenu_bossmenu_setGradeSalary
    Updates the salary for a specific grade within a job.

    This function updates the salary for a specified grade within the given job name in the database.

    @param jobName (string): The name of the job for which to set the salary.
    @param grade (number): The grade level within the job.
    @param salary (number): The salary to be set for the specified grade.
    
    @return boolean: Returns true after the salary has been successfully updated.
]]
function jobmenu_bossmenu_setGradeSalary(jobName, grade, salary)
    -- Update the salary for the specified grade in the database
    MySQL.Async.execute("UPDATE job_grades SET salary = @salary WHERE job_name = @job_name AND grade = @grade", {
        ['@job_name'] = jobName, 
        ['@grade'] = grade, 
        ['@salary'] = salary
    })
    return true
end

--[[
    jobmenu_bossmenu_hirePlayer
    Hires a player into the specified job and sets their job grade to 0.

    This function sets the job of the specified player (by ID) to the given job name with an initial grade of 0.
    It also extracts the player's first and last name from their full name and returns relevant information.

    @param jobName (string): The name of the job to hire the player into.
    @param player (number): The ID of the player to be hired.
    
    @return table|boolean: Returns a table containing the job name and employee information if successful, otherwise returns false.
]]
function jobmenu_bossmenu_hirePlayer(jobName, player)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(player)

        if xPlayer then
            -- Set the player's job to the specified job name with an initial grade of 0
            xPlayer.setJob(jobName, 0)

            -- Extract the player's first and last name from their full name
            local fullname = xPlayer.getName()
            local firstname = fullname:match("([^%s]+)")
            local lastname = fullname:match("%s([^%s]+)")

            -- Return the job name and employee information
            return { 
                jobName = jobName, 
                employee = {
                    job_grade = 0, 
                    identifier = player, 
                    firstname = firstname, 
                    lastname = lastname
                } 
            }
        end
    end
    return false
end
