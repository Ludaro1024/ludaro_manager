if Config.Menu == "NativeUI" then
    function openInteractionsMenu(data)
            local menu = NativeUI.CreateMenu(v.name, v.name)
            for _, item in pairs(v.data) do
                local item = NativeUI.CreateItem(v[2], "")
                menu:AddItem(item)
            end
            menu:Visible(true)
            item.Activated = function(sender, index)

                if InteractionsFunctions[v[1]] == nil then
                    print("No function found for: " .. item.Text)
                    return
                end
                InteractionsFunctions[v[1]]()
            end
    end
end