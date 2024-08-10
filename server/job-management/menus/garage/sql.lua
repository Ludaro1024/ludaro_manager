function getGarageData(source, jobName)
    local identifier = getPlayerIdentifierFromSource(source)
    local grade = 0 or getGrade(source)
    if grade == nil or identifier == nil then return end
    local sharedvehicles = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE (owner = @job AND ludaro_manager_grade >= @grade) OR (owner = @job AND (ludaro_manager_grade IS NULL OR @grade IS NULL))", {['@job'] = jobName, ['@grade'] = grade})
    local personalvehicles = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @identifier AND ludaro_manager_job = @job AND ludaro_manager_grade >= @grade", {['@identifier'] = identifier, ['@job'] = jobName, ['@grade'] = grade})
    return sharedvehicles, personalvehicles
end

function parkin(source, vehicle)
   identifier = getPlayerIdentifierFromSource(source)
   plate = vehicle.plate
    if identifier == nil then return false end
    MySQL.Sync.execute("UPDATE owned_vehicles SET stored = @stored, vehicle = @vehicle, WHERE plate = @plate AND owner = @identifier", {['@stored'] = 1, ['@plate'] = plate, ['@vehicle'] = vehicle, ['@identifier'] = identifier})
    return true
end

function parkout(source, vehicle)
    identifier = getPlayerIdentifierFromSource(source)
    plate = vehicle.plate
    if identifier == nil then return false end
    MySQL.Sync.execute("UPDATE owned_vehicles SET stored = @stored, WHERE plate = @plate AND owner = @identifier", {['@stored'] = 0, ['@plate'] = plate, ['@identifier'] = identifier})
    return true
end