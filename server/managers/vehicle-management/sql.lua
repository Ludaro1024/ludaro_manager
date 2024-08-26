function vehicle_management_sql_getVehicles()
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
        return vehicles
end

function vehicle_management_sql_editVehicle(vehicle, oldPlate)
    
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
    return true
end


function vehicle_management_sql_getVehiclebyPlate(plate)
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
    return vehicle[1]
end