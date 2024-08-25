
lib.callback.register('ludaro_manager:getJobs', function(source)
   return job_management_sql_GetJobs()
end)

lib.callback.register('ludaro_manager:getInteractions', function(source)
   return job_management_sql_getAllInteractions()
end)

lib.callback.register('ludaro_manager:saveJob', function(source, job)
   return job_management_callback_saveJob(job)
end)

lib.callback.register('ludaro_manager:deleteJob', function(source, jobId)
   return job_management_callback_deleteJob(jobId)
end)

lib.callback.register('ludaro_manager:addJob', function(source, job)
   return job_management_callback_addJob(job)
end)

lib.callback.register('ludaro_manager:addGrade', function(source, jobName, gradeName, gradeLabel, salary)
   return job_management_callback_addGrade(jobName, gradeName, gradeLabel, salary)
end)

lib.callback.register('ludaro_manager:deleteGrade', function(source, jobName, index)
   return job_management_callback_deleteGrade(jobName, index)
end)

lib.callback.register('ludaro_manager:addInteractionfromjob', function(source, jobName, interaction)
   return addInteractiontoJob(jobName, interaction)
end)

lib.callback.register('ludaro_manager:deleteInteractionfromjob', function(source, jobName, index)
   return job_management_sql_removeInteractionfromjob(jobName, index)
end)

lib.callback.register('ludaro_manager:addVehicle', function(source, jobName, vehicle)
   return job_management_callback_addVehicle(jobName, vehicle)
end)

lib.callback.register('ludaro_manager:deleteVehicle', function(source, jobName, index)
   return job_management_callback_deleteVehicle(jobName, index)
end)

lib.callback.register('ludaro_manager:saveArmory', function(source, jobName, armory)
   return job_management_callback_saveArmory(jobName, armory)
end)

lib.callback.register('ludaro_manager:saveClothing', function(source, jobName, clothing)
   return job_management_callback_saveClothing(jobName, clothing)
end)

lib.callback.register('ludaro_manager:saveStashes', function(source, jobName, stashes)
   return job_management_callback_saveStashes(jobName, stashes)
end)

lib.callback.register('ludaro_manager:saveShop', function(source, jobName, shop)
   return job_management_callback_saveShop(jobName, shop)
end)
lib.callback.register('ludaro_manager:getAllGrades', function(source)
   return job_management_sql_GetAllGrades()
end)
lib.callback.register('ludaro_manager:saveGrade', function(source, jobName, grade)
   return job_management_sql_saveGrade(jobName, grade)
end)
lib.callback.register("ludaro_manager:saveBossMenu", function(source, data)
   return job_management_callback_saveBossMenu(data)
end)
lib.callback.register("ludaro_manager:saveEmployee", function(source, data)
   return job_management_callback_saveEmployee(data)
end)



lib.callback.register('ludaro_manager:getName', function(source, id)
   return framework_getPlayerName(identifier)
end)