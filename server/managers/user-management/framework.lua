function user_management_updateUserInFramework(user)
    -- Fetch the ESX player object using the identifier

    local xPlayer = ESX.GetPlayerFromIdentifier(user.identifier)

    if not xPlayer then
        -- change it in sql

        data = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
            ['@identifier'] = user.identifier
        })

        if data[1] then
            if user.group then
                MySQL.Async.execute("UPDATE users SET group = @group WHERE identifier = @identifier", {
                    ['@group'] = user.group,
                    ['@identifier'] = user.identifier
                })
            end

            if user.job and user.job_grade then
                MySQL.Async.execute("UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier",
                    {
                        ['@job'] = user.job,
                        ['@job_grade'] = user.job_grade,
                        ['@identifier'] = user.identifier
                    })
            end

            if user.firstname and user.lastname then
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
