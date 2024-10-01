if Config.Menu == "NativeUI" then
    -- Load NativeUI
    _menuPool = NativeUI.CreatePool()
    
     Citizen.CreateThread(function()
         while true do
             Citizen.Wait(1)
            if _menuPool:IsAnyMenuOpen() then
             _menuPool:ProcessMenus()
            else
             Citizen.Wait(150)
            end
         end
    end)


end