RegisterNUICallback('getSocietys', function(data, cb)
    societies = getSocietys()
    print(ESX.DumpTable(societies))
    cb({societies})
end)

RegisterNUICallback('addSociety', function(data, cb)

    addSociety(data.society)
end)

RegisterNUICallback('deleteSociety', function(data, cb)

    deleteSociety(data.society)
end)

RegisterNUICallback('editSociety', function(data, cb)
    editSociety(data.society)
end)

RegisterNUICallback('withdrawSocietyMoney', function(data, cb)
    withdrawSocietyMoney(data.society, data.amount)
end)

RegisterNUICallback('depositSocietyMoney', function(data, cb)
    depositSocietyMoney(data.society, data.amount)
end)

RegisterNUICallback('setSocietyMoney', function(data, cb)
    setSocietyMoney(data.society, data.amount)
end)