lib.callback.register('ludaro_manager:getJobs', function(source)
   return GetJobs()
end)

lib.callback.register('ludaro_manager:saveJob', function(source, job)
   return saveJob(job)
end)

lib.callback.register('ludaro_manager:deleteJob', function(source, jobId)
   jobdeletion = deleteJob(jobId)
   print(jobdeletion)
   return jobdeletion
end)

lib.callback.register('ludaro_manager:addJob', function(source, job)
   print(job4)
   return addJob(job)
end)

lib.callback.register('ludaro_manager:addGrade', function(source, jobName, grade)
   return ESX.AddGrade(jobName, grade)
end)

lib.callback.register('ludaro_manager:deleteGrade', function(source, jobName, grade)
   return ESX.DeleteGrade(jobName, grade)
end)

