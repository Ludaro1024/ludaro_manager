-- Callback to retrieve all farming spots
RegisterNUICallback("getFarmingSpots", function(data, cb)
    local spots = farming_management_getFarmingSpots()  -- Fetch farming spots from the server
    cb({ success = true, farmingSpots = spots })
end)

-- Callback to save a farming spot
RegisterNUICallback("saveFarmingSpot", function(data, cb)
    local farmingSpot = data.farmingSpot
    -- Save the farming spot in the server database
    local success = farming_management_saveFarmingSpot(farmingSpot)

    if success then
        cb({ success = true })
    else
        cb({ success = false, error = "Failed to save farming spot." })
    end
end)

-- Callback to fetch all jobs
RegisterNUICallback("getJobs", function(data, cb)
    local jobs = farming_management_getJobs()  -- Fetch jobs from the server
    cb({ success = true, jobs = jobs })
end)

-- Callback to fetch all animations
RegisterNUICallback("getAnimations", function(data, cb)
    local animations = farming_management_getAnimations()  -- Fetch animations from the server
    cb({ success = true, animations = animations })
end)

-- Callback to fetch all societies
RegisterNUICallback("getSocieties", function(data, cb)
    local societies = farming_management_getSocieties()  -- Fetch societies from the server
    cb({ success = true, societies = societies })
end)

-- Callback to fetch current player coordinates
RegisterNUICallback("getCurrentCoords", function(data, cb)
    local coords = GetEntityCoords(GetPlayerPed(-1))  -- Get current player coords
    cb({ success = true, x = coords.x, y = coords.y, z = coords.z })
end)
