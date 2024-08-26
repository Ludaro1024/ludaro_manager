function user_management_updateUserInFramework(user)
    -- Fetch the ESX player object using the identifier

    local xPlayer = ESX.GetPlayerFromIdentifier(user.identifier)

    if not xPlayer then
        data = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
            ['@identifier'] = user.identifier
        })

        if data[1] then
            if user.group and user.group ~= data[1].group then
                MySQL.Async.execute("UPDATE users SET `group` = @group WHERE identifier = @identifier", {
                    ['@group'] = user.group,
                    ['@identifier'] = user.identifier
                })
            end

            if user.job and user.job_grade and (user.job ~= data[1].job or data.job_grade ~= user.job_grade) then
                MySQL.Async.execute("UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier",
                    {
                        ['@job'] = user.job,
                        ['@job_grade'] = user.job_grade,
                        ['@identifier'] = user.identifier
                    })
            end

            if user.firstname and user.lastname and (user.lastname ~= data[1].lastname or user.firstname ~= user.firstname) then
                MySQL.Async.execute(
                    "UPDATE users SET firstname = @firstname, lastname = @lastname WHERE identifier = @identifier", {
                        ['@firstname'] = user.firstname,
                        ['@lastname'] = user.lastname,
                        ['@identifier'] = user.identifier
                    })
            end

            return true
        else
            return false
        end
    else
        -- Update player's group
        if user.group and user.group ~= xPlayer.getGroup() then
            xPlayer.setGroup(user.group)
            -- 
        end

        -- Update player's job and job grade
        if user.job and user.job_grade then
            local jobInfo = xPlayer.getJob()
            if user.job ~= jobInfo.name or user.job_grade ~= jobInfo.grade then
                xPlayer.setJob(user.job, user.job_grade)
                -- 
            end
        end

        -- Update player's firstname and lastname (if ESX has support for this)
        if user.firstname and user.lastname then
            xPlayer.setName(user.firstname .. " " .. user.lastname)
            -- 
        end
    end

    return true
end
