--[[
    Retrieves garage data for a player based on their job and grade.

    This function fetches both shared and personal vehicles associated with the player's job and grade from the database.
    
    @param source (number): The source identifier of the player.
    @param jobName (string): The name of the player's job.
    
    @return table: Returns two tables containing shared and personal vehicles.
]]
function getGarageData(source, jobName)
    local identifier = framework_getPlayerIdenntifierFromSource(source)
    local grade = 0 or getGrade(source)
    
    if grade == nil or identifier == nil then return end
    
    -- Fetch shared vehicles available to the player's job and grade
    local sharedvehicles = MySQL.Sync.fetchAll(
        "SELECT * FROM owned_vehicles WHERE (owner = @job AND ludaro_manager_grade >= @grade) OR (owner = @job AND (ludaro_manager_grade IS NULL OR @grade IS NULL)) AND stored != 1", 
        {['@job'] = jobName, ['@grade'] = grade}
    )
    
    -- Fetch personal vehicles owned by the player
    local personalvehicles = MySQL.Sync.fetchAll(
        "SELECT * FROM owned_vehicles WHERE owner = @identifier AND ludaro_manager_job = @job AND ludaro_manager_grade >= @grade AND stored != 0", 
        {['@identifier'] = identifier, ['@job'] = jobName, ['@grade'] = grade}
    )
    
    return sharedvehicles, personalvehicles
end

--[[
    Parks a vehicle into the garage by updating its status in the database.

    This function marks the specified vehicle as stored (in the garage) in the database.
    
    @param source (number): The source identifier of the player.
    @param vehicle (table): The vehicle data to be stored.
    
    @return boolean: Returns true if the vehicle was successfully parked, false otherwise.
]]
function parkin(source, vehicle)
    local identifier = framework_getPlayerIdenntifierFromSource(source)
    local plate = vehicle.plate
    local job = framework_getJob(source)
    
    if identifier == nil then return false end
    
    MySQL.Sync.execute(
        "UPDATE owned_vehicles SET stored = @stored, vehicle = @vehicle WHERE plate = @plate AND (owner = @identifier OR owner = @job)", 
        {['@stored'] = 1, ['@plate'] = plate, ['@vehicle'] = json.encode(vehicle), ['@identifier'] = identifier, ['@job'] = job}
    )
    
    return true
end

--[[
    Retrieves a vehicle from the garage by updating its status in the database.

    This function marks the specified vehicle as not stored (retrieved from the garage) in the database.
    
    @param source (number): The source identifier of the player.
    @param vehicle (table|string): The vehicle data to be retrieved or a JSON string of vehicle data.
    
    @return boolean: Returns true if the vehicle was successfully retrieved, false otherwise.
]]
function parkout(source, vehicle)
    vehicle = json.decode(vehicle)
    local identifier = framework_getPlayerIdenntifierFromSource(source)
    local plate = vehicle.plate
    local job = framework_getJob(source)
    
    if plate == nil then return false end
    if identifier == nil then return false end
    
    MySQL.Sync.execute(
        "UPDATE owned_vehicles SET stored = @stored WHERE plate = @plate AND (owner = @identifier OR owner = @job)", 
        {['@stored'] = 0, ['@plate'] = plate, ['@identifier'] = identifier , ['@job'] = job}
    )
    
    return true
end

--[[
    Checks if a vehicle with a given plate is owned by the player or their job.

    This function queries the database to check if the vehicle is owned by the player or their job.
    
    @param source (number): The source identifier of the player.
    @param plate (string): The plate of the vehicle to check ownership for.
    
    @return boolean: Returns true if the vehicle is owned by the player or their job, false otherwise.
]]
function isOwned(source, plate)
    local identifier = framework_getPlayerIdenntifierFromSource(source)
    local job = framework_getJob(source)
    
    if identifier == nil then return false end
    
    local result = MySQL.Sync.fetchAll(
        "SELECT * FROM owned_vehicles WHERE plate = @plate AND (owner = @identifier OR owner = @job)", 
        {['@plate'] = plate, ['@identifier'] = identifier, ['@job'] = job}
    )
    
    return result[1] ~= nil
end
