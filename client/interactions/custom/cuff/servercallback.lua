function isPlayerCuffed(id)
    return lib.callback.await("ludaro_manager:getCuffStatus", id)
end