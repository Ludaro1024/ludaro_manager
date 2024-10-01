--[[
    RegisterCommand for Opening Interactions Menu

    This command is registered to open the interactions menu for the player. When triggered, it retrieves the available interactions
    for the player, removes any duplicates, and then opens the interactions menu.

    @param source (number): The server ID of the player who triggered the command. (Automatically provided by the FiveM framework)

    @return nil: This function does not return any values but triggers the opening of the interactions menu.
]]
RegisterCommand(Config.KeyMapping.openInteractions[2], function(source)
    Debug(3, "Opening interactions menu for player ID: " .. source)

    -- Retrieve interactions for the player
    local Interactions = interactions_getInteractionsFromPlayer(source)
    Debug(3, "Interactions retrieved for player ID: " .. source)

    -- Remove duplicate interactions
    local InteractionsFixed = removeDoubleExistingValueInFirstKeyTable(Interactions, Config.Interactions)
    Debug(3, "Duplicate interactions removed for player ID: " .. source)

    -- Open the interactions menu with the processed interactions
    openInteractionsMenu(InteractionsFixed)
    Debug(3, "Interactions menu opened for player ID: " .. source)
end)
