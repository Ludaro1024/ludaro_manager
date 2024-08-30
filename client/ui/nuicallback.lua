RegisterNUICallback('ToggleUI', function(data, cb)
    ui_functions_showAndHideUI()
    cb(nil)
end)


RegisterNUICallback('GetDebugLevel', function(data, cb)
    print("getting debug level")
    
    debugLevel = Debuglevel or 0
    
    print("Debug level is:", debugLevel)
    
    -- Send back the debug level in a table format
    cb({ DebugLevel = debugLevel })
end)
