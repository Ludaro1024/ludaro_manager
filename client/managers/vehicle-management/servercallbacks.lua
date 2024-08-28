
-- vehicle_management_getVehicles
-- Used to get all vehicles from the database.
-- @return table The vehicles.
function vehicle_management_getVehicles()
    return lib.callback.await("ludaro_manager:getVehicles", false)
end

-- vehicle_management_editVehicleInDatabase
-- Used to edit a vehicle in the database.
-- @param table vehicle The vehicle data.
function vehicle_management_editVehicleInDatabase(vehicle, oldPlate)
    return lib.callback.await("ludaro_manager:editVehicle", false, vehicle, oldPlate)
end

-- vehicle_management_getVehiclebyPlate
-- Used to get a vehicle from the database.
-- @param string plate The plate of the vehicle.
function vehicle_management_getVehiclebyPlate(plate)
    return lib.callback.await("ludaro_manager:getVehiclebyPlate", false, plate)
end

-- vehicle_management_addVehicleToDatabase
-- Used to add a vehicle to the database.
-- @param table vehicle The vehicle data.
function vehicle_management_addVehicleToDatabase(vehicle)
    return lib.callback.await("ludaro_manager:addVehicle", false, vehicle)
end

-- vehicle_management_deleteVehicle
-- Used to delete a vehicle from the database.
-- @param string plate The plate of the vehicle.
function vehicle_management_deleteVehicle(plate)

    return lib.callback.await("ludaro_manager:vehicle_managerdeleteVehicle", false, plate)
end