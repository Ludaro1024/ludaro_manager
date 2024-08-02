job = ESX.GetPlayerData().job.name
grade = ESX.GetPlayerData().job.grade

RegisterNetEvent('esx:setJob', function(job, lastJob)
    job = job.name
    grade = job.grade
    RefreshEverything()
end)