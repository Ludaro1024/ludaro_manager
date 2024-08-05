RegisterCommand("+openInteractions", function(source)
    Interactions = interactions_getInteractionsFromPlayer()
    openInteractionsMenu(Interactions)
end)