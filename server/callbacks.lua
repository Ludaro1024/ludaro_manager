lib.callback.register("ludaro_manager:getAllowed", function(source)
    return isAllowed(source)
end)