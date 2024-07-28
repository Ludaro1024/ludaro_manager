RegisterNUICallback('getJobData', function(data, cb)
    print(ESX.DumpTable(getJobs()))
    cb((getJobs()))
end)

RegisterNUICallback('saveJob', function(data, cb)
    cb({ SaveJob(data.job) })
end)
RegisterNUICallback('deleteJob', function(data, cb)
    deletejob = deleteJob(data.jobName)
    print(deletejob)
    cb({ success = deletejob })
end)
RegisterNUICallback('addJob', function(data, cb)
    print(data)
    local success = addJob(data)
    print(success)
    cb({ success = success})
end)
RegisterNUICallback('addGrade', function(data, cb)
    local jobName = data.jobName
    local grade = data.grade
    cb({ success = addGrade(jobName, grade) })
end)
RegisterNUICallback('deleteGrade', function(data, cb)
    local jobName = data.jobName
    local grade = data.grade
    cb({ deleteGrade(jobName, grade) })
end)
