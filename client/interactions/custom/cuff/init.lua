--[[
    loadanimdict

    This function loads an animation dictionary into memory, ensuring it's ready for use.
    It waits until the dictionary is fully loaded before returning.

    @param animDict (string): The name of the animation dictionary to load.

    @return nil: This function does not return any values, but ensures the animation dictionary is loaded.
]]
function loadanimdict(animDict)
    Debug(3, "Requesting animation dictionary: " .. animDict)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(1)
    end
    Debug(2, "Animation dictionary loaded: " .. animDict)
end

--[[
    Cuff Interaction

    This function handles the interaction to cuff a nearby player. It checks for the closest player,
    and if one is found within range, it triggers the server event to start the cuffing process.

    @return nil: This function does not return any values but triggers a server event to start the cuffing process.
]]
InteractionsFunctions["cuff"] = function()
    closestplayer = framework_GetClosestPlayer()

    if closestplayer == nil then
        EditableFunctions.Notify(Locale("no_players_nearby"))
        Debug(2, "No players nearby to cuff.")
        return
    end

    Debug(2, "Cuffing player with server ID: " .. GetPlayerServerId(closestplayer))
    TriggerServerEvent("ludaro_manager:startArrest", GetPlayerServerId(closestplayer))
end

--[[
    ludaro_manager:police:cuffPerson

    This event is triggered to perform the cuffing animation on a target player. It attaches the target to the player 
    and plays the appropriate animations for both parties.

    @param target (number): The server ID of the target player to be cuffed.

    @return nil: This event does not return any values but plays the cuffing animation on the target player.
]]
RegisterNetEvent("ludaro_manager:police:cuffPerson", function(target)
    Debug(3, "Cuffing player with server ID: " .. target)
    ped = GetPlayerPed(GetPlayerFromServerId(target))
    AttachEntityToEntity(ped, PlayerPedId(), 11816, -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
    loadanimdict('mp_arresting')
    loadanimdict('mp_arrest_paired')
    TaskPlayAnim(ped, 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750, 2, 0, 0, 0, 0)
    ClearPedTasks(PlayerPedId())
    TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
    loadanimdict('mp_arrest_paired')
    TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8, 3750, 2, 0, 0, 0, 0)
end)

--[[
    ludaro_manager:user:getCuffed

    This event is triggered when a player is being cuffed by another player. It handles the animations and 
    entity attachment from the perspective of the player getting cuffed.

    @param target (number): The server ID of the player who is cuffing the current player.

    @return nil: This event does not return any values but plays the cuffing animation on the player being cuffed.
]]
RegisterNetEvent("ludaro_manager:user:getCuffed", function(target)
    Debug(3, "Getting cuffed by player with server ID: " .. target)
    ped = GetPlayerPed(GetPlayerFromServerId(target))
    AttachEntityToEntity(PlayerPedId(), ped, 11816, -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
    loadanimdict('mp_arresting')
    loadanimdict('mp_arrest_paired')
    TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750, 2, 0, 0, 0, 0)
    ClearPedTasks(PlayerPedId())
    TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
    loadanimdict('mp_arrest_paired')
    TaskPlayAnim(ped, 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8, 3750, 2, 0, 0, 0, 0)
end)

--[[
    ludaro_manager:police:uncuffPerson

    This event is triggered to uncuff a player. It plays the uncuff animation on both the player and the target,
    and detaches the entities after the animation completes.

    @param id (number): The server ID of the player to be uncuffed.

    @return nil: This event does not return any values but plays the uncuffing animation and detaches the entities.
]]
RegisterNetEvent("ludaro_manager:police:uncuffPerson", function(id)
    Debug(3, "Uncuffing player with server ID: " .. id)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(id))
    local playerPed = PlayerPedId()

    RequestAnimDict('mp_arresting')

    while not HasAnimDictLoaded('mp_arresting') do
        Citizen.Wait(10)
    end

    TaskPlayAnim(targetPed, 'mp_arresting', 'b_uncuff', 8.0, -8, -1, 2, 0, 0, 0, 0)
    TaskPlayAnim(playerPed, 'mp_arresting', 'a_uncuff', 8.0, -8, -1, 2, 0, 0, 0, 0)
    Wait(5000)
    DetachEntity(targetPed, false, true)
    ClearPedTasks(PlayerPedId())
    ClearPedTasksImmediately(PlayerPedId())
end)

--[[
    ludaro_manager:user:getUncuffed

    This event is triggered when a player is being uncuffed by another player. It handles the animations and 
    entity detachment from the perspective of the player being uncuffed.

    @param id (number): The server ID of the player who is uncuffing the current player.

    @return nil: This event does not return any values but plays the uncuffing animation and detaches the entities.
]]
RegisterNetEvent("ludaro_manager:user:getUncuffed", function(id)
    Debug(3, "Getting uncuffed by player with server ID: " .. id)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(id))
    local playerPed = PlayerPedId()

    RequestAnimDict('mp_arresting')

    while not HasAnimDictLoaded('mp_arresting') do
        Citizen.Wait(10)
    end

    TaskPlayAnim(playerPed, 'mp_arresting', 'b_uncuff', 8.0, -8, -1, 2, 0, 0, 0, 0)
    TaskPlayAnim(targetPed, 'mp_arresting', 'a_uncuff', 8.0, -8, -1, 2, 0, 0, 0, 0)
    Wait(5000)
    DetachEntity(PlayerPedId(), false, true)
    ClearPedTasks(PlayerPedId())
    ClearPedTasksImmediately(PlayerPedId())
end)
