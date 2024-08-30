--[[
    Handle Vehicle Purchase and Registration

    This function handles the purchase of a vehicle by inserting the vehicle data into the database. It generates a license plate for the vehicle and assigns it to the player's job or society.

    @param source (number): The source identifier of the player.
    @param vehicleData (table): The data related to the vehicle being purchased.
    @param platePrefix (string): The prefix to be used for the vehicle's plate.
    @param society (boolean): Whether the vehicle is being purchased for a society (true) or personally (false).
    @param grade (number): The grade of the job purchasing the vehicle.
    
    @return string: Returns the generated license plate of the purchased vehicle.
]]
function job_management_vehicleshop_buyVehicle(source, vehicleData, platePrefix, society, grade)
    local identifier = framework_getPlayerIdenntifierFromSource(source)
    local vehicle = json.encode(vehicleData)
    local job = framework_getJob(source)
    
    if society then 
        identifier = job
    end
    
    local plate = framework_generatePlate(platePrefix)
    local insert = [[INSERT INTO owned_vehicles (owner, plate, vehicle, ludaro_manager_job, ludaro_manager_grade) VALUES (@owner, @plate, @vehicle, @job, @grade);]]
    
    MySQL.query.await(insert, { 
        ['@owner'] = identifier, 
        ['@plate'] = plate, 
        ['@vehicle'] = vehicle, 
        ['@job'] = job, 
        ['@grade'] = grade 
    })
    
    return plate
end
