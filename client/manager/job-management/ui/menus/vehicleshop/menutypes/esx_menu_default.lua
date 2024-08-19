if Config.Menu == "esx_menu_default" then
    function openVehicleShopMenu(data)
        local elements = {}
        vehicleshop = data

        for k, v in pairs(vehicleshop.vehicles) do
            table.insert(elements, {label = v.label .. ' - $' .. v.price, value = v})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_menu', {
            title = Locale("vehicle_shop"),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local vehicleData = data.current.value
            -- TODO: add event to add it to the database
            ESX.Game.SpawnVehicle(v.model, vector3(vehicleshop.parkoutCoords.x, vehicleshop.parkoutCoords.y, vehicleshop.parkoutCoords.z), vehicleshop.parkoutCoords.heading, function(spawnedVehicle)
                plate = vehicleshop_buyVehicleandSetPlate( framework_GetVehicleData(vehicle), data.current.value.platePrefix)
                SetVehicleNumberPlateText(spawnedVehicle, plate)
            end)
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
    end
end
-- TODO: ADD CAMERA AND MAKE BEAUTIFUL
