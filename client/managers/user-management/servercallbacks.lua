function user_management_getUsers()
    return lib.callback.await("ludaro_manager:getUsers", false)
end

function user_management_updateUserInFramework(user)
    return lib.callback.await("ludaro_manager:updateUser", false, user)
end

function user_management_updateUserSQL(user)
    return lib.callback.await("ludaro_manager:updateUserSQL", false, user)
end