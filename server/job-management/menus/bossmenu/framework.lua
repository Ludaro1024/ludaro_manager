function getGrade(source, otherplayerid)
    if ESX then
        if otherplayerid then
            local xPlayer = ESX.GetPlayerFromId(otherplayerid)
            return xPlayer.job.grade
        end
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.job.grade
    end
end

function getJob(source, otherplayerid)
    if ESX then
        if otherplayerid then
            local xPlayer = ESX.GetPlayerFromId(otherplayerid)
            return xPlayer.job.name
        end
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.job.name
    end
end