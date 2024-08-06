function duty_framework_setDuty(id, toggle)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(id)
        
        if xPlayer then
            if Config.ExtraOffDutyJobs then
                if toggle then
                    xPlayer.setJob(xPlayer.getJob().name .. "_offduty", xPlayer.getJob().grade)
                else
                    local jobname = string.gsub(xPlayer.getJob().name, "_offduty", "")
                    xPlayer.setJob(jobname, xPlayer.getJob().grade)
                end
                xPlayer.set('duty', toggle)
            end
        end
    end
end

function duty_framework_getDuty(id)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(id)
        
        if xPlayer then
            return xPlayer.get('duty')
        end
    end
    
    return false
end
