function duty_sql_getOffDutyJob(jobname)
    local result = MySQL.Sync.fetchAll("SELECT * FROM jobs WHERE name = @name", {
        ['@name'] = jobname .. "_offduty"
    })
    if result[1] then
        return result[1].offduty
    end
    return false
end

function duty_sql_createOffDutyJobWithGrades(jobname)
    local result = MySQL.Sync.fetchAll("SELECT * FROM jobs WHERE name = @name", {
        ['@name'] = jobname
    })
    if result[1] then
        local job = result[1]
        local jobname = job.name
        local label = job.label
        whitelisted = job.whitelisted
        MySQL.Async.execute("INSERT INTO jobs (name, label, whitelisted) VALUES (@name, @label, @whitelisted)", {
            ['@name'] = jobname .. "_offduty",
            ['@label'] = label .. " (Off Duty)",
            ['@whitelisted'] = whitelisted
        }, function(rowsChanged)
            if rowsChanged > 0 then
                getGrades = MySQL.Sync.fetchAll("SELECT * FROM job_grades WHERE job_name = @name", {
                    ['@name'] = jobname
                })
                for k, v in pairs(getGrades) do
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


MySQL.ready(function()
    if Config.ExtraOffDutyJobs == true then
        local alljobs = MySQL.Sync.fetchAll("SELECT * FROM jobs")
        local offdutyjobexist = false
        for k, v in pairs(alljobs) do
            local jobname = v.name
            if string.find(jobname, "_offduty") then
                offdutyjobexist = true
                break
            end
        end
        if not offdutyjobexist then
            for k, v in pairs(alljobs) do
                local jobname = v.name
                duty_sql_createOffDutyJobWithGrades(jobname)
            end
        end
    end
end)
