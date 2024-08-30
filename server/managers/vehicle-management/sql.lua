--[[
    Retrieves all vehicles from the database.

    This function fetches all vehicles from the `owned_vehicles` table,
    along with the owner's name from the `users` table.

    @return table: Returns a table containing all vehicles and their associated data.
]]
function vehicle_management_sql_getVehicles()
    Debug(2, "vehicle-management: Executing SQL query to fetch all vehicles.")
    local query = [[
            SELECT
                ov.owner,
                ov.plate,
                ov.vehicle,
                ov.job,
                ov.stored,
                CONCAT(u.firstname, ' ', u.lastname) AS name
            FROM
                owned_vehicles ov
            LEFT JOIN
                users u ON u.identifier = ov.owner;
    ]]
    local vehicles = MySQL.query.await(query)
    Debug(2, string.format("vehicle-management: Retrieved %d vehicles from the database.", #vehicles))
    return vehicles
end

--[[
    Edits a vehicle's data in the database.

    This function updates a vehicle's data in the `owned_vehicles` table based on the old license plate.

    @param vehicle (table): A table containing the vehicle's updated data.
    @param oldPlate (string): The old license plate of the vehicle to be updated.
    
    @return boolean: Returns true if the vehicle was successfully updated, false otherwise.
]]
function vehicle_management_sql_editVehicle(vehicle, oldPlate)
    Debug(2, string.format("vehicle-management: Executing SQL query to update vehicle with old plate %s.", oldPlate))
    local query = [[
        UPDATE
            owned_vehicles
        SET
            plate = @newPlate,
            vehicle = @newVehicle,
            owner = @newOwner,
            job = @newJob,
            stored = @stored
        WHERE
            plate = @oldPlate;
    ]]
    MySQL.query.await(query, {
        ['@oldPlate'] = oldPlate,
        ['@newPlate'] = vehicle.plate,
        ['@newVehicle'] = vehicle.vehicle,
        ['@newOwner'] = vehicle.owner,
        ['@newJob'] = vehicle.job,
        ['@stored'] = vehicle.stored
    })
    Debug(2, "vehicle-management: Vehicle updated successfully.")
    return true
end

--[[
    Retrieves a vehicle's data by its license plate.

    This function fetches a vehicle's data from the `owned_vehicles` table based on the license plate.

    @param plate (string): The license plate of the vehicle to be retrieved.
    
    @return table: Returns a table containing the vehicle's data if found, nil otherwise.
]]
function vehicle_management_sql_getVehiclebyPlate(plate)
    Debug(2, string.format("vehicle-management: Executing SQL query to fetch vehicle with plate %s.", plate))
    local query = [[
        SELECT
            ov.owner,
            ov.plate,
            ov.vehicle,
            ov.job,
            ov.stored,
            CONCAT(u.firstname, ' ', u.lastname) AS name
        FROM
            owned_vehicles ov
        LEFT JOIN
            users u ON u.identifier = ov.owner
        WHERE
            ov.plate = @plate;
    ]]
    local vehicle = MySQL.query.await(query, { ['@plate'] = plate })
    Debug(2, "vehicle-management: Vehicle data retrieved successfully.")
    return vehicle[1]
end

--[[
    Adds a new vehicle to the database.

    This function inserts a new vehicle into the `owned_vehicles` table.

    @param vehicle (table): A table containing the vehicle's data to be added.
    
    @return boolean: Returns true if the vehicle was successfully added, false otherwise.
]]
function vehicle_management_sql_addVehicle(vehicle)
    Debug(2, string.format("vehicle-management: Executing SQL query to add vehicle with plate %s.", vehicle.plate))
    local query = { [[
        INSERT INTO owned_vehicles (plate, vehicle, owner, job, stored)
        VALUES (@plate, @vehicle, @owner, @job, @stored);
    ]]}

    local vehicleData = json.encode({ model = vehicle.model })

    local success = MySQL.transaction.await(query, {
        plate   = vehicle.plate,
        vehicle = vehicleData,
        owner   = vehicle.owner,
        job     = vehicle.job,
        stored  = vehicle.stored
    })

    Debug(2, success and "vehicle-management: Vehicle added successfully." or "vehicle-management: Failed to add vehicle.")
    return success, vehicle
end

--[[
    Deletes a vehicle from the database by its license plate.

    This function deletes a vehicle from the `owned_vehicles` table based on the license plate.

    @param plate (string): The license plate of the vehicle to be deleted.
    
    @return boolean: Returns true if the vehicle was successfully deleted, false otherwise.
]]
function vehicle_management_sql_deleteVehicle(plate)
    Debug(2, string.format("vehicle-management: Executing SQL query to delete vehicle with plate %s.", plate))
    local query = [[
        DELETE FROM owned_vehicles WHERE plate = @plate;
    ]]
    MySQL.query.await(query, { ['@plate'] = plate })
    Debug(2, "vehicle-management: Vehicle deleted successfully.")
    return true
end
