-- RegisterNetEvent("ludaro_manager:refreshStashesServer", function()
--         stashes = sql_getStashes()
--         for k,v in pairs(stashes) do 
--             if exports.ox_inventory then
--                 if v.officialStash == true then
--                     owner = nil
--                 else
--                     owner = true
--                 end
--                 exports.ox_inventory:RegisterStash(k, v.jobname .. k, v.slots, v.weight, owner, {[v.jobname] = v.maxgrade}, v.coords)
--             end
--         end
-- end)