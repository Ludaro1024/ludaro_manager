--[[
    framework_refreshJobs
    Refreshes the jobs within the ESX framework and triggers the refresh of zones for all players.

    This function refreshes the job data within the ESX framework, iterates through all the players,
    and triggers an event to refresh zones for each player. Additionally, it deletes grades with no associated jobs if configured to do so.

    @return void
]]
function framework_refreshJobs()
    if ESX then
        -- Refresh all jobs within the ESX framework
        ESX.RefreshJobs()

        -- Iterate through all players and trigger zone refresh
        for _, playerId in pairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer then
                xPlayer.triggerEvent("ludaro_manager:refreshZones")
            end
        end

        -- Optionally delete grades with no associated job
        if Config.DeleteGradesWithNoJobUponRefreshing then
            sql_DeleteGradesWithNoJobUponRefreshing()
        end
    end
end

--[[
    framework_GetJobPlayers
    Counts the number of players currently assigned to a specific job.

    This function iterates through all players within the ESX framework and counts how many players
    are currently assigned to the specified job.

    @param jobname (string): The name of the job to count players for.
    
    @return number: The count of players with the specified job.
]]
function framework_GetJobPlayers(jobname)
    if ESX then
        local players = ESX.GetPlayers()
        local count = 0

        -- Iterate through all players and count those with the specified job
        for i = 1, #players do
            local xPlayer = ESX.GetPlayerFromId(players[i])
            if xPlayer and xPlayer.job.name == jobname then
                count = count + 1
            end
        end

        return count
    end
end

--[[
    framework_getPlayerName
    Retrieves the name of a player based on their ID.

    This function retrieves the player object from ESX using the provided ID, and then
    returns the player's name.

    @param id (number): The ID of the player whose name is to be retrieved.
    
    @return string: The name of the player, or nil if the player could not be found.
]]
function framework_getPlayerName(id)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(id)
        if xPlayer then
            return xPlayer.getName()
        end
    end
end
