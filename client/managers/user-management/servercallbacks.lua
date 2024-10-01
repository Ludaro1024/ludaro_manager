-- user_management_getUsers
-- Used to get all users from the database.
-- @return table The users.
function user_management_getUsers()
    return lib.callback.await("ludaro_manager:getUsers", false)
end

-- user_management_getUser
-- Used to get a user from the database.
-- @param string identifier The identifier of the user.
function user_management_updateUserInFramework(user)
    return lib.callback.await("ludaro_manager:updateUser", false, user)
end

-- user_management_updateUserSQL
-- Used to update a user in the database.
-- @param table user The user data.
function user_management_updateUserSQL(user)
    return lib.callback.await("ludaro_manager:updateUserSQL", false, user)
end