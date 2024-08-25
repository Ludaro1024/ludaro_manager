if Config.Menu == "esx_menu_default" then
    function openClothesMenu(data, jobname)
        ESX.UI.Menu.CloseAll()

        local elements = {}

        -- Loop through localClothes and create items
        for key, outfit in pairs(data.localClothes) do
            local outfitName = outfit.name
            if outfitName == nil or outfitName == "" then
                outfitName = "Clothes " .. tostring(key)
            end

            table.insert(elements, {
                label = outfitName,
                value = outfit.skin
            })
        end

        -- Add option to return to normal clothes
        table.insert(elements, {
            label = Locale("return_to_normal_clothes"),
            value = "normal_clothes"
        })

        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'clothes_menu',
            {
                title    = Locale("clothes_menu"),
                align    = 'top-left',
                elements = elements
            },
            function(data, menu)
                local selectedSkin = data.current.value
                if selectedSkin == "normal_clothes" then
                    job_management_clothes_getNormalSkin()
                else
                    job_management_clothes_changeClothes(selectedSkin)
                end
                menu.close()
            end,
            function(data, menu)
                menu.close()
            end
        )
    end
end
