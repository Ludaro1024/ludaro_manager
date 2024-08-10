if Config.Menu == "esx_menu_default" then
    function openGarageMenu(data)
        local elements = {}
        sharedvehicles, personalvehicles = garage_getGarageData()

        if #sharedvehicles > 0 then
            table.insert(elements, {label = Locale("shared_vehicles"), value = "shared_vehicles"})
        end

        if #personalvehicles > 0 then
            table.insert(elements, {label = Locale("personal_vehicles"), value = "personal_vehicles"})
        end
        hascars = #personalvehicles > 0 or #sharedvehicles > 0 
        if not hascars then
           EditableFunctions.Notify(Locale("no_vehicles"))
            return
        end

        table.insert(elements, {label = Locale("park_in"), value = "park_in"})

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garage_menu', {
            title = Locale("garage"),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            if data.current.value == "shared_vehicles" then
                openSharedVehiclesMenu(sharedvehicles)
            elseif data.current.value == "personal_vehicles" then
                openPersonalVehiclesMenu(personalvehicles)
            elseif data.current.value == "park_in" then
                openParkInMenu()
            end
        end, function(data, menu)
            menu.close()
        end)
    end

    function openSharedVehiclesMenu(sharedvehicles)
        local elements = {}

        for k, v in pairs(sharedvehicles) do
            table.insert(elements, {label = v.vehicle, value = v})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shared_vehicles_menu', {
            title = Locale("shared_vehicles"),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local vehicleData = data.current.value
            ESX.Game.SpawnVehicle(vehicleData.model, {x = vehicleData.garageCoords.x, y = vehicleData.garageCoords.y, z = vehicleData.garageCoords.z}, vehicleData.heading, function(vehicle)
                ESX.Game.SetVehicleProperties(vehicle, vehicleData)
            end)
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
    end

    function openPersonalVehiclesMenu(personalvehicles)
        local elements = {}

        for k, v in pairs(personalvehicles) do
            table.insert(elements, {label = v.vehicle, value = v})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'personal_vehicles_menu', {
            title = Locale("personal_vehicles"),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local vehicleData = data.current.value
            local cb = garage_parkout(vehicleData)
            if cb then
                ESX.Game.SpawnVehicle(vehicleData.model, {x = vehicleData.garageCoords.x, y = vehicleData.garageCoords.y, z = vehicleData.garageCoords.z}, vehicleData.heading, function(vehicle)
                    ESX.Game.SetVehicleProperties(vehicle, vehicleData)
                end)
            else
                EditableFunctions.Notify(Locale("error"))
            end
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
    end

    function openParkInMenu()
        local elements = {}

        vehiclesnearby = garage_framework_getVehiclesNearby()

        for k, v in pairs(vehiclesnearby) do
            local plate = GetVehicleNumberPlateText(v.vehicle)
            table.insert(elements, {label = plate, value = v.vehicle})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'park_in_menu', {
            title = Locale("park_in"),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local vehicleData = data.current.value
            local cb = garage_parkin(vehicleData)
            if cb then
                ESX.Game.DeleteVehicle(vehicleData)
            else
                EditableFunctions.Notify(Locale("error"))
            end
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
    end
end
