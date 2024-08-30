timeout = false
RegisterServerEvent('ludaro_manager:startArrest', function(target)
    SetTimeout(1000, function()
        timeout = false
    end)
    if timeout == false then
        if IsCuffed(target) == false then
            setCuffed(target, true)
            TriggerClientEvent("ludaro_manager:police:cuffPerson", source, target)
            TriggerClientEvent("ludaro_manager:user:getCuffed", target, source)
        else
            setCuffed(target, false)
            TriggerClientEvent("ludaro_manager:police:uncuffPerson", source, target)
            TriggerClientEvent("ludaro_manager:user:getUncuffed", target, source)
        end
    end
end)
