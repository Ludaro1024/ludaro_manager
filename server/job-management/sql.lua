--- Get all jobs from the database.
-- @return table The jobs data.
function GetJobs()
    if ESX then
        Debug(3, "Fetching jobs from the database")
        local jobs = MySQL.query.await("SELECT * FROM jobs")
        local grades = MySQL.query.await("SELECT * FROM job_grades")

        for i, job in ipairs(jobs) do
            job.grades = {}
            for j, grade in ipairs(grades) do
                if job.name == grade.job_name then
                    table.insert(job.grades, grade)
                end
            end
            job.interactions = json.decode(job.interactions)
            job.employees = MySQL.query.await("SELECT * FROM users WHERE job = ?", {job.name})
            job.activeplayers = GetJobPlayers(job.name)
            Debug(4, "Job data: " .. json.encode(job))
        end
        return jobs
    end
end

-- Get all grades
-- @return table The grades data.
function GetAllGrades()
    local grades = MySQL.query.await("SELECT * FROM job_grades")
    return grades
end

--- Save a job to the database.
-- @param table job The job data.
-- @return boolean Success status.
function saveJob(job)
    if ESX then
        Debug(3, "Saving job to the database: " .. json.encode(job))
        local name = job.name
        local label = job.label
        local whitelisted = job.whitelisted
        MySQL.Async.execute('UPDATE jobs SET label = @label, whitelisted = @whitelisted WHERE name = @name', {
            ['@name'] = name,
            ['@label'] = label,
            ['@whitelisted'] = whitelisted
        }, function(rowsChanged)
            if rowsChanged > 0 then
                Debug(2, "Job saved successfully: " .. name)
                return true
            else
                Debug(2, "Failed to save job: " .. name)
                return false
            end
        end)
        refreshJobs()
    end
end

-- Check if a Job Exists
-- @param string jobName The job name.
-- @return boolean Job exists status.
function doesJobExist(jobName)
    if ESX then
        Debug(3, "Checking if job exists: " .. jobName)
        local job = MySQL.query.await("SELECT * FROM jobs WHERE name = ?", {jobName})
        if next(job) then
            Debug(2, "Job exists: " .. jobName)
            return true
        else
            Debug(2, "Job does not exist: " .. jobName)
            return false
        end
    end
end

--- Delete a job from the database.
-- @param string jobName The job name.
-- @return boolean Success status.
function deleteJob(jobName)
    if ESX then
        Debug(3, "Deleting job from the database: " .. jobName)
        MySQL.Async.execute('DELETE FROM jobs WHERE name = @name', {
            ['@name'] = jobName
        }, function(rowsChanged)
            if rowsChanged > 0 then
                Debug(2, "Job deleted successfully: " .. jobName)
                done = true
            else
                Debug(2, "Failed to delete job: " .. jobName)
                done = false
            end
        end)
        refreshJobs()
        return done
    end
end

--- Add a new job to the database.
-- @param table job The job data.
-- @return boolean, string Success status and job name.
function addJob(job)
    if ESX then
        Debug(3, "Adding new job to the database: " .. json.encode(job))
        if doesJobExist(job.name) then
            Debug(2, "Job already exists: " .. job.name)
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
                Debug(2, "Job added successfully: " .. name)
                returnn = true
                returnname = name
            else
                Debug(2, "Failed to add job: " .. name)
                returnn = false
                returnnname = nil
            end
        end)
        -- adding a grade 0 so the job has a default grade
        addGrade(name, name .. "_default", "Default", 0)
        refreshJobs()
        return returnn, returnname
    end
end

--- Add a grade to a job in the database.
-- @param string jobName The job name.
-- @param string gradeName The grade name.
-- @param string gradeLabel The grade label.
-- @param number salary The grade salary.
-- @return boolean Success status.
function addGrade(jobName, gradeName, gradeLabel, salary)
    print(jobName, gradeName, gradeLabel, salary)   
    if ESX then
        Debug(3, "Adding grade to job in the database: " .. jobName .. " - " .. gradeName)
        local latestgrade = MySQL.query.await("SELECT MAX(grade) as grade FROM job_grades WHERE job_name = ?", {jobName})
        local gradegrade = latestgrade[1] and latestgrade[1].grade and latestgrade[1].grade + 1 or 0

        local success
        MySQL.Async.execute('INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, @skin_female)', {
            ['@job_name'] = jobName,
            ['@grade'] = gradegrade,
            ['@name'] = gradeName,
            ['@label'] = gradeLabel,
            ['@salary'] = salary,
            ['@skin_male'] = json.encode({}),
            ['@skin_female'] = json.encode({}),
        }, function(rowsChanged)
            if rowsChanged > 0 then
                Debug(2, "Grade added successfully to job: " .. jobName)
                success = true
            else
                Debug(2, "Failed to add grade to job: " .. jobName)
                success = false
            end
        end)

        -- Wait for the async operation to complete before returning
        local timeout = os.clock() + 1 -- wait up to 1 second
        while success == nil and os.clock() < timeout do
            Citizen.Wait(0)
        end
        return success
    end
