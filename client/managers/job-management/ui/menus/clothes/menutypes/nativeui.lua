if Config.Menu == "NativeUI" then
    function openClothesMenu(data, jobname)
        if _menuPool:IsAnyMenuOpen() then
            return
        end

        local menu = NativeUI.CreateMenu(Locale("clothes_menu"), "")
        _menuPool:Add(menu)

        -- Submenu for Clothes
        local clothesSubMenu = _menuPool:AddSubMenu(menu, Locale("clothes_options"), "")

        -- Loop through localClothes and create items
        for key, outfit in pairs(data.localClothes) do
            local outfitName = outfit.name
            if outfitName == nil or outfitName == "" then
                outfitName = "Clothes " .. tostring(key)
            end
            local outfitItem = NativeUI.CreateItem(outfitName, "")
            clothesSubMenu.SubMenu:AddItem(outfitItem)

            -- Event for changing clothes
            outfitItem.Activated = function(ParentMenu, SelectedItem)
                job_management_clothes_changeClothes(outfit.skin)
                menu:Visible(false)
            end
        end

        -- Button for returning to normal clothes
        local normalClothesItem = NativeUI.CreateItem(Locale("return_to_normal_clothes"), "")
        menu:AddItem(normalClothesItem)

        normalClothesItem.Activated = function(ParentMenu, SelectedItem)
            job_management_clothes_getNormalSkin()
            menu:Visible(false)
        end

        _menuPool:RefreshIndex()
        _menuPool:MouseControlsEnabled(false)
        _menuPool:ControlDisablingEnabled(false)
        menu:Visible(true)
    end
end
