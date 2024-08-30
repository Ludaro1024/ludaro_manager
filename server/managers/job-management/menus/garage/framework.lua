--[[
    Retrieves the identifier of a player based on their source ID.

    This function checks the ESX framework to get the player's identifier.
    
    @param source (number): The source identifier of the player.
    
    @return string: The player's identifier, or nil if not found.
]]
function framework_getPlayerIdenntifierFromSource(source)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getIdentifier()
    end
end
