EditableFunctions = {
    ShowHelpNotification = function(msg)
        ESX.ShowHelpNotification(msg)
    end,
    Notify = function(msg)
        ESX.ShowNotification(msg)
    end,

    OpenStash = function(data,jobname)
        print(ESX.DumpTable(data))
        isoffical = data.isoffical
        weight = data.weight
        EditableFunctions.Notify('Inventory system not found')
    end

}