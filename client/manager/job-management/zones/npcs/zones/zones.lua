zones = {}

function job_management_zones_npcs_Allowed(accessjob, accessgrade, job, grade)
    if grade == nil then grade = 0 end
  
    if accessgrade == nil then accessgrade = 0 end
    if accessjob == job and accessgrade <= grade then
        return true
    end
end

function job_management_zones_npcs_NPCZones(data)
        
    local job, grade = jobmanagement_zones_npcs_getJobandGrade()
    for _, npc in ipairs(data) do

        -- -- Check job and grade before proceeding with the rest of the loop
        -- if npc.grade and npc.grade > grade then
         
        --     -- Skip to the next npc
        --     goto continue
        -- end
       

        -- if job ~= npc.name then
          
        --     -- Skip to the next npc
        --     goto continue
        -- end
      

        -- Iterate over each manager field in npc.data
        for key, managerData in pairs(npc.data) do
            if managerData and managerData.type == "npc" then
                if next(managerData.coords) then
                    local coords = vec3(managerData.coords.x, managerData.coords.y, managerData.coords.z)

                    local size = vec3(20, 20, 20) -- Default size
                    if managerData.npcRange ~= nil then
                        if managerData.npcRange > 1 then
                        size = vec3(managerData.npcRange, managerData.npcRange, managerData.npcRange)
                        end
                    end

                    local rotation = 200.0 
                    timer = 0
                    timer = timer + 1
                    print()
                    box = lib.zones.box({
                        coords = coords,
                        size = size,
                        rotation = rotation,
                        debug = Debuglevel >= 4,
                        inside = function(self)
                            if self.coords then
                                local inrange = #(GetEntityCoords(PlayerPedId()) - self.coords) < Config.Range
                                if inrange and job_management_zones_npcs_Allowed(npc.name, managerData.grade, job, grade) then
                                    EditableFunctions.ShowHelpNotification(Locale("open_menu"))
                                    if IsControlJustReleased(0, 38) then
                                        openMenu(managerData, npc.name)
                                    end
                                end
                            end
                        end,
                        onEnter = function()
                            jobmanagement_zones_npcs_createNPC(coords, managerData.npcModel, managerData.npcheading or 200.0, npc.name)
                        end,
                        onExit = function()
                            jobmanagement_zones_npcs_deleteNPCByName(npc.name)
                        end
                    })

                    
                    
                    table.insert(zones, box)
                end
            end
        end
        -- ::continue::
    end
end

function job_management_zones_npc_removeAllNPCZones()
    for k,v in pairs(zones) do
            v:remove()
    end
    zones = {}
end
