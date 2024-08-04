function getNPCData()
    return lib.callback.await("ludaro_manager:getNPCData", false)
end

function getJobandGrade(source) 
    return lib.callback.await("ludaro_manager:getJobandGrade", false, source)
end