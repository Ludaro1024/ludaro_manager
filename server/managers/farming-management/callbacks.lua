lib.callback.register("ludaro_manager:getFarmingSpots", function()
    return farming_management_getFarmingSpotsFromDB()  -- Fetch from the database
end)

lib.callback.register("ludaro_manager:saveFarmingSpot", function(source, farmingSpot)
    return farming_management_saveFarmingSpotToDB(farmingSpot)  -- Save to the database
end)

lib.callback.register("ludaro_manager:getJobss", function()
    return farming_management_getJobsFromDB()  -- Fetch jobs from the database
end)

lib.callback.register("ludaro_manager:getAnimations", function()
    return farming_management_getAnimationsFromDB()  -- Fetch animations from the database
end)

lib.callback.register("ludaro_manager:getSocieties", function()
    return farming_management_getSocietiesFromDB()  -- Fetch societies from the database
end)
