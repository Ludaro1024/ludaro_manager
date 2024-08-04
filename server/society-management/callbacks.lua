lib.callback.register('ludaro_manager:getSocieties', function(source, job)
    return getSocieties(job)
 end)

lib.callback.register('ludaro_manager:deleteSociety', function(source, society)
    return deleteSociety(society)
 end)

lib.callback.register('ludaro_manager:addSociety', function(source, society)
    return addSociety(society)
 end)

lib.callback.register('ludaro_manager:editSociety', function(source, society)
    return editSociety(society)
 end)

lib.callback.register('ludaro_manager:withdrawSocietyMoney', function(source, society, amount)
    return withdrawSocietyMoney(society, amount, source)
 end)

lib.callback.register('ludaro_manager:depositSocietyMoney', function(source, society, amount)
    return depositSocietyMoney(society, amount, source)
 end)

lib.callback.register('ludaro_manager:setSocietyMoney', function(source, society, amount)
    return setSocietyMoney(society, amount)
 end)

 