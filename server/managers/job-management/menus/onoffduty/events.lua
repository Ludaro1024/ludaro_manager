--[[
    Event: Player Goes On Duty

    This event handler is triggered when a player attempts to go on duty.
    If the player is not already on duty, their duty status is updated, and they receive a notification.
]]
RegisterServerEvent('ludaro_mananger:onDuty')
AddEventHandler('ludaro_mananger:onDuty', function()
    local src = source
    local duty = duty_framework_getDuty(src)
    
    if duty == false then
        duty_framework_setDuty(source, true)
        showNotification(src, Locale("on_duty"))
    else
        showNotification(src, Locale("already_on_duty"))
    end
end)

--[[
    Event: Player Goes Off Duty

    This event handler is triggered when a player attempts to go off duty.
    If the player is on duty, their duty status is updated, and they receive a notification.
]]
RegisterServerEvent('ludaro_mananger:offDuty')
AddEventHandler('ludaro_mananger:offDuty', function()
    local src = source
    local duty = duty_framework_getDuty(source)
    
    if duty == true or duty == nil then
        duty_framework_setDuty(source, false)
        showNotification(src, Locale("off_duty"))
    else
        showNotification(src, Locale("already_off_duty"))
    end
end)

--[[
    Event: Player Drops from the Server

    This event handler is triggered when a player leaves the server.
    If the player was on duty, their duty status is reset to off.
]]
RegisterNetEvent('esx:playerDropped', function(playerId, reason)
    if duty_framework_getDuty(playerId) then
        duty_framework_setDuty(playerId, false)
    end
end)

--[[
    Event: Player Loads into the Server

    This event handler is triggered when a player loads into the server.
    If the player is loading in with an off-duty job, their duty status is set to on.
]]
RegisterNetEvent('esx:playerLoaded', function(player, xPlayer, isNew)
    if xPlayer then
        if string.find(xPlayer.getJob().name, "_offduty") then
            duty_framework_setDuty(player, true)
        end
    end
end)
