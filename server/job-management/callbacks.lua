
lib.callback.register('ludaro_manager:getJobs', function(source)
   return GetJobs()
end)

lib.callback.register('ludaro_manager:getInteractions', function(source)
   return getAllInteractions()
end)

lib.callback.register('ludaro_manager:saveJob', function(source, job)
   return saveJob(job)
end)

lib.callback.register('ludaro_manager:deleteJob', function(source, jobId)
   return deleteJob(jobId)
end)

lib.callback.register('ludaro_manager:addJob', function(source, job)
   return addJob(job)
end)

lib.callback.register('ludaro_manager:addGrade', function(source, jobName, gradeName, gradeLabel, salary)
   return addGrade(jobName, gradeName, gradeLabel, salary)
end)

lib.callback.register('ludaro_manager:deleteGrade', function(source, jobName, index)
   return deleteGrade(jobName, index)
end)

lib.callback.register('ludaro_manager:addInteractionfromjob', function(source, jobName, interaction)
   return addInteractiontoJob(jobName, interaction)
end)

lib.callback.register('ludaro_manager:deleteInteractionfromjob', function(source, jobName, index)
   return removeInteractionfromjob(jobName, index)
end)

lib.callback.register('ludaro_manager:addVehicle', function(source, jobName, vehicle)
   return addVehicle(jobName, vehicle)
end)

lib.callback.register('ludaro_manager:deleteVehicle', function(source, jobName, index)
   return deleteVehicle(jobName, index)
end)

lib.callback.register('ludaro_manager:saveArmory', function(source, jobName, armory)
   return saveArmory(jobName, armory)
end)

lib.callback.register('ludaro_manager:saveClothing', function(source, jobName, clothing)
   return saveClothing(jobName, clothing)
end)

lib.callback.register('ludaro_manager:saveStashes', function(source, jobName, stashes)
   return saveStashes(jobName, stashes)
end)

lib.callback.register('ludaro_manager:saveShop', function(source, jobName, shop)
   return saveShop(jobName, shop)
end)
lib.callback.register('ludaro_manager:getAllGrades', function(source)
   return GetAllGrades()
end)
lib.callback.register('ludaro_manager:saveGrade', function(source, jobName, grade)
   return saveGrade(jobName, grade)
end)
lib.callback.register("ludaro_manager:saveBossMenu", function(source, data)
   return saveBossMenu(data)
end)
lib.callback.register("ludaro_manager:saveEmployee", function(source, data)
   return saveEmployee(data)
end)