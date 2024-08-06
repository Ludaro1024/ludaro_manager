lib.callback.register("ludaro_manager:getGarageData", function(source)
    return getGarageData(source, framework_getJob(source))
end)

lib.callback.register("ludaro_manager:parkin", function(source, vehicle)
    return parkin(source, vehicle)
end)

lib.callback.register("ludaro_manager:parkout", function(source, vehicle)
    return parkout(source, vehicle)
end)
