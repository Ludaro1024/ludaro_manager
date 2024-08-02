lib.callback.register("getBossMenuData",  function(source, jobName)
    return getBossMenuData(jobName)
end)
    -- This is the callback function that is called when the server sends the data
    
    lib.callback.register("ludaro_manager:getJobandGrade", function(source)
        return getJob(source), getGrade(source)
    end)

    lib.callback.register("ludaro_manager:setGradeSalary", function(source, jobName, grade, salary)
    
        return setGradeSalary(jobName, grade, salary)
    end)