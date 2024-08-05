if Config.Menu == "NativeUI" then
    InteractionFunctions = {}
    function openInteractionsMenu(data)
            local menu = NativeUI.CreateMenu(v.name, v.name)
            for _, item in pairs(v.data) do
                local item = NativeUI.CreateItem(v, "")
                menu:AddItem(item)
            end
            menu:Visible(true)
            menu.OnItemSelect = function(sender, item, index)
                for _, item in pairs(v.data) do
                    if item.name == item.Text then
                        InteractionsFunctions[v]()
                    end
                end
            end
    end
end