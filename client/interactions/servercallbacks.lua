function interactions_getInteractionsFromPlayer()

   return  lib.callback.await("ludaro_manager:getInteractionsFromPlayer", false)
end