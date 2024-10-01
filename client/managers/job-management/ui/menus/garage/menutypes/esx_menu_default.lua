if Config.Menu == "esx_menu_default" then
    function openGarageMenu(garageData)
        local elements = prepareGarageMenuElements()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garage_menu', {
            title = Locale("garage"),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            handleGarageMenuSelection(data, menu, garageData)
        end, function(data, menu)
            menu.close()
        end)
    end

    function prepareGarageMenuElements()
        local elements = {}
        local sharedvehicles, personalvehicles = garage_getGarageData()

        if #sharedvehicles > 0 then
            table.insert(elements, {label = Locale("shared_vehicles"), value = "shared_vehicles"})
        end

        if #personalvehicles > 0 then
            table.insert(elements, {label = Locale("personal_vehicles"), value = "personal_vehicles"})
        end

        table.insert(elements, {label = Locale("park_in"), value = "park_in"})
        return elements
    end

    function handleGarageMenuSelection(data, menu, garageData)
        local sharedvehicles, personalvehicles = garage_getGarageData()
        local hasCars = #personalvehicles > 0 or #sharedvehicles > 0

        if data.current.value == "shared_vehicles" and hasCars then
            openSharedVehiclesMenu(sharedvehicles, garageData)
        elseif data.current.value == "personal_vehicles" and hasCars then
            openPersonalVehiclesMenu(personalvehicles, garageData)
        elseif data.current.value == "park_in" then
            openParkInMenu()
        end
    end

    function openSharedVehiclesMenu(sharedvehicles, garageData)
        local elements = {}
        for _, v in pairs(sharedvehicles) do
            table.insert(elements, {label = v.plate, data = v})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shared_vehicles_menu', {
            title = Locale("shared_vehicles"),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            handleSharedVehicleSelection(data, menu, garageData)
        end, function(data, menu)
            menu.close()
        end)
    end

    function handleSharedVehicleSelection(data, menu, garageData)
        local vehicleData = data.current.data
        local vehicleProps = json.decode(vehicleData.vehicle)
        local model = vehicleProps.model

        if #(GetEntityCoords(PlayerPedId()) - vector3(garageData.parkoutCoords.x, garageData.parkoutCoords.y, garageData.parkoutCoords.z)) > 5.0 then
            garageData.parkoutCoords = framework_getNearestStreetCoords(GetEntityCoords(PlayerPedId()))
        end

        if garage_parkout(vehicleData.vehicle) then
            EditableFunctions.Notify(Locale("vehicle_parkedout"))
            ESX.Game.SpawnVehicle(model, garageData.parkoutCoords, garageData.heading, function(vehicle)
                ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
                SetVehicleNumberPlateText(vehicle, vehicleProps.plate)  -- Set the correct plate
            end)
        else
            EditableFunctions.Notify(Locale("error"))
        end

        menu.close()
    end

    function openPersonalVehiclesMenu(personalvehicles, garageData)
        local elements = {}

        for _, v in pairs(personalvehicles) do
            table.insert(elements, {label = v.plate, value = v})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'personal_vehicles_menu', {
            title = Locale("personal_vehicles"),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            handlePersonalVehicleSelection(data, menu, garageData)
        end, function(data, menu)
            menu.close()
        end)
    end

    function handlePersonalVehicleSelection(data, menu, garageData)
        local vehicleData = data.current.value
        local vehicleProps = json.decode(vehicleData.vehicle)
        local model = vehicleProps.model

        if vehicleData.stored == 1 then
            if garage_parkout(vehicleData) then
                if #(GetEntityCoords(PlayerPedId()) - vector3(garageData.parkoutCoords.x, garageData.parkoutCoords.y, garageData.parkoutCoords.z)) > 5.0 then
                    garageData.parkoutCoords = framework_getNearestStreetCoords(GetEntityCoords(PlayerPedId()))
                end

                ESX.Game.SpawnVehicle(model, garageData.parkoutCoords, garageData.heading, function(vehicle)
                    ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
                    SetVehicleNumberPlateText(vehicle, vehicleProps.plate)  -- Set the correct plate
                end)
            else
                EditableFunctions.Notify(Locale("error"))
            end
        else
            EditableFunctions.Notify(Locale("vehicle_not_stored"))
        end

        menu.close()
    end

    function openParkInMenu()
        local elements = prepareParkInMenuElements()

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'park_in_menu', {
            title = Locale("park_in"),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            handleParkInSelection(data, menu)
        end, function(data, menu)
            menu.close()
        end)
    end

    function prepareParkInMenuElements()
        local elements = {}
        local vehiclesNearby = garage_framework_getVehiclesNearby()

        for _, v in pairs(vehiclesNearby) do
            local plate = GetVehicleNumberPlateText(v.vehicle)
            if garage_isOwned(plate) then
                table.insert(elements, {label = plate, value = v.vehicle})
            end
        end

        return elements
    end

    function handleParkInSelection(data, menu)
        local vehicleData = framework_getVehicleData(data.current.value)

        if garage_parkin(vehicleData) then
            ESX.Game.DeleteVehicle(data.current.value)
        else
            EditableFunctions.Notify(Locale("error"))
        end

        menu.close()
    end
end
