--[[
    CreateThread to refresh everything upon job change.

    This thread waits until ESX and the player's job data are fully loaded,
    then it sets the job and grade variables. It also registers an event listener
    for the 'esx:setJob' event to update the job and grade, and trigger the refresh function.
]]
CreateThread(function()
    -- Wait until ESX and player data are available and valid
    repeat 
        Wait(0) 
    until ESX ~= nil and ESX.GetPlayerData() ~= nil and ESX.GetPlayerData().job ~= nil

    -- Initialize job and grade with the current player data
    local job = ESX.GetPlayerData().job.name
    local grade = ESX.GetPlayerData().job.grade

    -- Event listener for job changes
    RegisterNetEvent('esx:setJob', function(newJob, lastJob)
        job = newJob.name
        grade = newJob.grade
        refresh_RefreshEverything()  -- Call the function to refresh everything
    end)
end)
