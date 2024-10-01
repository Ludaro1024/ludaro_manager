if Config.Menu == "NativeUI" then
    function openGarageMenu(garageData)
        if _menuPool:IsAnyMenuOpen() then
            return
        end
        local sharedvehicles, personalvehicles = garage_getGarageData()

        local menu = NativeUI.CreateMenu(Locale("garage"), "")
        _menuPool:Add(menu)

        if #sharedvehicles > 0 then
            local sharedSubMenu = _menuPool:AddSubMenu(menu, Locale("shared_vehicles"), "")
            for _, v in pairs(sharedvehicles) do
                local vehicleItem = NativeUI.CreateItem(v.plate, "")
                sharedSubMenu.SubMenu:AddItem(vehicleItem)
                vehicleItem.Activated = function(ParentMenu, SelectedItem)
                    local model = json.decode(v.vehicle).model
                   if #(GetEntityCoords(PlayerPedId(), vector3(garageData.parkoutCoords.x, garageData.parkoutCoords.y, garageData.parkoutCoords.z))) < 5.0 then
                        garageData.parkoutCoords = framework_getNearestStreetCoords(GetEntityCoords(PlayerPedId()))
                    end
                    local cb = garage_parkout(v.vehicle)
                    if cb then
                        EditableFunctions.Notify(Locale("vehicle_parkedout"))
                        _menuPool:CloseAllMenus()
                        ESX.Game.SpawnVehicle(model, {x = garageData.parkoutCoords.x, y = garageData.parkoutCoords.y, z = garageData.parkoutCoords.z}, garageData.heading, function(vehicle)
                            ESX.Game.SetVehicleProperties(vehicle, json.decode(v.vehicle))
                        end)
                    else
                        EditableFunctions.Notify(Locale("error"))
                    end
                    menu:Visible(false)
                end
            end
        end

        if #personalvehicles > 0 then
            local personalSubMenu = _menuPool:AddSubMenu(menu, Locale("personal_vehicles"), "")
            for _, v in pairs(personalvehicles) do
                local vehicleItem = NativeUI.CreateItem(v.plate, "")
                personalSubMenu.SubMenu:AddItem(vehicleItem)
                vehicleItem.Activated = function(ParentMenu, SelectedItem)
                    if v.stored == 1 then
                        local cb = garage_parkout(v)
                        if cb then
                            parkoutcoords = garageData.parkoutCoords
                            if #(GetEntityCoords(PlayerPedId(), vector3(parkoutcoords.x, parkoutcoords.y, parkoutcoords.z))) < 20.0 then
                                parkoutcoords = framework_getNearestStreetCoords(GetEntityCoords(PlayerPedId()))
                            end
                
                            v.model = json.decode(v.vehicle).model
                            ESX.Game.SpawnVehicle(v.model, {x = parkoutcoords.x, y = parkoutcoords.y, z = parkoutcoords.z}, parkoutcoords.heading or 200.0, function(vehicle)
                                ESX.Game.SetVehicleProperties(vehicle, v)
                            end)
                            _menuPool:CloseAllMenus()
                        else
                            EditableFunctions.Notify(Locale("error"))
                        end
                    else
                        EditableFunctions.Notify(Locale("vehicle_not_stored"))
                    end
                    menu:Visible(false)
                end
            end
        end

        local parkInSubMenu = _menuPool:AddSubMenu(menu, Locale("park_in"), "")
        local vehiclesnearby = garage_framework_getVehiclesNearby()

        for _, v in pairs(vehiclesnearby) do
            local plate = GetVehicleNumberPlateText(v.vehicle)
            if garage_isOwned(plate) then
                local vehicleItem = NativeUI.CreateItem(plate, "")
                parkInSubMenu.SubMenu:AddItem(vehicleItem)
                vehicleItem.Activated = function(ParentMenu, SelectedItem)
                    local vehicleData = framework_getVehicleData(v.vehicle)
                    local cb = garage_parkin(vehicleData)
                    if cb then
                        ESX.Game.DeleteVehicle(v.vehicle)
                        _menuPool:CloseAllMenus()
                    else
                        EditableFunctions.Notify(Locale("error"))
                    end
                    menu:Visible(false)
                end
            end
        end

        _menuPool:RefreshIndex()
        _menuPool:MouseControlsEnabled(false)
        _menuPool:ControlDisablingEnabled(false)
        menu:Visible(true)
    end
end
