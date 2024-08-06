function interactions_getInteractionsFromPlayer(source)
    local job = framework_getJob(source)
    local interactions = MySQL.scalar.await('SELECT ludaro_manager_interactions FROM jobs WHERE name = @name', {
        ['@name'] = job 
    })
    returntable = {}
    interactions = json.decode(interactions)    
    for k,v in pairs(interactions) do
        label = MySQL.scalar.await('SELECT interaction_label FROM ludaro_manager_interactions WHERE interaction_name = @interaction_name', {
            ['@interaction_name'] = v
        })
        table.insert(returntable, {v, label})
    end
    
    return returntable
end