--- Get all jobs from the database.
-- @return table The jobs data.
function job_management_callback_getJobs()
    Debug(3, "Fetching jobs from the database")
    return lib.callback.await("ludaro_manager:getJobs", false)
end

--- Get all interactions from the database.
-- @return table The interactions data.
function job_management_callback_getInteractions()
    Debug(3, "Fetching interactions from the database")
    return lib.callback.await("ludaro_manager:getInteractions", false)
end

--- Add a new job to the database.
-- @param table job The job data.
-- @return boolean, string Success status and job name.
function job_management_callback_addJob(job)
    Debug(3, "Adding new job to the database: " .. ESX.DumpTable(job))
    return lib.callback.await("ludaro_manager:addJob", false, job)
end

--- Save a job to the database.
-- @param table job The job data.
-- @return boolean Success status.
function job_management_callback_saveJob(job)
    Debug(3, "Saving job to the database: " .. ESX.DumpTable(job))
    return lib.callback.await("ludaro_manager:saveJob", false, job)
end

--- Delete a job from the database.
-- @param string jobName The job name.
-- @return boolean Success status.
function job_management_callback_deleteJob(jobName)
    Debug(3, "Deleting job from the database: " .. jobName)
    return lib.callback.await("ludaro_manager:deleteJob", false, jobName)
end

--- Add a grade to a job in the database.
-- @param string jobName The job name.
-- @param string gradeName The grade name.
-- @param string gradeLabel The grade label.
-- @param number Salary The grade salary.
function job_management_callback_addGrade(jobName, gradeName, gradeLabel, Salary)
    Debug(3, "Adding grade to job in the database: " .. jobName .. " - " .. gradeName .. " - " .. gradeLabel .. " - " .. Salary)
    return lib.callback.await("ludaro_manager:addGrade", false, jobName, gradeName, gradeLabel, Salary)
end

--- Delete a grade from a job in the database.
-- @param string jobName The job name.
-- @param number index The grade index.
-- @return boolean Success status.
function job_management_callback_deleteGrade(jobName, index)
    Debug(3, "Deleting grade from job in the database: " .. jobName .. " - Index: " .. index)
    return lib.callback.await("ludaro_manager:deleteGrade", false, jobName, index)
end

--- Add an interaction to a job in the database.
-- @param string jobName The job name.
-- @param string interaction The interaction name.
-- @return boolean Success status.
function job_management_callback_addInteraction(jobName, interaction)
    Debug(3, "Adding interaction to job in the database: " .. jobName .. " - " .. interaction)
    return lib.callback.await("ludaro_manager:addInteractionfromjob", false, jobName, interaction)
end

--- Delete an interaction from a job in the database.
-- @param string jobName The job name.
-- @param number index The interaction index.
-- @return boolean Success status.
function job_management_callback_deleteInteraction(jobName, index)
    Debug(3, "Deleting interaction from job in the database: " .. jobName .. " - Index: " .. index)
    return lib.callback.await("ludaro_manager:deleteInteractionfromjob", false, jobName, index)
end

--- Add a vehicle to a job in the database.
-- @param string jobName The job name.
-- @param table vehicle The vehicle data.
-- @return boolean Success status.
function job_management_callback_addVehicle(jobName, vehicle)
    Debug(3, "Adding vehicle to job in the database: " .. jobName .. " - " .. ESX.DumpTable(vehicle))
    return lib.callback.await("ludaro_manager:addVehicle", false, jobName, vehicle)
end

--- Delete a vehicle from a job in the database.
-- @param string jobName The job name.
-- @param number index The vehicle index.
-- @return boolean Success status.
function job_management_callback_deleteVehicle(jobName, index)
    Debug(3, "Deleting vehicle from job in the database: " .. jobName .. " - Index: " .. index)
    return lib.callback.await("ludaro_manager:deleteVehicle", false, jobName, index)
end

--- Save the armory data for a job.
-- @param string jobName The job name.
-- @param table armory The armory data.
-- @return boolean Success status.
function job_management_callback_saveArmory(jobName, armory)
    Debug(3, "Saving armory data for job: " .. jobName)
    return lib.callback.await("ludaro_manager:saveArmory", false, jobName, armory)
end

--- Save the clothing data for a job.
-- @param string jobName The job name.
-- @param table clothing The clothing data.
-- @return boolean Success status.
function job_management_callback_saveClothing(jobName, clothing)
    Debug(3, "Saving clothing data for job: " .. jobName)
    return lib.callback.await("ludaro_manager:saveClothing", false, jobName, clothing)
end

--- Save the stashes data for a job.
-- @param string jobName The job name.
-- @param table stashes The stashes data.
-- @return boolean Success status.
function job_management_callback_saveStashes(jobName, stashes)
    Debug(3, "Saving stashes data for job: " .. jobName)
    return lib.callback.await("ludaro_manager:saveStashes", false, jobName, stashes)
end

--- Save the shop data for a job.
-- @param string jobName The job name.
-- @param table shop The shop data.
-- @return boolean Success status.
function job_management_callback_saveShop(jobName, shop)
    Debug(3, "Saving shop data for job: " .. jobName)
    return lib.callback.await("ludaro_manager:saveShop", false, jobName, shop)
end

-- Get all grades
-- @return table The grades data.
function job_management_callback_getAllGrades()
    return lib.callback.await("ludaro_manager:getAllGrades", false)
end

-- Saves all grades for a job
-- @param string jobName The job name.
-- @param table grades The grades data.
-- @return boolean Success status.
function job_management_callback_saveGrades(jobName, grades)
    local result = lib.callback.await("ludaro_manager:saveGrade", false, jobName, grades)
    return result
end

-- Save the boss menu data for a job.
-- @param table data The boss menu data.
-- @return boolean Success status.
function job_management_callback_saveBossMenu(data)
    local success = lib.callback.await("ludaro_manager:saveBossMenu", false, data)
    return success
end



-- Save the employee data for a job.
-- @param table data The employee data.
-- @return boolean Success status.
function job_management_callback_saveEmployee(data)
    return lib.callback.await("ludaro_manager:saveEmployee", false, data)
end

-- Save the vehicle data for a job.
-- @param table data The vehicle data.
-- @return boolean Success status.
function jobmanagement_zones_npcs_getNPCData()
    return lib.callback.await("ludaro_manager:getNPCData", false)
end