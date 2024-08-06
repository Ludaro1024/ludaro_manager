function vehicleshop_buyVehicleandSetPlate(source, vehicleData, platePrefix)
return lib.callback.await('ludaro_manager:buyVehicle', source, vehicleData, platePrefix)
end