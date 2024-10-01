--[[
    getGrade
    Retrieves the job grade of the specified player.

    This function checks the ESX framework to retrieve the grade of the player's job.
    If an `otherplayerid` is provided, it retrieves the grade for that specific player.
    Otherwise, it retrieves the grade for the player identified by `source`.

    @param source (number): The source identifier of the player making the request.
    @param otherplayerid (number, optional): The identifier of another player whose job grade is to be retrieved.
    
    @return number: Returns the grade of the job, or 0 if the player is not found.
]]
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

--[[
    getJob
    Retrieves the job name of the specified player.

    This function checks the ESX framework to retrieve the name of the player's job.
    If an `otherplayerid` is provided, it retrieves the job name for that specific player.
    Otherwise, it retrieves the job name for the player identified by `source`.

    @param source (number): The source identifier of the player making the request.
    @param otherplayerid (number, optional): The identifier of another player whose job name is to be retrieved.
    
    @return string: Returns the name of the job, or "NONE" if the player is not found.
]]
function getJob(source, otherplayerid)
    if ESX then
        if otherplayerid then
            local xPlayer = ESX.GetPlayerFromId(otherplayerid)
            return xPlayer.job.name
        end
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then 
            return xPlayer.job.name 
        else 
            return "NONE" 
        end
    end
end
