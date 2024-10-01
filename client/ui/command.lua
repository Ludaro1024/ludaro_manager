RegisterCommand(Config.KeyMapping.openTablet[2], function(source, args, rawcommand)
    if ui_callbacks_getAllowed() then
        ui_functions_showAndHideUI()
    else
       EditableFunctions.Notify(Locale("not_allowed"))
    end
end, false)
