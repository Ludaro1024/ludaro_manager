npcs = {}

function createNPC(coords, model, heading, name)
    ("Creating NPC " .. name, model, heading, name)
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
    -- TODO: add it so thhat it unnloads the model
    table.insert(npcs, {npc = npc, name = name})
    return npc
end

function deleteNPCByName(name)
    for i, v in ipairs(npcs) do
        if v.name == name then
            table.remove(npcs, i)
            DeleteEntity(v.npc)
            return
        end
    end
end

function deleteAllNPCs()
    for i, v in ipairs(npcs) do
        DeleteEntity(v.npc)
    end
    npcs = {}
end

function getNPCByName(name)
    for i, v in ipairs(npcs) do
        if v.name == name then
            return v.npc
        end
    end
end

function getNPCs()
    return npcs
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        deleteAllNPCs()
    end
  end)