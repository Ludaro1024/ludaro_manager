-- Callback to retrieve all users from servercallbacks.lua
RegisterNUICallback("getUsers", function(data, cb)
    local users = user_management_getUsers()  -- Fetch users from the database
    cb({ success = true, users = users })
end)

-- Callback to edit a user's group, job, job_grade, firstname, lastname, dateofbirth, sex, and height
RegisterNUICallback("editUser", function(data, cb)
    local identifier = data.identifier
    local newGroup = data.newGroup
    local newJob = data.newJob
    local newJobGrade = data.newJobGrade
    local newFirstname = data.newFirstname
    local newLastname = data.newLastname
    local newDateOfBirth = data.newDateOfBirth
    local newSex = data.newSex
    local newHeight = data.newHeight

    -- Update user data (group, job, job_grade, firstname, lastname)
    if newGroup or newJob or newJobGrrade or newFirstname or newLastname then
    success = user_management_updateUserInFramework({
        identifier = identifier,
        group = newGroup,
        job = newJob,
        job_grade = newJobGrade,
        firstname = newFirstname,
        lastname = newLastname
    })
end
   
    -- Update user-specific SQL fields (dateofbirth, sex, height)
    if newDateOfBirth or newSex or newHeight  then
        successs = user_management_updateUserSQL({
            identifier = identifier,
            dateofbirth = newDateOfBirth,
            sex = newSex,
            height = newHeight
        })
    end

    if success or success then
        cb({ success = true })
    else
        cb({ success = false, error = "Failed to update user information." })
    end
end)
