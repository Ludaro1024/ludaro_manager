--[[
    framework_GetClosestPlayer

    This function retrieves the closest player within a 3.0 unit radius to the local player.
    It ignores the player if they are too far or if the closest player is the local player themselves.

    @return number: Returns the player's ID if a player is found within the range, or `nil` if no player is close enough.
]]
function framework_GetClosestPlayer()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
    Debug(3, "Checking for closest player.")
    
    if closestPlayer ~= -1 and closestDistance <= 3.0 and closestPlayer ~= PlayerPedId() then
        Debug(2, "Closest player found within distance: " .. closestDistance)
        return closestPlayer
    else
        Debug(2, "No players nearby or player is too far.")
        return nil
    end
end
