-- jobmanagement_zones_npcs_getNPCData
-- Retrieves NPC data via a callback
-- @return table: Returns the NPC data
lib.callback.register("ludaro_manager:getNPCData", function(source, data)
    return jobmanagement_zones_npcs_getNPCData()
 end)

-- jobmanagement_zones_npcs_getJobandGrade
-- Retrieves the job and grade of a player via a callback
-- @param source: The source identifier of the player (optional)
-- @return table: Returns the job and grade data of the player
function jobmanagement_zones_npcs_getJobandGrade(source)
    return lib.callback.await("ludaro_manager:getJobandGrade", false, source)
end

function jobmanagement_zones_getDuty()
    return lib.callback.await("ludaro_manager:getDuty", false)
end