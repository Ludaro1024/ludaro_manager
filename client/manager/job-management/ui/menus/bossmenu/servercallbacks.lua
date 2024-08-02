function getBossMenuData(jobName)
    return lib.callback.await("getBossMenuData", false, jobName)
end

function setGradeSalary(jobName, grade, salary)
    return lib.callback.await("ludaro_manager:setGradeSalary", false, jobName, grade, salary)
end