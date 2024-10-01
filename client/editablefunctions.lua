--[[
    EditableFunctions

    This table contains functions that can be customized to fit different implementations within the ESX framework.
    Each function is designed to perform a specific task, like showing notifications or opening a stash, 
    with the ability to be easily adapted or extended.

    Functions:
        - ShowHelpNotification: Displays a help notification to the player.
        - Notify: Sends a standard notification to the player.
        - OpenStash: Opens an inventory stash for a specific job. This function currently provides a placeholder 
          for implementing custom inventory systems.
]]

EditableFunctions = {

    --[[
        ShowHelpNotification

        This function displays a help notification to the player. Help notifications typically appear
        in the top left corner of the screen, providing contextual tips or instructions.

        @param msg (string): The message to be displayed in the help notification.

        @return nil: This function does not return any values.
    ]]
    ShowHelpNotification = function(msg)
        ESX.ShowHelpNotification(msg)
    end,

    --[[
        Notify

        This function sends a standard notification to the player. Notifications usually appear
        in the bottom right corner of the screen and are used to inform the player about various events.

        @param msg (string): The message to be displayed in the notification.

        @return nil: This function does not return any values.
    ]]
    Notify = function(msg)
        ESX.ShowNotification(msg)
    end,

    --[[
        OpenStash

        This function is a placeholder for opening an inventory stash associated with a specific job.
        It checks if the stash is official and the weight limit of the stash. Currently, this function 
        provides a notification indicating that an inventory system is not implemented and should be 
        customized according to the specific server's inventory system.

        @param data (table): A table containing information about the stash, such as whether it is official 
                             and its weight limit.
        @param jobname (string): The name of the job associated with the stash.

        @return nil: This function does not return any values but is intended to be customized.
    ]]
    OpenStash = function(data, jobname)
        local isoffical = data.isoffical
        local weight = data.weight

        -- Placeholder notification indicating that the inventory system is not implemented
        EditableFunctions.Notify('Inventory system not found. Implement your own..')

        -- Custom implementation for opening the stash can be added here
        -- Example: TriggerServerEvent('my_inventory:openStash', jobname, isoffical, weight)
    end
}
