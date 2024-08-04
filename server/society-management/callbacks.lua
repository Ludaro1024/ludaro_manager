lib.callback.register('ludaro_manager:getSocieties', function(source, job)
    return society_management_callbacks_getSocieties(job)
 end)

lib.callback.register('ludaro_manager:deleteSociety', function(source, society)
    return society_management_callback_deleteSociety(society)
 end)

lib.callback.register('ludaro_manager:addSociety', function(source, society)
    return society_management_callback_addSociety(society)
 end)

lib.callback.register('ludaro_manager:editSociety', function(source, society)
    return society_managment_callback_editSociety(society)
 end)

lib.callback.register('ludaro_manager:withdrawSocietyMoney', function(source, society, amount)
    return society_management_callback_withdrawSocietyMoney(society, amount, source)
 end)

lib.callback.register('ludaro_manager:depositSocietyMoney', function(source, society, amount)
    return society_management_callback_depositSocietyMoney(society, amount, source)
 end)

lib.callback.register('ludaro_manager:setSocietyMoney', function(source, society, amount)
    return society_management_callback_setSocietyMoney(society, amount)
 end)

 