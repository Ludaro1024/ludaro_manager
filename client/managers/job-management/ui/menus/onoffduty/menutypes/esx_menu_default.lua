if Config.Menu == "NativeUI" then
    function openOnOffDutyMenu()
        local menu = NativeUI.CreateMenu(Locale("duty_menu"), "")
        _menuPool:Add(menu)
        
        local onDutyItem = NativeUI.CreateItem(Locale("on_duty"), "")
        menu:AddItem(onDutyItem)
        onDutyItem.Activated = function(sender, item)
            if item == onDutyItem then
                onDuty()
            end
        end

        local offDutyItem = NativeUI.CreateItem(Locale("off_duty"), "")
        menu:AddItem(offDutyItem)
        offDutyItem.Activated = function(sender, item)
            if item == offDutyItem then
               offDuty()
            end
        end

        _menuPool:RefreshIndex()
        _menuPool:MouseControlsEnabled(false)
        _menuPool:ControlDisablingEnabled(false)
        menu:Visible(true)
    end
end
