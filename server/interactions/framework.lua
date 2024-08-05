function framework_getJob(source)
    if ESX then
        xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            return xPlayer.job.name
        end
    end
    return nil
end