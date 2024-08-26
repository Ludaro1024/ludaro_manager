function getGrade(source, otherplayerid)
    if ESX then
        if otherplayerid then
            local xPlayer = ESX.GetPlayerFromId(otherplayerid)
            return xPlayer.job.grade
        end
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
        return xPlayer.job.grade
        else
            return 0 
        end
    end
end

function getJob(source, otherplayerid)
    if ESX then
        if otherplayerid then
            local xPlayer = ESX.GetPlayerFromId(otherplayerid)
            return xPlayer.job.name
        end
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then return xPlayer.job.name else return "NONE" end
    end
end