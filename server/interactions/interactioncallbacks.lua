


lib.callback.register("ludaro_manager:getInteractionsFromPlayer", function(source)
    job = framework_getJob(source)
    return interactions_getInteractionsFromPlayer(source)
end)
