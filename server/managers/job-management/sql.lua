--- Get all jobs from the database.
-- @return table The jobs data.
function job_management_sql_GetJobs()
   
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
            job.employees = getEmployees(job.name)
            job.activeplayers = framework_GetJobPlayers(job.name)
            Debug(4, "Job data: " .. json.encode(job))
        end
        return jobs
    end
end

-- Get all grades
-- @return table The grades data.
function job_management_sql_GetAllGrades()
    local grades = MySQL.query.await("SELECT * FROM job_grades")
    return grades
end

-- Save a job to the database.
-- @param table job The job data.
-- @return boolean Success status.
function job_management_callback_saveJob(job)
    if ESX then
        Debug(3, "Saving job to the database: " .. json.encode(job))

        -- Fetch existing job data from the database
        local existingJob = MySQL.query.await('SELECT * FROM jobs WHERE name = @name', {
            ['@name'] = job.name
        })

        if existingJob[1] then
            existingJob = existingJob[1]
        else
            Debug(2, "Job not found in the database: " .. job.name)
            return false
        end
        

    job.clothing = job.ludaro_manager_clothing or {}

        -- Default values
        local defaultValues = {
            bossmenu = {},
            interactions = {},
            garage = { type = "npc", markerScale = 1, npcModel = "", npcHeading = 0, coords = { x = 0, y = 0, z = 0 }, markerColor = { r = 0, g = 0, b = 0 }, markerId = 0, parkoutCoords = { x = 0, y = 0, z = 0, heading = 0 } },
            onoffduty = { type = "npc", markerScale = 1, npcModel = "", coords = { x = 0, y = 0, z = 0 }, markerHeading = 0 },
            stashes = {},
            vehicleShop = {},
            societyPaid = {},
            clothing = { localClothes = { [1] = { name = "", skin = {} } }, npcSettings = { markerId = 0, markerColor = { r = 0, g = 0, b = 0 }, npcModel = "", coords = { x = 0, y = 0, z = 0 }, npcHeading = 0 } }
        }

        -- Helper function to use existing value if default is set
        local function useExistingIfDefault(newValue, existingValue, defaultValue)
            if newValue == nil or (type(newValue) == "table" and next(newValue) == nil) then
                return existingValue or defaultValue
            else
                return newValue
            end
        end
        -- Define properties to check
        local propertiesToCheck = {
           bossmenu = "ludaro_manager_bossmenu",
           interactions = "ludaro_manager_interactions",
           garage = "ludaro_manager_garage",
           onoffduty = "ludaro_manager_onoffduty",
           stashes = "ludaro_manager_stashes",
           vehicleShop = "ludaro_manager_vehicleShop",
           societyPaid = "ludaro_manager_societyPaid",
           clothing = "ludaro_manager_clothing"
       }


        -- Prepare job data to be updated
        local function prepareJobData(jobData)
            local updatedJob = {}
            for key, columnName in pairs(propertiesToCheck) do
                updatedJob[key] = useExistingIfDefault(jobData[key], json.decode(existingJob[columnName]), defaultValues[key])
            end
            return updatedJob
        end

       
        -- Prepare the updated job data
        local updatedJob = prepareJobData(job)

        -- Convert the tables to JSON strings
        local function encodeOrNil(value)
            if not value then
                
                return nil
            elseif type(value) == "string" then
                -- Check if it's a valid JSON string by attempting to decode it
                local decoded, pos, err = json.decode(value)
                if decoded then
                    
                    return value
                else
                    
                    return value
                end
            elseif type(value) ~= "table" then
                
                return nil
            else
                
                return json.encode(value)
            end
        end
        


        local bossmenu_json = encodeOrNil(updatedJob.bossmenu)
        local interactions_json = encodeOrNil(updatedJob.interactions)
        local garage_json = encodeOrNil(updatedJob.garage)
        local onoffduty_json = encodeOrNil(updatedJob.onoffduty)
        local stashes_json = encodeOrNil(updatedJob.stashes)
        local vehicleShop_json = encodeOrNil(updatedJob.vehicleShop)
        local clothing_json = encodeOrNil(updatedJob.clothing)
        job.whitelisted = job.whitelisted or 0
        -- Execute the SQL update with the processed data
        MySQL.Async.execute('UPDATE jobs SET label = @label, whitelisted = @whitelisted, ludaro_manager_bossmenu = @bossmenu, ludaro_manager_interactions = @interactions, ludaro_manager_garage = @garage, ludaro_manager_onoffduty = @onoffduty, ludaro_manager_stashes = @stashes, ludaro_manager_vehicleShop = @vehicleShop, ludaro_manager_societyPaid = @societyPaid, ludaro_manager_clothing = @clothing WHERE name = @name', {
            ['@name'] = job.name,
            ['@label'] = job.label,
            ['@whitelisted'] = job.whitelisted,
            ['@bossmenu'] = bossmenu_json,
            ['@interactions'] = interactions_json,
            ['@garage'] = garage_json,
            ['@onoffduty'] = onoffduty_json,
            ['@stashes'] = stashes_json,
            ['@vehicleShop'] = vehicleShop_json,
            ['@societyPaid'] = job.societypaid,
            ['@clothing'] = clothing_json
        }, function(rowsChanged)
            if rowsChanged > 0 then
                Debug(2, "Job saved successfully: " .. job.name)
                return true
            else
                Debug(2, "Failed to save job: " .. job.name)
                return false
            end
        end)

        -- Refresh the jobs in the framework
        framework_refreshJobs()
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
function job_management_callback_deleteJob(jobName)
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
        framework_refreshJobs()
        return done
    end
