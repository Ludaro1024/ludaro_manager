function getGrade(source)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.job.grade
    end
end

function getJob(source)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.job.name
    end
end