end

function saveGrade(jobName, grade)
    local rowsChanged = MySQL.Sync.execute('UPDATE job_grades SET name = @name, label = @label, salary = @salary WHERE job_name = @job_name AND grade = @grade', {
        ['@job_name'] = jobName,
        ['@grade'] = grade.grade,
        ['@name'] = grade.name,
        ['@label'] = grade.label,
        ['@salary'] = grade.salary
    })
    return rowsChanged > 0
end



--- Delete a grade from a job in the database.
-- @param string jobName The job name.
-- @param number index The grade index.
-- @return boolean Success status.
function deleteGrade(jobName, index)
    if ESX then
        Debug(3, "Deleting grade from job in the database: " .. jobName .. " - Index: " .. index)
        MySQL.Async.execute('DELETE FROM job_grades WHERE job_name = @job_name AND grade = @grade', {
            ['@job_name'] = jobName,
            ['@grade'] = index
        }, function(rowsChanged)
            if rowsChanged > 0 then
                Debug(2, "Grade deleted successfully from job: " .. jobName)
                returnn = true
            else
                Debug(2, "Failed to delete grade from job: " .. jobName)
                returnn = false
            end
        end)
        return returnn
    end
end

--- Add an interaction to a job in the database.
-- @param string jobName The job name.
-- @param string interaction The interaction name.
-- @return boolean Success status.
function addInteractiontoJob(jobName, interaction)
    if ESX then 
        Debug(3, "Adding interaction to job in the database: " .. jobName .. " - " .. interaction)
        if doesInteractionExist(interaction) then
            local job = MySQL.query.await("SELECT interactions FROM jobs WHERE name = ?", {jobName})
            local interactions = json.decode(job.interactions)
            if interactions == nil then
                interactions = {}
            end
            table.insert(interactions, interaction)
            Debug(4, "Updated interactions: " .. json.encode(interactions))
            MySQL.Async.execute('UPDATE jobs SET interactions = @interactions WHERE name = @name', {
                ['@interactions'] = json.encode(interactions),
                ['@name'] = jobName
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    Debug(2, "Interaction added successfully to job: " .. jobName)
                    return true
                else
                    Debug(2, "Failed to add interaction to job: " .. jobName)
                    return false
                end
            end)
        else
            Debug(2, "Interaction does not exist: " .. interaction)
            return false
        end
    end
end
-- gets All Available Interactions
-- @return table The interactions data.
function getAllInteractions()
    if ESX then
        Debug(3, "Fetching interactions from the database")
        local interactions = MySQL.query.await("SELECT * FROM ludaro_manager_interactions")
        return interactions
    end
end

--- Delete an interaction from a job in the database.
-- @param string jobName The job name.
-- @param number index The interaction index.
-- @return boolean Success status.
function removeInteractionfromjob(jobName, index)
    if ESX then
        Debug(3, "Deleting interaction from job in the database: " .. jobName .. " - Index: " .. index)
        local job = MySQL.query.await("SELECT interactions FROM jobs WHERE name = ?", {jobName})
        local interactions = json.decode(job.interactions)
        table.remove(interactions, index)
        MySQL.Async.execute('UPDATE jobs SET interactions = @interactions WHERE name = @name', {
            ['@interactions'] = json.encode(interactions),
            ['@name'] = jobName
        }, function(rowsChanged)
            if rowsChanged > 0 then
                Debug(2, "Interaction deleted successfully from job: " .. jobName)
                return true
            else
                Debug(2, "Failed to delete interaction from job: " .. jobName)
                return false
            end
        end)
    end
end

--- Add a vehicle to a job in the database.
-- @param string jobName The job name.
-- @param table vehicle The vehicle data.
-- @return boolean Success status.
function addVehicle(jobName, vehicle)
    if ESX then
        Debug(3, "Adding vehicle to job in the database: " .. jobName .. " - " .. json.encode(vehicle))
        MySQL.Async.execute('INSERT INTO job_vehicles (job_name, vehicle) VALUES (@job_name, @vehicle)', {
            ['@job_name'] = jobName,
            ['@vehicle'] = json.encode(vehicle)
        }, function(rowsChanged)
            if rowsChanged > 0 then
                Debug(2, "Vehicle added successfully to job: " .. jobName)
                return true
            else
                Debug(2, "Failed to add vehicle to job: " .. jobName)
                return false
            end
        end)
    end
end

--- Delete a vehicle from a job in the database.
-- @param string jobName The job name.
-- @param number index The vehicle index.
-- @return boolean Success status.
function deleteVehicle(jobName, index)
    if ESX then
        Debug(3, "Deleting vehicle from job in the database: " .. jobName .. " - Index: " .. index)
        local job = MySQL.query.await("SELECT vehicles FROM jobs WHERE name = ?", {jobName})
        local vehicles = json.decode(job.vehicles)
        table.remove(vehicles, index)
        MySQL.Async.execute('UPDATE jobs SET vehicles = @vehicles WHERE name = @name', {
            ['@vehicles'] = json.encode(vehicles),
            ['@name'] = jobName
        }, function(rowsChanged)
            if rowsChanged > 0 then
                Debug(2, "Vehicle deleted successfully from job: " .. jobName)
                return true
            else
                Debug(2, "Failed to delete vehicle from job: " .. jobName)
                return false
            end
        end)
    end
end

--- Get current coordinates.
-- @return table The current coordinates.
function getCurrentCoords()
    Debug(3, "Fetching current coordinates")
    local coords = GetEntityCoords(GetPlayerPed(-1))
    return { x = coords.x, y = coords.y, z = coords.z }
end

--- Save armory data to the database.
-- @param string jobName The job name.
-- @param table armory The armory data.
-- @return boolean Success status.
function saveArmory(jobName, armory)
    if ESX then
        Debug(3, "Saving armory data to the database for job: " .. jobName)
        MySQL.Async.execute('UPDATE ludaro_manager_armories SET weapons = @weapons, components = @components, ammo = @ammo, extras = @extras, blip_data = @blip_data WHERE job_name = @job_name', {
            ['@weapons'] = json.encode(armory.weapons),
            ['@components'] = json.encode(armory.components),
            ['@ammo'] = json.encode(armory.ammo),
            ['@extras'] = json.encode(armory.extras),
            ['@blip_data'] = json.encode(armory.blip_data),
            ['@job_name'] = jobName
        }, function(rowsChanged)
            if rowsChanged > 0 then
                Debug(2, "Armory data saved successfully for job: " .. jobName)
                return true
            else
                Debug(2, "Failed to save armory data for job: " .. jobName)
                return false
            end
        end)
    end
end

--- Save clothing data to the database.
-- @param string jobName The job name.
-- @param table clothing The clothing data.
-- @return boolean Success status.
function saveClothing(jobName, clothing)
    if ESX then
        Debug(3, "Saving clothing data to the database for job: " .. jobName)
        MySQL.Async.execute('UPDATE jobs SET clothing = @clothing WHERE name = @name', {
            ['@clothing'] = json.encode(clothing),
            ['@name'] = jobName
        }, function(rowsChanged)
            if rowsChanged > 0 then
                Debug(2, "Clothing data saved successfully for job: " .. jobName)
                return true
            else
                Debug(2, "Failed to save clothing data for job: " .. jobName)
                return false
            end
        end)
    end
end

--- Save stashes data to the database.
-- @param string jobName The job name.
-- @param table stashes The stashes data.
-- @return boolean Success status.
function saveStashes(jobName, stashes)
    if ESX then
        Debug(3, "Saving stashes data to the database for job: " .. jobName)
        MySQL.Async.execute('UPDATE jobs SET stashes = @stashes WHERE name = @name', {
            ['@stashes'] = json.encode(stashes),
            ['@name'] = jobName
        }, function(rowsChanged)
            if rowsChanged > 0 then
                Debug(2, "Stashes data saved successfully for job: " .. jobName)
                return true
            else
                Debug(2, "Failed to save stashes data for job: " .. jobName)
                return false
            end
        end)
    end
end

--- Save shop data to the database.
-- @param string jobName The job name.
-- @param table shop The shop data.
-- @return boolean Success status.
function saveShop(jobName, shop)
    if ESX then
        Debug(3, "Saving shop data to the database for job: " .. jobName)
        MySQL.Async.execute('UPDATE jobs SET shop = @shop WHERE name = @name', {
            ['@shop'] = json.encode(shop),
            ['@name'] = jobName
        }, function(rowsChanged)
            if rowsChanged > 0 then
                Debug(2, "Shop data saved successfully for job: " .. jobName)
                return true
            else
                Debug(2, "Failed to save shop data for job: " .. jobName)
                return false
            end
        end)
    end
end