end

--- Add a new job to the database.
-- @param table job The job data.
-- @return boolean, string Success status and job name.
function job_management_callback_addJob(job)
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
        job_management_callback_addGrade(name, name .. "_default", "Default", 0)
        framework_refreshJobs()
        return returnn, returnname
    end
end

--- Add a grade to a job in the database.
-- @param string jobName The job name.
-- @param string gradeName The grade name.
-- @param string gradeLabel The grade label.
-- @param number salary The grade salary.
-- @return boolean Success status.
function job_management_callback_addGrade(jobName, gradeName, gradeLabel, salary)
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

function job_management_sql_saveGrade(jobName, grade)
    for k,v in pairs(grade) do
        gradeexists = MySQL.query.await("SELECT * FROM job_grades WHERE job_name = ? AND grade = ?", {jobName, v.grade})
        if not next(gradeexists) then
            
            Debug(3, "Adding grade to job in the database: " .. jobName .. " - " .. v.grade)
            MySQL.Async.execute('INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, @skin_female)', {
                ['@job_name'] = jobName,
                ['@grade'] = v.grade,
                ['@name'] = v.name,
                ['@label'] = v.label,
                ['@salary'] = v.salary,
                ['@skin_male'] = "{}",
                ['@skin_female'] = "{}"
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    Debug(2, "Grade added successfully to job: " .. jobName)
                    returnn = true
                else
                    Debug(2, "Failed to add grade to job: " .. jobName)
                    returnn = false
                end
            end)
        end
        return returnn
    end
end



--- Delete a grade from a job in the database.
-- @param string jobName The job name.
-- @param number index The grade index.
-- @return boolean Success status.
function job_management_callback_deleteGrade(jobName, index)
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

-- checks if an interaction exists
-- @param string interaction The interaction name.
-- @return boolean Interaction exists status.
function job_management_sql_doesInteractionExist(interaction)
    if ESX then
        Debug(3, "Checking if interaction exists: " .. interaction)
        local interaction = MySQL.query.await("SELECT * FROM ludaro_manager_interactions WHERE interaction_name = ?", {interaction})
        if next(interaction) then
            Debug(2, "Interaction exists: ")
            return true
        else
            Debug(2, "Interaction does not exist: ")
            return false
        end
    end
end

--- Add an interaction to a job in the database.
-- @param string jobName The job name.
-- @param string interaction The interaction name.
-- @return boolean Success status.
function addInteractiontoJob(jobName, interaction)
    if ESX then 
        Debug(3, "Adding interaction to job in the database: " .. jobName .. " - " .. interaction)
        if job_management_sql_doesInteractionExist(interaction) then
            local job = MySQL.query.await("SELECT ludaro_manager_interactions FROM jobs WHERE name = ?", {jobName})
            local interactions = json.decode(job.interactions)
            if interactions == nil then
                interactions = {}
            end
            table.insert(interactions, interaction)
            Debug(4, "Updated interactions: " .. json.encode(interactions))
            MySQL.Async.execute('UPDATE jobs SET ludaro_manager_interactions = @interactions WHERE name = @name', {
                ['@interactions'] = json.encode(interactions),
                ['@name'] = jobName
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    Debug(2, "Interaction added successfully to job: " .. jobName)
                    returnn = true
                else
                    Debug(2, "Failed to add interaction to job: " .. jobName)
                    returnn = false
                end
            end)
        end
        return returnn
    end
end
-- gets All Available Interactions
-- @return table The interactions data.
function job_management_sql_getAllInteractions()
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
function job_management_sql_removeInteractionfromjob(jobName, index)
    if ESX then
        Debug(3, "Deleting interaction from job in the database: " .. jobName .. " - Index: " .. index)
        local interactions = MySQL.scalar.await("SELECT ludaro_manager_interactions FROM jobs WHERE name = ? LIMIT 1", {jobName})
        interactions = json.decode(interactions)
        newinteractions = removeIndexIfPresent(interactions, index)
        MySQL.Async.execute('UPDATE jobs SET ludaro_manager_interactions = @interactions WHERE name = @name', {
            ['@interactions'] = json.encode(newinteractions),
            ['@name'] = jobName
        }, function(rowsChanged)
            if rowsChanged > 0 then
                returnn = true
                Debug(2, "Interaction deleted successfully from job: " .. jobName)
            else
                returnn = false
                Debug(2, "Failed to delete interaction from job: " .. jobName)
            end
        end)
        return returnn
    end
end




--- Save stashes data to the database.
-- @param string jobName The job name.
-- @param table stashes The stashes data.
-- @return boolean Success status.
function job_management_callback_saveStashes(jobName, stashes)
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
function job_management_callback_saveShop(jobName, shop)
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


function job_management_callback_saveBossMenu(data)
    jobname = data.name
    bossmenu = data.bossmenu
    if ESX then
        Debug(3, "Saving boss menu data to the database for job: " .. jobname)
        MySQL.Async.execute('UPDATE jobs SET bossmenu = @bossmenu WHERE name = @name', {
            ['@bossmenu'] = json.encode(bossmenu),
            ['@name'] = jobname
        }, function(rowsChanged)
            if rowsChanged > 0 then
                Debug(2, "Boss menu data saved successfully for job: " .. jobname)
                return true
            else
                Debug(2, "Failed to save boss menu data for job: " .. jobname)
                return false
            end
        end)
    end
end

function job_management_callback_saveEmployee(data)
    if ESX then
        xPlayer = ESX.GetPlayerFromIdentifier(data.employee.identifier)
        if xPlayer then
            if data.fire then
                Debug(2, "Firing player. and setting job to unemployed 0")
                xPlayer.setJob("unemployed", 0)
                return true
            end
            xPlayer.setJob(data.jobName, data.employee.job_grade)
            return true
        else
            MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
                ['@job'] = data.jobName,
                ['@job_grade'] = data.employee.job_grade,
                ['@identifier'] = data.employee.identifier
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    Debug(2, "Employee data saved successfully for identifier: ")
                    return true
                else
                    Debug(2, "Failed to save employee data for identifier: " )
                    return false
                end
            end)
        end
    end
end
-- Get NPC Data for spawning NPCS AND MARKERS
-- @return table The NPC data.
function jobmanagement_zones_npcs_getNPCData() --
    if ESX then
        Debug(3, "Fetching NPC data from the database")
        local query = [[
            SELECT name, label, ludaro_manager_bossmenu, ludaro_manager_interactions,
               ludaro_manager_garage, ludaro_manager_onoffduty, ludaro_manager_stashes, ludaro_manager_clothing, ludaro_manager_vehicleShop 
            FROM jobs
            WHERE ludaro_manager_bossmenu IS NOT NULL
            OR ludaro_manager_interactions IS NOT NULL
            OR ludaro_manager_garage IS NOT NULL
            OR ludaro_manager_onoffduty IS NOT NULL
            OR ludaro_manager_stashes IS NOT NULL
            OR ludaro_manager_clothing IS NOT NULL
            OR ludaro_manager_vehicleShop IS NOT NULL
        ]]
   
        local npcs = MySQL.query.await(query)
        local npcdata = {}
      
        for _, npc in ipairs(npcs) do
         
            local ludaro_manager_outfits = json.decode(npc.ludaro_manager_clothing) or {}
        
            local ludaro_manager_bossmenu = json.decode(npc.ludaro_manager_bossmenu) or {}
            local ludaro_manager_interactions = json.decode(npc.ludaro_manager_interactions) or {}
            local ludaro_manager_garage = json.decode(npc.ludaro_manager_garage) or {}
            local ludaro_manager_onoffduty = json.decode(npc.ludaro_manager_onoffduty) or {}
            local ludaro_manager_stashes = json.decode(npc.ludaro_manager_stashes) or {}
            local ludaro_manager_vehicleShop = json.decode(npc.ludaro_manager_vehicleShop) or {}
            local ludaro_manager_clothes = json.decode(npc.ludaro_manager_clothing) or {}
            if next(ludaro_manager_bossmenu) then
            ludaro_manager_bossmenu.openType = "bossmenu"
            end
            if next(ludaro_manager_interactions) then
            ludaro_manager_interactions.openType = "interactions"
            end
            if next(ludaro_manager_garage) then 
            ludaro_manager_garage.openType = "garage"
            end
            if next(ludaro_manager_onoffduty) then
            ludaro_manager_onoffduty.openType = "onoffduty"
            end
            if next(ludaro_manager_stashes) then
            ludaro_manager_stashes.openType = "stashes"
            end
            if next(ludaro_manager_vehicleShop) then
            ludaro_manager_vehicleShop.openType = "vehicleShop"
            end

            if next(ludaro_manager_outfits) then
                ludaro_manager_outfits.openType = "clothes"
            end

            if next(ludaro_manager_clothes) then
                ludaro_manager_clothes.openType = "clothes"
            end

            table.insert(npcdata, {
                name = npc.name,
                label = npc.label,
                data = {
                    bossmenu = ludaro_manager_bossmenu,
                    interactions = ludaro_manager_interactions,
                    garage = ludaro_manager_garage,
                    onoffduty = ludaro_manager_onoffduty,
                    stashes = ludaro_manager_stashes,
                    vehicleShop = ludaro_manager_vehicleShop,
                    clothing = ludaro_manager_clothes,
                }
            })
        end

        return npcdata
    end
end


function  sql_DeleteGradesWithNoJobUponRefreshing()
-- make me an sql query that goes thrhough job_grades and every entry on job_grades if job_name doesnt exist in jobs under the column name it will delete it
    if ESX then
        Debug(3, "Deleting grades with no job upon refreshing")
        MySQL.Async.execute('DELETE FROM job_grades WHERE job_name NOT IN (SELECT name FROM jobs)', {}, function(rowsChanged)
            if rowsChanged > 0 then
                Debug(2, "Grades with no job deleted successfully")
                return true
            else
                Debug(2, "Failed to delete grades with no job")
                return false
            end
        end)
    end 

end