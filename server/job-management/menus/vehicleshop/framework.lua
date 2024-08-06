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

function framework_getGrade(source)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            return xPlayer.getJob().grade
        end
    end
    return 0
end