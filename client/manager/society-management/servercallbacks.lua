function getSocietys()
    return lib.callback.await("ludaro_manager:getSocieties", false)
end
function deleteSociety(society)
    return lib.callback.await("ludaro_manager:deleteSociety", society)
end
function addSociety(society)
    return lib.callback.await("ludaro_manager:addSociety", society)
end
function editSociety(society)
    return lib.callback.await("ludaro_manager:editSociety", society)
end
function withdrawSocietyMoney(society, amount)
    return lib.callback.await("ludaro_manager:withdrawSocietyMoney", society, amount)
end

function depositSocietyMoney(society, amount)
    return lib.callback.await("ludaro_manager:depositSocietyMoney", society, amount)
end

function setSocietyMoney(society, amount)
    return lib.callback.await("ludaro_manager:setSocietyMoney", society, amount)
end