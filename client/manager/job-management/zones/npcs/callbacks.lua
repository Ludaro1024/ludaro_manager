function jobmanagement_zones_npcs_getNPCData()
    return lib.callback.await("ludaro_manager:getNPCData", false)
end

function jobmanagement_zones_npcs_getJobandGrade(source) 
    return lib.callback.await("ludaro_manager:getJobandGrade", false, source)
end