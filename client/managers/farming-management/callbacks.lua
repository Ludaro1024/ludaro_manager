function farming_management_getFarmingSpots()
    return lib.callback.await("ludaro_manager:getFarmingSpots", false)
end

function farming_management_saveFarmingSpot(farmingSpot)
    return lib.callback.await("ludaro_manager:saveFarmingSpot", false, farmingSpot)
end

function farming_management_getJobs()
    return lib.callback.await("ludaro_manager:getJobss", false)
end

function farming_management_getAnimations()
    return lib.callback.await("ludaro_manager:getAnimations", false)
end

function farming_management_getSocieties()
    return lib.callback.await("ludaro_manager:getSocieties", false)
end
