function getJobs()
    local jobs = lib.callback.await("ludaro_manager:getJobs", false)
    return jobs
end

function AddJob(job)
    local success, jobName = lib.callback.await("ludaro_manager:addJob", false, job)
    return success, jobName
end

function saveJob(job)
    local success = lib.callback.await("ludaro_manager:saveJob", false, job)
    return success
end

function deleteJob(jobId)
    print(jobId)
    local success = lib.callback.await("ludaro_manager:deleteJob", false, jobId)
    return success
end

function addJob(job)
    local success, jobName = lib.callback.await("ludaro_manager:addJob", false, job)
    return success, jobName
end

function addGrade(jobName, grade)
    local success = lib.callback.await("ludaro_manager:addGrade", false, jobName, grade)
    return success
end

function deleteGrade(jobName, grade)
    local success = lib.callback.await("ludaro_manager:deleteGrade", false, jobName, grade)
    return success
end

