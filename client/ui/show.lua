-- command to open the NUI (show index)
uishown = false
RegisterCommand("lt", function(source, args, rawcommand)


SetNuiFocus(not uishown, not uishown)
    SendNUIMessage({
        type = "index",
    })

end)

