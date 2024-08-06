lib.callback.register("ludaro_manager:getCuffStatus", function(source, id)
    return IsCuffed(id)
end)