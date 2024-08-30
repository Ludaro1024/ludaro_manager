timeout = false

--[[
    ludaro_manager:startArrest

    This event is triggered to start the process of arresting (cuffing or uncuffing) a target player.
    It checks if the target is already cuffed and either cuffs or uncuffs them accordingly.

    @param target (number): The server ID of the target player to cuff or uncuff.

    @return nil: This event does not return any values but triggers client events to manage cuffing or uncuffing.
]]
RegisterServerEvent('ludaro_manager:startArrest', function(target)
    Debug(3, "Received request to start arrest process for target: " .. target)
    
    SetTimeout(1000, function()
        timeout = false
        Debug(3, "Timeout reset.")
    end)
    
    if timeout == false then
        timeout = true
        if IsCuffed(target) == false then
            Debug(2, "Target is not cuffed. Cuffing target: " .. target)
            setCuffed(target, true)
            TriggerClientEvent("ludaro_manager:police:cuffPerson", source, target)
            TriggerClientEvent("ludaro_manager:user:getCuffed", target, source)
        else
            Debug(2, "Target is already cuffed. Uncuffing target: " .. target)
            setCuffed(target, false)
            TriggerClientEvent("ludaro_manager:police:uncuffPerson", source, target)
            TriggerClientEvent("ludaro_manager:user:getUncuffed", target, source)
        end
    else
        Debug(3, "Cuff action is still under timeout.")
    end
end)
