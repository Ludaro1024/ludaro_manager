--[[
    Updates a user's data within the ESX framework or the database.

    This function attempts to update a user's data within the ESX framework if they are online.
    If the user is offline, it updates the relevant data directly in the SQL database.

    @param user (table): A table containing the user's data to be updated.
    
    @return boolean: Returns true if the user was successfully updated, false otherwise.
]]
function user_management_updateUserInFramework(user)
    -- Fetch the ESX player object using the identifier
    local xPlayer = ESX.GetPlayerFromIdentifier(user.identifier)

    if not xPlayer then
        -- User is offline, update data directly in the database
        local data = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
            ['@identifier'] = user.identifier
        })

        if data[1] then
            -- Update group if changed
            if user.group and user.group ~= data[1].group then
                MySQL.Async.execute("UPDATE users SET `group` = @group WHERE identifier = @identifier", {
                    ['@group'] = user.group,
                    ['@identifier'] = user.identifier
                })
            end

            -- Update job and job grade if changed
            if user.job and user.job_grade and (user.job ~= data[1].job or data[1].job_grade ~= user.job_grade) then
                MySQL.Async.execute("UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier", {
                    ['@job'] = user.job,
                    ['@job_grade'] = user.job_grade,
                    ['@identifier'] = user.identifier
                })
            end

            -- Update first name and last name if changed
            if user.firstname and user.lastname and (user.lastname ~= data[1].lastname or user.firstname ~= data[1].firstname) then
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
        -- User is online, update their data in the ESX framework
        -- Update player's group
        if user.group and user.group ~= xPlayer.getGroup() then
            xPlayer.setGroup(user.group)
        end

        -- Update player's job and job grade
        if user.job and user.job_grade then
            local jobInfo = xPlayer.getJob()
            if user.job ~= jobInfo.name or user.job_grade ~= jobInfo.grade then
                xPlayer.setJob(user.job, user.job_grade)
            end
        end

        -- Update player's first name and last name
        if user.firstname and user.lastname then
            xPlayer.setName(user.firstname .. " " .. user.lastname)
        end
    end

    return true
end
