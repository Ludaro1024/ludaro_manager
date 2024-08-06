zones = {}

-- job_management_zones_npcs_Allowed
-- Checks if the job and grade provided are allowed access
-- @param accessjob: The required job for access
-- @param accessgrade: The required grade for access
-- @param job: The current job of the player
-- @param grade: The current grade of the player
-- @return boolean: Returns true if access is allowed, false otherwise
function job_management_zones_npcs_Allowed(accessjob, accessgrade, job, grade)
    grade = grade or 0
    accessgrade = accessgrade or 0
    return accessjob == job and accessgrade <= grade
end

-- job_management_zones_npcs_NPCZones
-- Creates NPC zones based on the provided data
-- @param data: The data containing NPC zone information
function job_management_zones_npcs_NPCZones(data)
    local job, grade = jobmanagement_zones_npcs_getJobandGrade()
    
    for _, npc in ipairs(data) do
        
        for _, managerData in pairs(npc.data) do
            if managerData and managerData.type == "npc" and next(managerData.coords) then
                local coords = vec3(managerData.coords.x, managerData.coords.y, managerData.coords.z)
                local size = vec3(20, 20, 20) -- Default size

                if managerData.npcRange and managerData.npcRange > 1 then
                    size = vec3(managerData.npcRange, managerData.npcRange, managerData.npcRange)
                end

                local rotation = 200.0

                local box = lib.zones.box({
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
end

-- job_management_zones_npc_removeAllNPCZones
-- Removes all NPC zones from the zones table
function job_management_zones_npc_removeAllNPCZones()
    for _, v in pairs(zones) do
        v:remove()
    end
    zones = {}
end
