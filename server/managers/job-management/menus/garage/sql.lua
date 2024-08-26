function getGarageData(source, jobName)
    local identifier = framework_getPlayerIdenntifierFromSource(source)
    local grade = 0 or getGrade(source)
    if grade == nil or identifier == nil then return end
    local sharedvehicles = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE (owner = @job AND ludaro_manager_grade >= @grade) OR (owner = @job AND (ludaro_manager_grade IS NULL OR @grade IS NULL)) AND stored != 1", {['@job'] = jobName, ['@grade'] = grade})
    local personalvehicles = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @identifier AND ludaro_manager_job = @job AND ludaro_manager_grade >= @grade AND stored != 1", {['@identifier'] = identifier, ['@job'] = jobName, ['@grade'] = grade})
    return sharedvehicles, personalvehicles
end

function parkin(source, vehicle)
   identifier = framework_getPlayerIdenntifierFromSource(source)
   plate = vehicle.plate
   job = framework_getJob(source)
    if identifier == nil then return false end
    MySQL.Sync.execute("UPDATE owned_vehicles SET stored = @stored, vehicle = @vehicle WHERE plate = @plate AND (owner = @identifier OR owner = @job)", {['@stored'] = 0, ['@plate'] = plate, ['@vehicle'] = json.encode(vehicle), ['@identifier'] = identifier, ['@job'] = job})
    return true
end

function parkout(source, vehicle)
    vehicle = json.decode(vehicle)
    identifier = framework_getPlayerIdenntifierFromSource(source)
    plate = vehicle.plate
    job = framework_getJob(source)
    
    if plate == nil then return false end
    if identifier == nil then return false end
    MySQL.Sync.execute("UPDATE owned_vehicles SET stored = @stored WHERE plate = @plate AND (owner = @identifier OR owner = @job)", {['@stored'] = 1, ['@plate'] = plate, ['@identifier'] = identifier , ['@job'] = job})
    return true
end

function isOwned(source, plate)
    identifier = framework_getPlayerIdenntifierFromSource(source)
    job = framework_getJob(source)
    
    if identifier == nil then return false end
    local result = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate AND (owner = @identifier OR owner = @job)", {['@plate'] = plate, ['@identifier'] = identifier, ['@job'] = job})
    if result[1] then
        return true
    else
        return false
    end
end