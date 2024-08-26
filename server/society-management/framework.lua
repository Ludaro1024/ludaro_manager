function society_management_framework_hasEnoughMoney(source, amount)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getMoney() >= amount then
            return true
        end
    end
    return false
end

function society_management_framework_withdrawMoney(player, amount)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(player)
        xPlayer.removeMoney(amount)
        return true
    end
    return false
end

function society_management_framework_addMoney(source, amount)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if amount ~= nil then
        xPlayer.addMoney(amount)
        return true
        end
    end
    return false
end
