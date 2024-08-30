RegisterNUICallback('ToggleUI', function(data, cb)
    ui_functions_showAndHideUI()
    cb(nil)
end)


RegisterNUICallback('GetDebugLevel', function(data, cb)
    print("getting debug level")
    
    debugLevel = ui_functions_getDebugLevel()
    
    -- Send back the debug level in a table format
    cb({ DebugLevel = debugLevel })
end)
