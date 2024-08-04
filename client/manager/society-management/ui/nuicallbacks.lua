RegisterNUICallback('getSocietys', function(data, cb)
    societies = society_management_callback_getSocietys()
    (ESX.DumpTable(societies))
    cb({societies})
end)

RegisterNUICallback('addSociety', function(data, cb)

    society_management_callback_addSociety(data.society)
end)

RegisterNUICallback('deleteSociety', function(data, cb)

    society_management_callback_deleteSociety(data.society)
end)

RegisterNUICallback('editSociety', function(data, cb)
    society_managment_callback_editSociety(data.society)
end)

RegisterNUICallback('withdrawSocietyMoney', function(data, cb)
    society_management_callback_withdrawSocietyMoney(data.society, data.amount)
end)

RegisterNUICallback('depositSocietyMoney', function(data, cb)
    society_management_callback_depositSocietyMoney(data.society, data.amount)
end)

RegisterNUICallback('setSocietyMoney', function(data, cb)
    society_management_callback_setSocietyMoney(data.society, data.amount)
end)