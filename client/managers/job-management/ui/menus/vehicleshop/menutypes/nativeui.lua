if Config.Menu == "NativeUI" then
    function openVehicleShopMenu(data)
        if _menuPool:IsAnyMenuOpen() then
            return
        end
        local menu = NativeUI.CreateMenu(Locale("vehicle_shop"), "")
        _menuPool:Add(menu)
        
        vehicleshop = data

        for k, v in pairs(vehicleshop.vehicles) do
            local vehicle = NativeUI.CreateItem(v.label .. ' - $' .. v.price, "")
            local plateprefix = v.platePrefix
            local societyowned = v.societyOwned
            local buygrade = v.grade
           if tonumber(v.grade) == nil then
                buygrade = 0
            end
            menu:AddItem(vehicle)
            if #(GetEntityCoords(PlayerPedId(), true) - vector3(vehicleshop.parkoutCoords.x, vehicleshop.parkoutCoords.y, vehicleshop.parkoutCoords.z)) > 10 then
               vehicleshop.coords = framework_getNearestStreetCoords(GetEntityCoords(PlayerPedId(), true))
            end
            vehicle.Activated = function(sender, item)
                if item == vehicle then
                    local hasenoughmoney =  vehicleshop_hasEnoughMoney(v.price)
                    if not hasenoughmoney then
                        EditableFunctions.Notify(Locale("not_enough_money"))
                        return
                    end
                    EditableFunctions.Notify(Locale("buying_vehicle"))
                 
              

                    ESX.Game.SpawnVehicle(v.model, vector3(vehicleshop.parkoutCoords.x, vehicleshop.parkoutCoords.y, vehicleshop.parkoutCoords.z), vehicleshop.parkoutCoords.heading, function(spawnedVehicle)
                       SetEntityHeading(spawnedVehicle, vehicleshop.parkoutCoords.heading)
                       -- TODO: FIX HEADINNG
                        local plate = vehicleshop_buyVehicleandSetPlate(framework_GetVehicleData(spawnedVehicle), plateprefix, societyowned, buygrade)
                        
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
