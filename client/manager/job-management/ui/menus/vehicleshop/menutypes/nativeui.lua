if Config.Menu == "NativeUI" then
    function openVehicleShopMenu(data)
        local menu = NativeUI.CreateMenu(Locale("vehicle_shop"), "")
        _menuPool:Add(menu)
        
        vehicleshop = garage_getVehicleShopData()

        for k, v in pairs(vehicleshop.vehicles) do
            local vehicle = NativeUI.CreateItem(v.label .. ' - $' .. v.price, "")
            menu:AddItem(vehicle)
            vehicle.Activated = function(sender, item)
                if item == vehicle then
                    ESX.Game.SpawnVehicle(v.model, vector3(vehicleshop.coords.x, vehicleshop.coords.y, vehicleshop.coords.z), vehicleshop.coords.heading, function(spawnedVehicle)
                        local plate = vehicleshop_buyVehicleandSetPlate(framework_GetVehicleData(spawnedVehicle), data.current.value.platePrefix.platePrefix)
                        SetVehicleNumberPlateText(spawnedVehicle, plate)
                    end)
                end
            end
        end

        _menuPool:RefreshIndex()
        _menuPool:MouseControlsEnabled(false)
        _menuPool:ControlDisablingEnabled(false)
        menu:Visible(true)
    end
end
-- TODO: ADD CAMERA AND MAKE BEAUTIFUL
