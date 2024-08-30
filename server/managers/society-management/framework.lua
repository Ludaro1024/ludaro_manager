--[[
    Checks if the player has enough money for a specific transaction.

    This function checks if the player identified by `source` has enough money to cover the specified amount.

    @param source (number): The source identifier of the player.
    @param amount (number): The amount of money to check against the player's balance.
    
    @return boolean: Returns true if the player has enough money, false otherwise.
]]
function society_management_framework_hasEnoughMoney(source, amount)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getMoney() >= amount then
            return true
        end
    end
    return false
end

--[[
    Withdraws money from the player's account.

    This function removes the specified amount of money from the player's balance.

    @param player (number): The source identifier of the player.
    @param amount (number): The amount of money to withdraw.
    
    @return boolean: Returns true if the money was successfully withdrawn, false otherwise.
]]
function society_management_framework_withdrawMoney(player, amount)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(player)
        xPlayer.removeMoney(amount)
        return true
    end
    return false
end

--[[
    Adds money to the player's account.

    This function adds the specified amount of money to the player's balance.

    @param source (number): The source identifier of the player.
    @param amount (number): The amount of money to add.
    
    @return boolean: Returns true if the money was successfully added, false otherwise.
]]
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
