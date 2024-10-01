--[[
    Generate a Vehicle License Plate

    This function generates a random license plate, optionally starting with a specified prefix. The plate is 8 characters long.

    @param prefix (string, optional): The prefix to use for the plate. If provided, the remaining characters are randomly generated.
    
    @return string: Returns the generated license plate.
]]
function framework_generatePlate(prefix)
    local plate = ""
    local characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    if prefix then
        local prefixLength = math.min(#prefix, 8)
        for i = 1, 8 - prefixLength do
            local randomIndex = math.random(1, #characters)
            prefix = prefix .. string.sub(characters, randomIndex, randomIndex)
        end
        plate = prefix
    else
        for i = 1, 8 do
            local randomIndex = math.random(1, #characters)
            plate = plate .. string.sub(characters, randomIndex, randomIndex)
        end
    end
    
    return plate
end

--[[
    Get the Grade of a Player's Job

    This function retrieves the grade of the job associated with the player.

    @param source (number): The source identifier of the player.
    
    @return number: Returns the grade of the player's job, or 0 if not found.
]]
function framework_getGrade(source)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            return xPlayer.getJob().grade
        end
    end
    return 0
end

--[[
    Check if a Player Has Enough Money

    This function checks whether the player has enough money to cover a specified price.

    @param source (number): The source identifier of the player.
    @param price (number): The price to check against the player's available money.
    
    @return boolean: Returns true if the player has enough money, false otherwise.
]]
function job_management_vehicleshop_hasEnoughMoney(source, price)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            return xPlayer.getMoney() >= price
        end
    end
    return false
end
