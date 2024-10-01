--[[
    Initialize Revive Interaction

    This script initializes the revive interaction for players. It waits for the InteractionFunctions to exist,
    then sets up the "revive" function. The revive function checks if the player has a medikit and if the closest player
    is dead or dying. If these conditions are met, it plays an animation and revives the closest player.

    @return nil: This script does not return any values but initializes the revive interaction.
]]

-- Wait for InteractionFunctions to exist
while not InteractionsFunctions do
    Debug(3, "Waiting for InteractionsFunctions to be initialized.")
    Wait(1)
end

Debug(3, "Initializing revive interaction.")

InteractionsFunctions["revive"] = function()
    Debug(3, "Revive interaction triggered.")
    
    local closestPlayer = framework_GetClosestPlayer()
    if not closestPlayer then
        Debug(2, "No closest player found to revive.")
        EditableFunctions.Notify("No players nearby to revive.")
        return
    end

    isBusy = true

    ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
        Debug(3, "Checking if player has a medikit. Quantity: " .. quantity)
        
        if quantity > 0 then
            local closestPlayerPed = GetPlayerPed(closestPlayer)

            if IsPedDeadOrDying(closestPlayerPed, 1) then
                Debug(3, "Player is critically injured, starting revive process.")
                local playerPed = PlayerPedId()
                local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
                EditableFunctions.Notify("Revive in Progress..")

                for i = 1, 15 do
                    Wait(900)

                    ESX.Streaming.RequestAnimDict(lib, function()
                        TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
                        RemoveAnimDict(lib)
                    end)
                end

                TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
                Debug(3, "Medikit used. Reviving player with server ID: " .. GetPlayerServerId(closestPlayer))
                TriggerServerEvent('ludaro_manager:revive', GetPlayerServerId(closestPlayer))

            else
                Debug(2, "Player is not critically injured.")
                EditableFunctions.Notify("Player isn't critically injured.")
            end
        else
            Debug(2, "Player does not have a medikit.")
            EditableFunctions.Notify("You don't have a medikit.")
        end

        isBusy = false
        Debug(3, "Revive process completed or interrupted.")
    end, 'medikit')
end
