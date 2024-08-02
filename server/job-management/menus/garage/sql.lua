function getGarageData(source, jobName)
    local identifier = getPlayerIdentifierFromSource(source)
    local grade = 0 or getGrade(source)
    if grade == nil or identifier == nil then return end
    local sharedvehicles = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @job AND ludaro_mannager_grade >= @grade", {['@job'] = jobName, ['@grade'] = grade})
    local personalvehicles = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @identifier AND ludaro_manager_job = @job AND ludaro_manager_grade >= @grade", {['@identifier'] = identifier, ['@job'] = jobName, ['@grade'] = grade})
    return sharedvehicles, personalvehicles
end