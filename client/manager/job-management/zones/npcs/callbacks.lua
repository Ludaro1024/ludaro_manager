function getNPCData()
    return lib.callback.await("ludaro_manager:getNPCData", false)
end

function getJobandGrade() 
    return lib.callback.await("ludaro_manager:getJobandGrade", false)
end