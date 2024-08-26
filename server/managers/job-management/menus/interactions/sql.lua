function getInteractionsFromJob(jobName)
    return nil or json.encode(MySQL.Sync.fetchAll("SELECT * FROM ludaro_manager_interactions WHERE job = @job", {['@job'] = jobName}))
end