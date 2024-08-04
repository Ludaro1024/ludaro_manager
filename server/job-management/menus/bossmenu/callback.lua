lib.callback.register("getBossMenuData", function(source, jobName)
    return getBossMenuData(jobName)
end)

lib.callback.register("ludaro_manager:getJobandGrade", function(source, otherplayerid)
    return getJob(source, otherplayerid), getGrade(source, otherplayerid)
end)

lib.callback.register("ludaro_manager:setGradeSalary", function(source, jobName, grade, salary)
    return setGradeSalary(jobName, grade, salary)
end)

lib.callback.register("ludaro_manager:hirePlayer", function(source, jobName, player)
    return hirePlayer(jobName, player)
end)

