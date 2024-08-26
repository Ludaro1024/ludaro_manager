lib.callback.register("ludaro_manager:getUsers", function()
    return user_management_getUsers()
end)

lib.callback.register("ludaro_manager:updateUser", function(source, user)
    return user_management_updateUserInFramework(user)
end)


lib.callback.register("ludaro_manager:updateUserSQL", function(source, user)
    return user_management_updateUserSQL(user)
end)