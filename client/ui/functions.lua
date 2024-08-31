local isUIShown = false
local canBeShown = false

--[[
    Initialize UI availability
    Sets a timeout to allow the UI to be shown after a delay of 1 second.
]]
SetTimeout(1000, function()
    canBeShown = true
end)

--[[
    ui_functions_showAndHideUI
    Toggles the visibility of the UI and the tablet (if configured).
    Waits for UI to be available before toggling.

    @return nil
]]
function ui_functions_showAndHideUI()
    -- Ensure the UI can be shown, wait if necessary
    if not canBeShown then
        Wait(1000)
    end

    -- Toggle the UI state
    SetNuiFocus(not isUIShown, not isUIShown)
    isUIShown = not isUIShown

    -- Send the UI message to the NUI
    SendNUIMessage({
        type = "index",
    })

    -- Toggle the tablet if the config allows it
    if Config.Tablet then
        ToggleTablet(isUIShown)
    end
end

--[[
    ui_functions_closeUIifOpen
    Closes the UI if it is currently open.

    @return nil
]]
function ui_functions_closeUIifOpen()
    if isUIShown then
        ui_functions_showAndHideUI()
    end
end

--[[
    ui_functions_getDebugLevel
    Retrieves the current debug level.

    @return number: The current debug level.
]]
function ui_functions_getDebugLevel()
    return Debuglevel or 0
end
