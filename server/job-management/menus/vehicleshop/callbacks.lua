lib.callback.register('ludaro_manager:buyVehicle', function(source, vehicleData, platePrefix)
    return job_management_vehicleshop_buyVehicle(source, vehicleData, platePrefix)
 end)