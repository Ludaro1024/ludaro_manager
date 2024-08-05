npcs = {}

-- jobmanagement_zones_npcs_createNPC
-- Creates an NPC at the specified coordinates with the given model and heading
-- @param coords: The coordinates where the NPC will be created
-- @param model: The model of the NPC
-- @param heading: The heading direction of the NPC
-- @param name: The name identifier for the NPC
-- @return npc: The created NPC entity
function jobmanagement_zones_npcs_createNPC(coords, model, heading, name)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(500)
    end
    local npc = CreatePed(4, model, coords.x, coords.y, coords.z - 1.5, heading, false, false)
    SetEntityAsMissionEntity(npc, true, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetEntityVisible(npc, true)
    -- TODO: Unload the model after creation if necessary
    table.insert(npcs, {npc = npc, name = name})
    return npc
end

-- jobmanagement_zones_npcs_deleteNPCByName
-- Deletes an NPC based on its name identifier
-- @param name: The name identifier of the NPC to be deleted
function jobmanagement_zones_npcs_deleteNPCByName(name)
    for i, v in ipairs(npcs) do
        if v.name == name then
            DeleteEntity(v.npc)
            table.remove(npcs, i)
            return
        end
    end
end

-- jobmanagement_zones_npcs_deleteAllNPCs
-- Deletes all NPCs currently managed
function jobmanagement_zones_npcs_deleteAllNPCs()
    for _, v in ipairs(npcs) do
        DeleteEntity(v.npc)
    end
    npcs = {}
end

-- jobmanagement_zones_npcs_getNPCByName
-- Retrieves an NPC based on its name identifier
-- @param name: The name identifier of the NPC to be retrieved
-- @return npc: The NPC entity if found, nil otherwise
function jobmanagement_zones_npcs_getNPCByName(name)
    for _, v in ipairs(npcs) do
        if v.name == name then
            return v.npc
        end
    end
    return nil
end

-- jobmanagement_zones_npcs_getNPCs
-- Retrieves all managed NPCs
-- @return table: A table of all managed NPCs
function jobmanagement_zones_npcs_getNPCs()
    return npcs
end

-- Event handler for resource stop event to delete all NPCs
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        jobmanagement_zones_npcs_deleteAllNPCs()
    end
end)
