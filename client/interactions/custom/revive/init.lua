-- wait for IntneractionFunctions to exist
    while not InteractionsFunctions do
        Wait(1)
    end
    
    InteractionsFunctions["revive"] = function()
        closestPlayer = framework_GetClosestPlayer()
        isBusy = true

        ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
            if quantity > 0 then
                local closestPlayerPed = GetPlayerPed(closestPlayer)
    
                if IsPedDeadOrDying(closestPlayerPed, 1) then
                    local playerPed = PlayerPedId()
                    local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
                    ESX.ShowNotification("Revive in Progress..")
    
                    for i = 1, 15 do
                        Wait(900)
    
                        ESX.Streaming.RequestAnimDict(lib, function()
                            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
                            RemoveAnimDict(lib)
                        end)
                    end
    
                    TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
                    TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
                else
                    ESX.ShowNotification("Player isnt critically injured")
                end
            else
                ESX.ShowNotification("You dont have a medikit")
            end
            isBusy = false
        end, 'medikit')
        
    end