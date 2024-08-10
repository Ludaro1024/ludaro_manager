RegisterCommand(Config.KeyMapping.openInteractions[2], function(source)
    Interactions = interactions_getInteractionsFromPlayer()
    InteractionsFixed = removeDoubleExistingValueInFirstKeyTable(Interactions, Config.Interactions)
    
    openInteractionsMenu(Interactions)
end)