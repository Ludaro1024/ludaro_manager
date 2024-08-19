function job_management_vehicleshop_buyVehicle(source, vehicleData, platePrefix, society, grade)
    identifier = framework_getPlayerIdenntifierFromSource(source)
    print("ah")
    vehicle = json.encode(vehicleData)
    job = framework_getJob(source)
    if society then 
        identifier = job
    end
    plate = framework_generatePlate(platePrefix)
    insert = [[INSERT INTO owned_vehicles (owner, plate, vehicle, ludaro_manager_job, ludaro_manager_grade) VALUES (@owner, @plate, @vehicle, @job, @grade);]]
    MySQL.query.await(insert, { ['@owner'] = identifier, ['@plate'] = plate, ['@vehicle'] = vehicle, ['@job'] = job, ['@grade'] = grade })
    return plate
end