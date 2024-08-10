function interactions_getInteractionsFromPlayer(source)

    local job = framework_getJob(source)
    print(job)
    local interactions = MySQL.scalar.await('SELECT ludaro_manager_interactions FROM jobs WHERE name = @name', {
        ['@name'] = job 
    })
    returntable = {}
    interactions = json.decode(interactions)    
    for k,v in pairs(interactions) do
        exists = false
        label = MySQL.scalar.await('SELECT interaction_label FROM ludaro_manager_interactions WHERE interaction_name = @interaction_name', {
            ['@interaction_name'] = v
        })
        grade = MySQL.scalar.await('SELECT grade FROM ludaro_manager_interactions WHERE interaction_name = @interaction_name', {
            ['@interaction_name'] = v
        })
        for k2,v2 in pairs(returntable) do
            if v2 == label then
                exists = true
            end
        end
        
        if not exists then
           
            table.insert(returntable, {v, label, grade})
        end
    end
    
    return returntable
end