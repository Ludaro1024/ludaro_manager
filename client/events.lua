--[[
    ludaro_manager:Notify

    This event is triggered to send a notification to a player. When this event is triggered,
    it calls the `Notify` function from the `EditableFunctions` table, 

    @param msg (string): The message to be displayed in the notification.

    @return nil: This function does not return any values but triggers the display of a notification.
]]
RegisterNetEvent("ludaro_manager:Notify", function(msg)
    Debug(3, "Notification event received with message: " .. msg)

    -- Call the Notify function from EditableFunctions to display the notification
    EditableFunctions.Notify(msg)
end)
