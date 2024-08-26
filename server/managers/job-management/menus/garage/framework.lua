function framework_getPlayerIdenntifierFromSource(source)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getIdentifier()
    end
end