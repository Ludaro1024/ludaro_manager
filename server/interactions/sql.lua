--[[
    interactions_getInteractionsFromPlayer

    This function retrieves the interactions available to a player based on their job.

    @param source (number): The server ID of the player whose interactions are being retrieved.

    @return table: Returns a table containing the interactions available to the player.
]]
function interactions_getInteractionsFromPlayer(source)
    Debug(3, "Fetching interactions from database for player ID: " .. source)

    local job = framework_getJob(source)
   
    local interactions = MySQL.scalar.await('SELECT ludaro_manager_interactions FROM jobs WHERE name = @name', {
        ['@name'] = job 
    })

    local returntable = {}
    if interactions == nil then return returntable end
    interactions = json.decode(interactions)

    for _, interactionName in pairs(interactions) do
        local exists = false
        local label = MySQL.scalar.await('SELECT interaction_label FROM ludaro_manager_interactions WHERE interaction_name = @interaction_name', {
            ['@interaction_name'] = interactionName
        })
        local grade = MySQL.scalar.await('SELECT grade FROM ludaro_manager_interactions WHERE interaction_name = @interaction_name', {
            ['@interaction_name'] = interactionName
        })

        for _, existingInteraction in pairs(returntable) do
            if existingInteraction[2] == label then
                exists = true
                break
            end
        end
        
        if not exists then
            table.insert(returntable, {interactionName, label, grade})
        end
    end

    Debug(3, "Interactions fetched for player ID: " .. source)
    return returntable
end
