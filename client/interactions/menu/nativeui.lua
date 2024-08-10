if Config.Menu == "NativeUI" then
    function openInteractionsMenu(data)
      playerjob, playergrade = jobmanagement_zones_npcs_getJobandGrade()
          if #data > 0 then
               menu = NativeUI.CreateMenu(Locale("Interactions"), "")
           
               for k,v in pairs(data) do
                local item = NativeUI.CreateItem(v[2], "")
                menu:AddItem(item)
                item.Activated = function(sender, index)
                    if InteractionsFunctions[v[1]] == nil then
                        print("No function found for: " .. v[1])
                        return
                    end
                    if v[3] ~= nil then
                        if v[3] > playergrade then
                            EditableFunctions.Notify(Locale("no_permission"))
                            return
                        end
                    end
                    InteractionsFunctions[v[1]]()
                
                end
            end
            _menuPool:Add(menu)
        _menuPool:RefreshIndex()
        _menuPool:MouseControlsEnabled(false)
        _menuPool:MouseEdgeEnabled(false)
        _menuPool:ControlDisablingEnabled(false)
          menu:Visible(true)
          else
            EditableFunctions.Notify(Locale("no_interactions"))
          end
          
    end
end