if Config.Menu == "NativeUI" then
    function openOnOffDutyMenu()
        if _menuPool:IsAnyMenuOpen() then
            return
        end
        local menu = NativeUI.CreateMenu(Locale("duty_menu"), "")
        _menuPool:Add(menu)
        
        local onDutyItem = NativeUI.CreateItem(Locale("on_duty"), "")
        menu:AddItem(onDutyItem)
        onDutyItem.Activated = function(sender, item)
                TriggerServerEvent('ludaro_mananger:onDuty')
        end

        local offDutyItem = NativeUI.CreateItem(Locale("off_duty"), "")
        menu:AddItem(offDutyItem)
        offDutyItem.Activated = function(sender, item)
         
                TriggerServerEvent('ludaro_mananger:offDuty')
        end

        _menuPool:RefreshIndex()
        _menuPool:MouseControlsEnabled(false)
        _menuPool:ControlDisablingEnabled(false)
        menu:Visible(true)
    end
end
