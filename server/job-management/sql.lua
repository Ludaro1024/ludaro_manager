function GetJobs()
    if ESX then
        local jobs = MySQL.query.await("SELECT * FROM jobs")
        return jobs
    end
end

function saveJob(job)
    if ESX then
        local name = job.name
        local label = job.label
        local whitelisted = job.whitelisted
        MySQL.Async.execute('UPDATE jobs SET label = @label, whitelisted = @whitelisted WHERE name = @name', {
            ['@name'] = name,
            ['@label'] = label,
            ['@whitelisted'] = whitelisted
        }, function(rowsChanged)
            if rowsChanged > 0 then
                return true
            else
                return false
            end
        end)
        refreshJobs()
    end
end

function deleteJob(jobId)
    if ESX then
        print(jobId)
        MySQL.Async.execute('DELETE FROM jobs WHERE name = @id', {
            ['@id'] = jobId
        }, function(rowsChanged)
            if rowsChanged > 0 then
              done = true
            else
               done = false
            end
        end)
        refreshJobs()
        return done
    end
end
function doesJobExist(jobName)
    if ESX then
       MySQL.Async.fetchAll('SELECT * FROM jobs WHERE name = @name', {
            ['@name'] = jobName
        }, function(job)
            if job then
                returnn = true
            else
                returnn = false
            end
        end)
        refreshJobs()
        return done
    end
end
function addJob(job)
    if ESX then
        if doesJobExist(job.name) then
            return false
        end
        local name = job.name
        local label = job.label
        local whitelisted = job.whitelisted
        MySQL.Async.execute('INSERT INTO jobs (name, label, whitelisted) VALUES (@name, @label, @whitelisted)', {
            ['@name'] = name,
            ['@label'] = label,
            ['@whitelisted'] = whitelisted
        }, function(rowsChanged)
            if rowsChanged > 0 then
               returnn = true
               returnname = name
            else
                reutrnn = false
                returnnname = nil
            end
        end)
        refreshJobs()
        return returnn, returnname
    end
end

function addGrade(jobName, grade)
    if ESX then
        MySQL.Async.execute('INSERT INTO job_grades (job_name, grade) VALUES (@job_name, @grade)', {
            ['@job_name'] = jobName,
            ['@grade'] = grade
        }, function(rowsChanged)
            if rowsChanged > 0 then
                returnn = true
            else
                returnn = false
            end
        end)
        return returnn
    end
end

function deleteGrade(jobName, grade)
    if ESX then
        MySQL.Async.execute('DELETE FROM job_grades WHERE job_name = @job_name AND grade = @grade', {
            ['@job_name'] = jobName,
            ['@grade'] = grade
        }, function(rowsChanged)
            if rowsChanged > 0 then
               returnn = true
            else
                returnn = false
            end
        end)
        return returnn
    end
end

