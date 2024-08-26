function vehicle_management_getVehicles()
    return lib.callback.await("ludaro_manager:getVehicles", false)
end
function vehicle_management_editVehicleInDatabase(vehicle, oldPlate)
    return lib.callback.await("ludaro_manager:editVehicle", false, vehicle, oldPlate)
end

function vehicle_management_getVehiclebyPlate(plate)
    return lib.callback.await("ludaro_manager:getVehiclebyPlate", false, plate)
end