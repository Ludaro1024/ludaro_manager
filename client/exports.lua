--[[
    Exported Functions

    This section of the code exports various functions that can be called from other resources.
    These functions are related to UI management, debugging, refreshing job data, managing duty status,
    and handling player interactions.
]]

--[[
    openTablet

    This exported function shows or hides the UI tablet interface.

    @return nil: This function does not return any values but toggles the visibility of the UI tablet.
]]
exports('openTablet', ui_functions_showAndHideUI)

--[[
    getDebugLevel

    This exported function retrieves the current debug level for the resource. 
    The debug level controls the verbosity of logging and debugging output.

    @return number: Returns the current debug level as an integer.
]]
exports('getDebugLevel', ui_functions_getDebugLevel)

--[[
    refreshEverything

    This exported function refreshes all relevant data, including jobs, interactions, and UI elements. 
    It is typically used when there is a significant change in the game state that requires a full refresh.

    @return nil: This function does not return any values but refreshes all relevant data.
]]
exports('refreshEverything', refresh_RefreshEverything)

--[[
    refreshJobManager

    This exported function re-initializes the job management system. 
    It is used to reload job data and settings, typically after a configuration change or server restart.

    @return nil: This function does not return any values but re-initializes the job management system.
]]
exports('refreshJobManager', job_management_zzload_Init)

--[[
    useInteraction

    This exported function triggers a specific interaction by name. 
    It allows other resources to invoke interactions defined in the InteractionsFunctions table.

    @param name (string): The name of the interaction to trigger.

    @return nil: This function does not return any values but triggers the specified interaction.
]]
exports('useInteraction', UseInteraction)

--[[
    onDuty

    This exported function sets the player as on duty. 
    It is typically used in roleplay servers to manage job status and permissions.

    @return nil: This function does not return any values but sets the player as on duty.
]]
exports('onDuty', onDuty)

--[[
    offDuty

    This exported function sets the player as off duty. 
    It is typically used in roleplay servers to manage job status and permissions.

    @return nil: This function does not return any values but sets the player as off duty.
]]
exports('offDuty', offDuty)

--[[
    getDuty

    This exported function retrieves the player's current duty status (on or off duty).

    @return boolean: Returns true if the player is on duty, false otherwise.
]]
exports('getDuty', getDuty)
