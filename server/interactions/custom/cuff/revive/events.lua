RegisterNetEvent("ludaro_manager:revive", function(id)
    if id == nil then
        return
    end
    TriggerClientEvent('esx_ambulancejob:revive', id)

end)