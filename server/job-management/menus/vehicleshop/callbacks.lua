lib.callback.register('ludaro_manager:buyVehicle', function(source, vehicleData, platePrefix, society, grade)

    return job_management_vehicleshop_buyVehicle(source, vehicleData, platePrefix, society, grade)
 end)
 lib.callback.register('ludaro_manager:hasEnoughMoney', function(source, price)
    return job_management_vehicleshop_hasEnoughMoney(source, price)
 end)