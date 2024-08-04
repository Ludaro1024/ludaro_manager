function getSocietys()
    return lib.callback.await("ludaro_manager:getSocieties", false)
end
function deleteSociety(society)
    return lib.callback.await("ludaro_manager:deleteSociety", false, society)
end
function addSociety(society)
    return lib.callback.await("ludaro_manager:addSociety", false,society)
end
function editSociety(society)
    return lib.callback.await("ludaro_manager:editSociety", false, society)
end
function withdrawSocietyMoney(society, amount)
    return lib.callback.await("ludaro_manager:withdrawSocietyMoney",  false, society, amount)
end

function depositSocietyMoney(society, amount)
    return lib.callback.await("ludaro_manager:depositSocietyMoney", false,society, amount)
end

function setSocietyMoney(society, amount)
    return lib.callback.await("ludaro_manager:setSocietyMoney", false, society, amount)
end