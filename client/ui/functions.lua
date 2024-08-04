uishown = false
function ui_functions_showAndHideUI()
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

