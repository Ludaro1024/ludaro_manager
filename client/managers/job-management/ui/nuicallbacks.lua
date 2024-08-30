-- RegisterNUICallback for fetching job data
-- @param data: The data received from the NUI callback
-- @param cb: The callback function to send the response
    RegisterNUICallback('getJobData', function(data, cb)
        Debug(4, "Fetching job data")
       
        local jobs = job_management_callback_getJobs()

        Debug(3, "Job data fetched: " .. ESX.DumpTable(jobs))

        cb(jobs)
    end)
    
    -- RegisterNUICallback for fetching interactions
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('getInteractions', function(data, cb)
        Debug(4, "Fetching interactions")
        local interactions = job_management_callback_getInteractions()
        Debug(3, "Interactions fetched: " .. ESX.DumpTable(interactions))
        cb(interactions)
    end)
    
    -- RegisterNUICallback for saving job data
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('saveJob', function(data, cb)
        Debug(4, "Saving job data: " .. ESX.DumpTable(data))
        local success = job_management_callback_saveJob(data)
        Debug(2, "Job save status: " .. tostring(success))
        cb({ success = success })
    end)
    
    -- RegisterNUICallback for deleting a job
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('deleteJob', function(data, cb)
        Debug(4, "Deleting job: " .. data.jobName)
        local success = job_management_callback_deleteJob(data.jobName)
        Debug(2, "Job delete status: " .. tostring(success))
        cb({ success = success })
    end)
    
    -- RegisterNUICallback for adding a job
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('addJob', function(data, cb)
        Debug(4, "Adding job: " .. ESX.DumpTable(data))
        local success = job_management_callback_addJob(data)
        Debug(2, "Job add status: " .. tostring(success))
        cb({ success = success, jobName = data.name })
    end)
    
    -- RegisterNUICallback for adding a grade to a job
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('addGrade', function(data, cb)
        Debug(4, "Adding grade to job: " .. data.jobName)
        local success = job_management_callback_addGrade(data.jobName, data.grade)
        Debug(2, "Grade add status: " .. tostring(success))
        cb({ success = success })
    end)
    
    -- RegisterNUICallback for removing a grade from a job
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('removeGrade', function(data, cb)
        Debug(4, "Removing grade from job: " .. data.jobName)
        local success = job_management_callback_deleteGrade(data.jobName, data.index)
        Debug(2, "Grade remove status: " .. tostring(success))
        cb({ success = success })
    end)
    
    -- RegisterNUICallback for adding an interaction to a job
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('addInteraction', function(data, cb)
        Debug(4, "Adding interaction to job: " .. data.jobName)
        local success = job_management_callback_addInteraction(data.jobName, data.interaction)
        Debug(2, "Interaction add status: " .. tostring(success))
        cb({ success = success })
    end)
    
    -- RegisterNUICallback for removing an interaction from a job
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('removeInteraction', function(data, cb)
        Debug(4, "Removing interaction from job: " .. data.jobName)
        local success = job_management_callback_deleteInteraction(data.jobName, data.interaction)
        Debug(2, "Interaction remove status: " .. tostring(success))
        cb({ success = success })
    end)
    
    -- RegisterNUICallback for adding a vehicle to a job
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('addVehicle', function(data, cb)
        Debug(4, "Adding vehicle to job: " .. data.jobName)
        local success = job_management_callback_addVehicle(data.jobName, data.vehicle)
        Debug(2, "Vehicle add status: " .. tostring(success))
        cb({ success = success })
    end)
    
    -- RegisterNUICallback for removing a vehicle from a job
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('removeVehicle', function(data, cb)
        Debug(4, "Removing vehicle from job: " .. data.jobName)
        local success = job_management_callback_deleteVehicle(data.jobName, data.index)
        Debug(2, "Vehicle remove status: " .. tostring(success))
        cb({ success = success })
    end)
    
    -- RegisterNUICallback for fetching current coordinates
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('getCurrentCoords', function(data, cb)
        Debug(4, "Fetching current coords")
        local coords = {
            x = math.round(GetEntityCoords(PlayerPedId()).x),
            y = math.round(GetEntityCoords(PlayerPedId()).y),
            z = math.round(GetEntityCoords(PlayerPedId()).z)
        }
        Debug(3, "Current coords: " .. ESX.DumpTable(coords))
        cb(coords)
    end)
    
    -- RegisterNUICallback for saving armory data for a job
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('saveArmory', function(data, cb)
        Debug(4, "Saving armory for job: " .. data.jobName)
        local success = job_management_callback_saveArmory(data.jobName, data.armory)
        Debug(2, "Armory save status: " .. tostring(success))
        cb({ success = success })
    end)
    
    -- RegisterNUICallback for saving clothing data for a job
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('saveClothing', function(data, cb)
        Debug(4, "Saving clothing for job: " .. data.jobName)
        local success = job_management_callback_saveClothing(data.jobName, data.clothing)
        Debug(2, "Clothing save status: " .. tostring(success))
        cb({ success = success })
    end)
    
    -- RegisterNUICallback for saving stashes data for a job
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('saveStashes', function(data, cb)
        Debug(4, "Saving stashes for job: " .. data.jobName)
        local success = job_management_callback_saveStashes(data.jobName, data.stashes)
        Debug(2, "Stashes save status: " .. tostring(success))
        cb({ success = success })
    end)
    
    -- RegisterNUICallback for saving shop data for a job
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('saveShop', function(data, cb)
        Debug(4, "Saving shop for job: " .. data.jobName)
        local success = job_management_callback_saveShop(data.jobName, data.shop)
        Debug(2, "Shop save status: " .. tostring(success))
        cb({ success = success })
    end)
    
    -- RegisterNUICallback for refreshing jobs and grades
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('refreshJobsAndGrades', function(data, cb)
        local jobs = job_management_callback_getJobs()
        local grades = job_management_callback_getAllGrades()
        cb({ jobs = jobs, grades = grades })
    end)
    
    -- RegisterNUICallback for saving grades data for a job
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('saveGrades', function(data, cb)
        local success = job_management_callback_saveGrades(data.jobName, data.grades)
        cb({ success = success })
    end)
    
    -- RegisterNUICallback for fetching the current heading
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('getCurrentHeading', function(data, cb)
        local ped = PlayerPedId()
        local heading = GetEntityHeading(ped)
        
        cb({ heading = heading })
    end)
    
    -- RegisterNUICallback for saving boss menu data
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('saveBossMenu', function(data, cb)
        local success = job_management_callback_saveBossMenu(data)
        cb({ success = success })
    end)
    
    -- RegisterNUICallback for saving employee data
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback("saveEmployee", function(data, cb)
        local success = job_management_callback_saveEmployee(data)
        cb({ success = success })
    end)
    

    RegisterNUICallback("getCurrentClothes", function(data, cb)
        TriggerEvent('skinchanger:getSkin', function(skin)
            cb( {skin = skin})
        end)
    end)
    