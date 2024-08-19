RegisterServerEvent('ludaro_mananger:onDuty')
AddEventHandler('ludaro_mananger:onDuty', function()
    duty = duty_framework_getDuty(source)
    if duty == false then
        duty_framework_setDuty(source, true)
        showNotification(Locale("on_duty"))
    else
        showNotification(Locale("already_on_duty"))
    end
end)

RegisterServerEvent('ludaro_mananger:offDuty')
AddEventHandler('ludaro_mananger:offDuty', function()
    duty = duty_framework_getDuty(source)
    if duty == true then
        duty_framework_setDuty(source, false)
        showNotification(Locale("off_duty"))
    else
        showNotification(Locale("already_off_duty"))
    end
end)


RegisterNetEvent('esx:playerDropped', function(playerId, reason)
    if duty_framework_getDuty(playerId) then
        duty_framework_setDuty(playerId, false)
    end
end)

RegisterNetEvent('esx:playerLoaded', function(player, xPlayer, isNew)
    if string.contains(xPlayer.getJob().name, "_offduty") then
        duty_framework_setDuty(player, true)
    end
end)
