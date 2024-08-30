--[[
    Callback Registrations for Vehicle Management

    These callbacks handle various operations related to managing vehicles,
    such as retrieving, editing, adding, and deleting vehicles.
]]

--[[
    Retrieves all vehicles from the database.

    @param source (number): The source identifier of the player (optional).
    
    @return table: Returns a table containing all vehicles and their associated data.
]]
lib.callback.register('ludaro_manager:getVehicles', function(source)
   Debug(3, "vehicle-management: Fetching all vehicles from the database.")
   return vehicle_management_sql_getVehicles()
end)

--[[
   Edits a vehicle's data in the database.

   @param source (number): The source identifier of the player (optional).
   @param vehicle (table): A table containing the vehicle's updated data.
   @param oldPlate (string): The old license plate of the vehicle to be updated.
   
   @return boolean: Returns true if the vehicle was successfully updated, false otherwise.
]]
lib.callback.register('ludaro_manager:editVehicle', function(source, vehicle, oldPlate)
   Debug(3, string.format("vehicle-management: Editing vehicle with old plate %s.", oldPlate))
   return vehicle_management_sql_editVehicle(vehicle, oldPlate)
end)

--[[
   Retrieves a vehicle's data by its license plate.

   @param source (number): The source identifier of the player (optional).
   @param plate (string): The license plate of the vehicle to be retrieved.
   
   @return table: Returns a table containing the vehicle's data if found, nil otherwise.
]]
lib.callback.register('ludaro_manager:getVehiclebyPlate', function(source, plate)
   Debug(3, string.format("vehicle-management: Fetching vehicle with plate %s.", plate))
   return vehicle_management_sql_getVehiclebyPlate(plate)
end)

--[[
   Adds a new vehicle to the database.

   @param source (number): The source identifier of the player (optional).
   @param vehicle (table): A table containing the vehicle's data to be added.
   
   @return boolean: Returns true if the vehicle was successfully added, false otherwise.
]]
lib.callback.register('ludaro_manager:addVehicle', function(source, vehicle)
   Debug(3, string.format("vehicle-management: Adding new vehicle with plate %s.", vehicle.plate))
   return vehicle_management_sql_addVehicle(vehicle)
end)

--[[
   Deletes a vehicle from the database by its license plate.

   @param source (number): The source identifier of the player (optional).
   @param plate (string): The license plate of the vehicle to be deleted.
   
   @return boolean: Returns true if the vehicle was successfully deleted, false otherwise.
]]
lib.callback.register('ludaro_manager:vehicle_managerdeleteVehicle', function(source, plate)
   Debug(3, string.format("vehicle-management: Deleting vehicle with plate %s.", plate))
   return vehicle_management_sql_deleteVehicle(plate)
end)
