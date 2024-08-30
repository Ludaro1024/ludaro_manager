--[[
    Get Off-Duty Job Name

    This function fetches the name of the off-duty job associated with the given job name.

    @param jobname (string): The name of the current job.
    
    @return string|boolean: Returns the name of the off-duty job if it exists, otherwise false.
]]
function duty_sql_getOffDutyJob(jobname)
    local result = MySQL.Sync.fetchAll("SELECT name FROM jobs WHERE name = @name", {
        ['@name'] = jobname .. "_offduty"
    })
    
    if result[1] then
        return result[1].name
    end
    
    return false
end

--[[
    Create Off-Duty Job with Grades

    This function creates an off-duty version of a job, including all associated grades.

    @param jobname (string): The name of the job to create an off-duty version for.
]]
function duty_sql_createOffDutyJobWithGrades(jobname)
    local result = MySQL.Sync.fetchAll("SELECT * FROM jobs WHERE name = @name", {
        ['@name'] = jobname
    })
    
    if result[1] then
        local job = result[1]
        local jobname = job.name
        local label = job.label
        local whitelisted = job.whitelisted
        
        MySQL.Async.execute("INSERT INTO jobs (name, label, whitelisted) VALUES (@name, @label, @whitelisted)", {
            ['@name'] = jobname .. "_offduty",
            ['@label'] = label .. " (Off Duty)",
            ['@whitelisted'] = whitelisted
        }, function(rowsChanged)
            if rowsChanged > 0 then
                local getGrades = MySQL.Sync.fetchAll("SELECT * FROM job_grades WHERE job_name = @name", {
                    ['@name'] = jobname
                })
                
                for _, v in pairs(getGrades) do
                    MySQL.Async.execute("INSERT INTO job_grades (job_name, grade, label, name, salary, skin_male, skin_female) VALUES (@job_name, @grade, @label, @name, @salary, @skin_male, @skin_female)", {
                        ['@job_name'] = jobname .. "_offduty",
                        ['@grade'] = v.grade,
                        ['@label'] = v.label .. " (Off Duty)",
                        ['@name'] = v.name .. "_offduty",
                        ['@salary'] = 0,
                        ['@skin_male'] = v.skin_male,
                        ['@skin_female'] = v.skin_female
                    }, function(rowsChanged)
                        if rowsChanged > 0 then
                            Debug(1, "Grade " .. v.grade .. " for job " .. jobname .. " has been created.")
                        end
                    end)
                end
            end
        end)
    end
end

--[[
    MySQL Initialization: Create Off-Duty Jobs if Not Exist

    This initialization code runs when the MySQL connection is ready. It checks if off-duty jobs exist,
    and if not, it creates off-duty versions of all jobs found in the database.
]]
MySQL.ready(function()
    if Config.ExtraOffDutyJobs == true then
        local alljobs = MySQL.Sync.fetchAll("SELECT * FROM jobs")
        local offdutyjobexist = false
        
        for _, v in pairs(alljobs) do
            local jobname = v.name
            if string.find(jobname, "_offduty") then
                offdutyjobexist = true
                break
            end
        end
        
        if not offdutyjobexist then
            for _, v in pairs(alljobs) do
                local jobname = v.name
                duty_sql_createOffDutyJobWithGrades(jobname)
            end
        end
    end
end)
