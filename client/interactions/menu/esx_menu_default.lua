if Config.Menu == "esx_menu_default" then
    function openInteractionsMenu(data)
        ESX.UI.Menu.CloseAll()
        
        local elements = {}
        for _, v in pairs(data) do
            table.insert(elements, {label = v[2], name = v[1]})
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_interactions', {
            title    = 'Job Interactions',
            align    = 'top-left',
            elements = elements
        }, function(data, menu)
    
            ESX.UI.Menu.CloseAll()

            if InteractionsFunctions[data.current.name] == nil then
                print("No function found for: " .. data.current.name)
                return
            end
            InteractionsFunctions[data.current.name]()
        end, function(data, menu)
            menu.close()
        end)
    end
end