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
            job.employees = getEmployees(job.name)
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
        local bossmenu = job.bossmenu
        local interactions = job.interactions
        local garage = job.garage
        local onoffduty = job.onoffduty
        local stashes = job.stashes
        local shops = job.shops
        local processing = job.processing
        local vehicleshop = job.vehicleShop

        -- Convert the tables to JSON strings, but replace nil with actual nil (not JSON "null")
        local bossmenu_json = bossmenu and json.encode(bossmenu) or nil
        local interactions_json = interactions and json.encode(interactions) or nil
        local garage_json = garage and json.encode(garage) or nil
        local onoffduty_json = onoffduty and json.encode(onoffduty) or nil
        local stashes_json = stashes and json.encode(stashes) or nil
        local shops_json = shops and json.encode(shops) or nil
        local processing_json = processing and json.encode(processing) or nil
        local vehicleshop_json = vehicleshop and json.encode(vehicleshop) or nil

        MySQL.Async.execute('UPDATE jobs SET label = @label, whitelisted = @whitelisted, ludaro_manager_bossmenu = @bossmenu, ludaro_manager_interactions = @interactions, ludaro_manager_garage = @garage, ludaro_manager_onoffduty = @onoffduty, ludaro_manager_stashes = @stashes, ludaro_manager_shops = @shops, ludaro_manager_processing = @processing, ludaro_manager_vehicleShop = @vehicleShop WHERE name = @name', {
            ['@name'] = name,
            ['@label'] = label,
            ['@whitelisted'] = whitelisted,
            ['@bossmenu'] = bossmenu_json,
            ['@interactions'] = interactions_json,
            ['@garage'] = garage_json,
            ['@onoffduty'] = onoffduty_json,
            ['@stashes'] = stashes_json,
            ['@shops'] = shops_json,
            ['@processing'] = processing_json,
            ['@vehicleShop'] = vehicleshop_json,
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
    (jobName, gradeName, gradeLabel, salary)   
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
    (ESX.DumpTable(grade))
    for k,v in pairs(grade) do
        gradeexists = MySQL.query.await("SELECT * FROM job_grades WHERE job_name = ? AND grade = ?", {jobName, v.grade})
        if not next(gradeexists) then
            (grade.grade)
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

-- checks if an interaction exists
-- @param string interaction The interaction name.
-- @return boolean Interaction exists status.
function doesInteractionExist(interaction)
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
        if doesInteractionExist(interaction) then
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


function saveBossMenu(data)
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

function saveEmployee(data)
    ("savedata")
    (ESX.DumpTable(data))
    if ESX then
        xPlayer = ESX.GetPlayerFromIdentifier(data.employee.identifier)
        if xPlayer then
            if data.fire then
                Debug(2, "Firing player. and setting job to unemployed 0")
                xPlayer.setJob("unemployed", 0)
                return true
            end
            (ESX.DumpTable(data))
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

-- Get NPC Data for spawning NPCS
-- @return table The NPC data.
function getNPCData()
    if ESX then
        Debug(3, "Fetching NPC data from the database")
        local query = [[
            SELECT name, label, ludaro_manager_bossmenu, ludaro_manager_interactions,
                   ludaro_manager_garage, ludaro_manager_onoffduty, ludaro_manager_stashes,
                   ludaro_manager_shops, ludaro_manager_processing, ludaro_manager_vehicleShop 
            FROM jobs
        ]]
   
        local npcs = MySQL.query.await(query)
        local npcdata = {}

        for _, npc in ipairs(npcs) do
            local ludaro_manager_bossmenu = json.decode(npc.ludaro_manager_bossmenu) or {}
            local ludaro_manager_interactions = json.decode(npc.ludaro_manager_interactions) or {}
            local ludaro_manager_garage = json.decode(npc.ludaro_manager_garage) or {}
            local ludaro_manager_onoffduty = json.decode(npc.ludaro_manager_onoffduty) or {}
            local ludaro_manager_stashes = json.decode(npc.ludaro_manager_stashes) or {}
            local ludaro_manager_shops = json.decode(npc.ludaro_manager_shops) or {}
            local ludaro_manager_processing = json.decode(npc.ludaro_manager_processing) or {}
            local ludaro_manager_vehicleShop = json.decode(npc.ludaro_manager_vehicleShop) or {}
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
            if next(ludaro_manager_shops) then
            ludaro_manager_shops.openType = "shops"
            end
            if next(ludaro_manager_processing) then
            ludaro_manager_processing.openType = "processing"
            end
            if next(ludaro_manager_vehicleShop) then
            ludaro_manager_vehicleShop.openType = "vehicleShop"
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
                    shops = ludaro_manager_shops,
                    processing = ludaro_manager_processing,
                    vehicleShop = ludaro_manager_vehicleShop
                }
            })
        end

        return npcdata
    end
end

