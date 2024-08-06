function job_management_vehicleshop_buyVehicle(source, vehicleData, platePrefix)
    identifier = framework_getPlayerIdentifier(source)
    plate = framework_generatePlate(platePrefix)
    vehicle = vehicleData
    job = framework_getJob(source)
    grade = framework_getGrade(source)
    insert = [[INSERT INTO owned_vehicles (owner, plate, vehicle, ludaro_manager_job, ludaro_manager_grade) VALUES (@owner, @plate, @vehicle, @job, grade);]]
    MySQL.query.await(insert, { ['@owner'] = identifier, ['@plate'] = plate, ['@vehicle'] = vehicle, ['@job'] = job, ['@grade'] = grade })
    return plate
end