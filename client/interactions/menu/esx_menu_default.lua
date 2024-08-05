if Config.Menu == "esx_menu_default" then
    InteractionFunctions = {}
    function openInteractionsMenu(data)
        ESX.UI.Menu.CloseAll()
        local elements = {}
        for _, v in pairs(data) do
            table.insert(elements, {label = v})
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_interactions', {
            title    = 'Job Interactions',
            align    = 'top-left',
            elements = elements
        }, function(data, menu)
    
            ESX.UI.Menu.CloseAll()
       
            InteractionFunctions[data.current.label]()
        end, function(data, menu)
            menu.close()
        end)
    end
end