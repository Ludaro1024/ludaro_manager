function vehicle_management_getVehicles()
    return lib.callback.await("ludaro_manager:getVehicles", false)
end
function vehicle_management_editVehicleInDatabase(vehicle, oldPlate)
    return lib.callback.await("ludaro_manager:editVehicle", false, vehicle, oldPlate)
end

function vehicle_management_getVehiclebyPlate(plate)
    return lib.callback.await("ludaro_manager:getVehiclebyPlate", false, plate)
end
function vehicle_management_addVehicleToDatabase(vehicle)
    return lib.callback.await("ludaro_manager:addVehicle", false, vehicle)
end

function vehicle_management_deleteVehicle(plate)
    print(plate)
    return lib.callback.await("ludaro_manager:vehicle_managerdeleteVehicle", false, plate)
end