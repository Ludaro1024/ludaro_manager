if Config.Menu == "esx_menu_default" then
    function openInteractionsMenu(data)
        playerjob, playergrade = jobmanagement_zones_npcs_getJobandGrade()
        if #data > 0 then
            ESX.UI.Menu.CloseAll()

            local elements = {}
            for _, v in pairs(data) do
                table.insert(elements, { label = v[2], name = v[1], grade = v[3] })
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_interactions', {
                title    = Locale("Interactions"),
                align    = 'top-left',
                elements = elements
            }, function(data, menu)
                ESX.UI.Menu.CloseAll()

                if InteractionsFunctions[data.current.name] == nil then
                    
                    return
                end

                if data.current.grade ~= nil then
                    
                    if data.current.grade >  playergrade then
                        EditableFunctions.Notify(Locale("no_permission"))
                        return
                    end
                end
                InteractionsFunctions[data.current.name]()
            end, function(data, menu)
                menu.close()
            end)
        else
            EditableFunctions.Notify(Locale("no_interactions"))
        end
    end
end
