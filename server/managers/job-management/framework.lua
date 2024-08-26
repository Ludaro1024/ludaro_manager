function framework_refreshJobs()
    if ESX then
        ESX.RefreshJobs()
        for k,v in pairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(v)
            if xPlayer then
               xPlayer.triggerEvent("ludaro_manager:refreshZones")
            end
        end

        if Config.DeleteGradesWithNoJobUponRefreshing then
            sql_DeleteGradesWithNoJobUponRefreshing()
        end
    end
end

function framework_GetJobPlayers(jobname)
    if ESX then
        local players = ESX.GetPlayers()
        local count = 0
        for i = 1, #players, 1 do
            local xPlayer = ESX.GetPlayerFromId(players[i])
            if xPlayer.job.name == jobname then
                count = count + 1
            end
        end
        return count
    end
end


function framework_getPlayerName(id)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(id)
        return xPlayer.getName()
    end
end