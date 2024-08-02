function getPlayerIdentifierFromSource(source)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getIdentifier()
    end
end