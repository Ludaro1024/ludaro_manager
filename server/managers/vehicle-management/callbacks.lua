lib.callback.register('ludaro_manager:getVehicles', function(source)
    return vehicle_management_sql_getVehicles()
 end)


lib.callback.register('ludaro_manager:editVehicle', function(source, vehicle, oldPlate)
    return vehicle_management_sql_editVehicle(vehicle, oldPlate)
 end)

 lib.callback.register('ludaro_manager:getVehiclebyPlate', function(source, plate)
    return vehicle_management_sql_getVehiclebyPlate(plate)
 end)