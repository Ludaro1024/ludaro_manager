function user_management_updateUserInFramework(user)
    -- Fetch the ESX player object using the identifier
    local xPlayer = ESX.GetPlayerFromIdentifier(user.identifier)
    
    if not xPlayer then
        -- print(("User with identifier %s not found!"):format(user.identifier))
        return false
    end

    -- Update player's group
    if user.group and user.group ~= xPlayer.getGroup() then
        xPlayer.setGroup(user.group)
        -- print(("Updated group for %s to %s"):format(user.identifier, user.group))
    end

    -- Update player's job and job grade
    if user.job and user.job_grade then
        local jobInfo = xPlayer.getJob()
        if user.job ~= jobInfo.name or user.job_grade ~= jobInfo.grade then
            xPlayer.setJob(user.job, user.job_grade)
            -- print(("Updated job for %s to %s with grade %d"):format(user.identifier, user.job, user.job_grade))
        end
    end

    -- Update player's firstname and lastname (if ESX has support for this)
    if user.firstname and user.lastname then
        xPlayer.setName(user.firstname .. " " .. user.lastname)
        -- print(("Updated name for %s to %s %s"):format(user.identifier, user.firstname, user.lastname))
    end

    return true
end
