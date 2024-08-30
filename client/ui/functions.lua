uishown = false
canbeshown = false
SetTimeout(1000, function()
    canbeshown = true
end)
function ui_functions_showAndHideUI()
    if canbeshown == false then
        Wait(1000)
    end
    if Config.Tablet then
    ToggleTablet(not uishown)
    end
    SetNuiFocus(not uishown, not uishown)
    uishown = not uishown
    SendNUIMessage({
        type = "index",
    })
end

function ui_functions_closeUIifOpen()
    if uishown then
        ui_functions_showAndHideUI()
    end
end


function ui_functions_getDebugLevel()
    debugLevel = Debuglevel or 0
    return debugLevel
end