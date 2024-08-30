--[[
    ludaro_manager:revive

    This event is triggered to revive a specific player by their server ID.

    @param id (number): The server ID of the player to be revived.

    @return nil: This event does not return any values but triggers a client event to revive the player.
]]
RegisterNetEvent("ludaro_manager:revive", function(id)
    if id == nil then
        Debug(2, "No player ID provided for revive event.")
        return
    end
    Debug(3, "Triggering revive event for player ID: " .. id)
    TriggerClientEvent('esx_ambulancejob:revive', id)
end)
