function refreshJobs()
    if ESX then
        ESX.RefreshJobs()
    end
end

function GetJobPlayers(jobname)
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


function getPlayerName(id)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(id)
        return xPlayer.getName()
    end
end