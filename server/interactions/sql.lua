function interactions_getInteractionsFromPlayer(source)
    local job = framework_getJob(source)
    local interactions = MySQL.Sync.fetchAll("SELECT ludaro_manager_interactions FROM jobs WHERE name = @job OR label = @job", {
        ["@job"] = job
    })
    return json.decode(interactions[1].ludaro_manager_interactions)
end