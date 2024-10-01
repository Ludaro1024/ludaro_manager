--[[
    Sends a notification to the player.

    This function triggers a client-side event to display a notification to the player.
    It first checks if the ESX framework is initialized. If ESX is available, it tries to
    retrieve the player object and trigger the notification through ESX. If ESX is not initialized,
    or if the player cannot be retrieved, it directly triggers the client event.

    @param source (number): The source identifier of the player.
    @param msg (string): The message to be displayed in the notification.
]]
function showNotification(source, msg)
    Debug(3, "Attempting to send a notification.")

    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            xPlayer.triggerEvent("ludaro_manager:Notify", msg)
            Debug(2, string.format("Notification sent to player %d via ESX: %s", source, msg))
        else
            Debug(1, string.format("Failed to retrieve player data for source %d via ESX.", source))
            TriggerClientEvent("ludaro_manager:Notify", source, msg)
            Debug(2, string.format("Notification sent directly to player %d: %s", source, msg))
        end
    else
        TriggerClientEvent("ludaro_manager:Notify", source, msg)
        Debug(1, "ESX is not initialized. Notification sent directly.")
    end
end
