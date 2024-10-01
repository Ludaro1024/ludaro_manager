--[[
    RegisterNUICallback for 'ToggleUI'
    This callback is triggered when the UI toggle action is requested from the NUI.
    
    @param data (table): The data sent from the NUI. (Unused in this function)
    @param cb (function): The callback function to be called once the action is complete.
    
    @return nil
]]
RegisterNUICallback('ToggleUI', function(data, cb)
    -- Toggle the UI visibility
    ui_functions_showAndHideUI()
    
    -- Acknowledge the callback without returning any data
    cb(nil)
end)

--[[
    RegisterNUICallback for 'GetDebugLevel'
    This callback is triggered when the NUI requests the current debug level.
    
    @param data (table): The data sent from the NUI. (Unused in this function)
    @param cb (function): The callback function to be called with the debug level.

    @return nil
]]
RegisterNUICallback('GetDebugLevel', function(data, cb)
    -- Retrieve the current debug level
    local debugLevel = ui_functions_getDebugLevel()
    
    -- Send back the debug level in a table format
    cb({ DebugLevel = debugLevel })
end)
