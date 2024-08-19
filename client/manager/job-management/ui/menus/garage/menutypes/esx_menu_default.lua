if Config.Menu == "esx_menu_default" then
    function openGarageMenu(garageData)
        local elements = {}
        sharedvehicles, personalvehicles = garage_getGarageData()

        if #sharedvehicles > 0 then
            table.insert(elements, {label = Locale("shared_vehicles"), value = "shared_vehicles"})
        end

        if #personalvehicles > 0 then
            table.insert(elements, {label = Locale("personal_vehicles"), value = "personal_vehicles"})
        end
        hascars = #personalvehicles > 0 or #sharedvehicles > 0 

        table.insert(elements, {label = Locale("park_in"), value = "park_in"})
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garage_menu', {
            title = Locale("garage"),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            if data.current.value == "shared_vehicles" and hascars then
                openSharedVehiclesMenu(sharedvehicles, garageData)
            elseif data.current.value == "personal_vehicles" and hascars then
                openPersonalVehiclesMenu(personalvehicles)
            elseif data.current.value == "park_in" then
                openParkInMenu()
            end
        end, function(data, menu)
            menu.close()
        end)
    end

    function openSharedVehiclesMenu(sharedvehicles, garageData)
        local elements = {}
        for k, v in pairs(sharedvehicles) do
            table.insert(elements, {label = v.plate, data = v})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shared_vehicles_menu', {
            title = Locale("shared_vehicles"),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local garageData = garageData
            local vehicleData = data.current.data
            local model = json.decode(vehicleData.vehicle).model
                print(ESX.DumpTable(vehicleData))
                print(#(GetEntityCoords(PlayerPedId(), vector3(garageData.parkoutCoords.x, garageData.parkoutCoords.y, garageData.parkoutCoords.z))))
            if #(GetEntityCoords(PlayerPedId(), vector3(garageData.parkoutCoords.x, garageData.parkoutCoords.y, garageData.parkoutCoords.z))) < 5.0 then
                garageData.parkoutCoords = GetNearestStreetCoords(GetEntityCoords(PlayerPedId()))
            end
            local cb = garage_parkout(vehicleData.vehicle)
            if cb then
                EditableFunctions.Notify(Locale("vehicle_parkedout"))
                ESX.Game.SpawnVehicle(model, {x = garageData.parkoutCoords.x, y = garageData.parkoutCoords.y, z = garageData.parkoutCoords.z}, garageData.heading, function(vehicle)
                    ESX.Game.SetVehicleProperties(vehicle, json.decode(vehicleData.vehicle))
                end)
             
            else
                EditableFunctions.Notify(Locale("error"))
            end
         
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
            if vehicleData.stored == 1 then
                
           
            local cb = garage_parkout(vehicleData)
            if cb then
                ESX.Game.SpawnVehicle(vehicleData.model, {x = vehicleData.garageCoords.x, y = vehicleData.garageCoords.y, z = vehicleData.garageCoords.z}, vehicleData.heading, function(vehicle)
                    ESX.Game.SetVehicleProperties(vehicle, vehicleData)
                end)
            else
                EditableFunctions.Notify(Locale("error"))
            end
        else
            EditableFunctions.Notify(Locale("vehicle_not_stored"))
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
            isowned = garage_isOwned(plate)
            if isowned then
            table.insert(elements, {label = plate, value = v.vehicle})
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'park_in_menu', {
            title = Locale("park_in"),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local vehicleData = framework_getVehicleData(data.current.value)
            local cb = garage_parkin(vehicleData)
            if cb then
                ESX.Game.DeleteVehicle(data.current.value)
            else
                EditableFunctions.Notify(Locale("error"))
            end
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
    end
end


