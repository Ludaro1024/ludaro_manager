function duty_framework_setDuty(id, toggle)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(id)
        
        if xPlayer then
            if Config.ExtraOffDutyJobs then
                if toggle then
                    local jobname = string.gsub(xPlayer.getJob().name, "_offduty", "")
                    if Config.ExtraOffDutyJobs then
                    xPlayer.setJob(jobname, xPlayer.getJob().grade)
                    end
                else
              local offdutyjob = duty_sql_getOffDutyJob(xPlayer.getJob().name)
                    if Config.ExtraOffDutyJobs then
                    xPlayer.setJob(offdutyjob, xPlayer.getJob().grade)
                    end
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
