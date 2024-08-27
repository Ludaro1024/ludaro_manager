-- function to refrsh everythhing upon job change
CreateThread(function()
    repeat Wait(0) until ESX ~= nil and ESX.GetPlayerData() ~= nil and ESX.GetPlayerData().job ~= nil
    job = ESX.GetPlayerData().job.name
    grade = ESX.GetPlayerData().job.grade
    
    RegisterNetEvent('esx:setJob', function(job, lastJob)
        job = job.name
        grade = job.grade
        refresh_RefreshEverything()
    end)

end)
