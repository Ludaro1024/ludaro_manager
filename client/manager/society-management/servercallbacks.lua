function society_management_callback_getSocietys()
    return lib.callback.await("ludaro_manager:getSocieties", false)
end
function society_management_callback_deleteSociety(society)
    return lib.callback.await("ludaro_manager:deleteSociety", false, society)
end
function society_management_callback_addSociety(society)
    return lib.callback.await("ludaro_manager:addSociety", false,society)
end
function society_managment_callback_editSociety(society)
    return lib.callback.await("ludaro_manager:editSociety", false, society)
end
function society_management_callback_withdrawSocietyMoney(society, amount)
    return lib.callback.await("ludaro_manager:withdrawSocietyMoney",  false, society, amount)
end

function society_management_callback_depositSocietyMoney(society, amount)
    return lib.callback.await("ludaro_manager:depositSocietyMoney", false,society, amount)
end

function society_management_callback_setSocietyMoney(society, amount)
    return lib.callback.await("ludaro_manager:setSocietyMoney", false, society, amount)
end