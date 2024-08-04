function hasEnoughMoney(source, amount)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getMoney() >= amount then
            return true
        end
    end
    return false
end

function withdrawMoney(player, amount)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(player)
        xPlayer.removeMoney(amount)
        return true
    end
    return false
end

function addMoney(source, amount)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addMoney(amount)
        return true
    end
    return false
end