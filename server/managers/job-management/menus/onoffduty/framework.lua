--[[
    Set Duty Status

    This function sets the duty status of a player. If the player is going on duty,
    their job is updated to the on-duty version. If going off duty, the job is set to the off-duty version.

    @param id (number): The source identifier of the player.
    @param toggle (boolean): The desired duty status (true for on duty, false for off duty).
]]
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

--[[
    Get Duty Status

    This function retrieves the current duty status of a player.

    @param id (number): The source identifier of the player.
    
    @return boolean: Returns true if the player is on duty, false otherwise.
]]
function duty_framework_getDuty(id)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(id)
        
        if xPlayer then
            return xPlayer.get('duty')
        end
    end
    
    return false
end
