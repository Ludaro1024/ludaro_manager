zones = {}

-- job_management_zones_npcs_Allowed
-- Checks if the job and grade provided are allowed access
-- @param accessjob: The required job for access
-- @param accessgrade: The required grade for access
-- @param job: The current job of the player
-- @param grade: The current grade of the player
-- @param type: The type of access required
-- @return boolean: Returns true if access is allowed, false otherwise
function job_management_zones_npcs_Allowed(accessjob, accessgrade, job, grade, type)
    if type == "onoffduty" then
        job = string.gsub(job, "_offduty", "")
    end
    grade = grade or 0
    accessgrade = accessgrade or 0
    return accessjob == job and accessgrade <= grade
end

function job_management_zones_npcs_NPCZones(data)
    local job, grade = jobmanagement_zones_npcs_getJobandGrade()

    -- Helper function to process individual manager data
    local function processManagerData(managerData, npcName)
        if managerData.openType == "clothes" then
            local npcSettings = managerData.npcSettings
            if npcSettings then
                for key, value in pairs(npcSettings) do
                    managerData[key] = value
                end
                managerData.npcSettings = nil
            end
            managerData.openType = "clothes"
            managerData.localClothes = managerData.localClothes
        end

        if managerData.openType == "stashes" then
            -- Process each stash entry
            for _, stash in ipairs(managerData) do
                if stash.type == "npc" and next(stash.coords) then
                    local coords = vec3(stash.coords.x, stash.coords.y, stash.coords.z)
                    local size = vec3(20, 20, 20) -- Default size

                    if stash.npcRange and stash.npcRange > 1 then
                        size = vec3(stash.npcRange, stash.npcRange, stash.npcRange)
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
                                if inrange and job_management_zones_npcs_Allowed(npcName, stash.grade, job, grade, _) then
                                    EditableFunctions.ShowHelpNotification(Locale("open_menu"))
                                    if IsControlJustReleased(0, 38) then
                                        openMenu(stash, npcName)
                                    end
                                end
                            end
                        end,
                        onEnter = function()
                            jobmanagement_zones_npcs_createNPC(coords, stash.npcModel, stash.npcheading or 200.0, npcName)
                        end,
                        onExit = function()
                            jobmanagement_zones_npcs_deleteNPCByName(npcName)
                        end
                    })

                    table.insert(zones, box)
                end
            end
        end

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
                        if inrange and job_management_zones_npcs_Allowed(npcName, managerData.grade, job, grade, _) then
                            EditableFunctions.ShowHelpNotification(Locale("open_menu"))
                            if IsControlJustReleased(0, 38) then
                                openMenu(managerData, npcName)
                            end
                        end
                    end
                end,
                onEnter = function()
                    jobmanagement_zones_npcs_createNPC(coords, managerData.npcModel, managerData.npcheading or 200.0, npcName)
                end,
                onExit = function()
                    jobmanagement_zones_npcs_deleteNPCByName(npcName)
                end
            })

            table.insert(zones, box)
        end
    end

    for _, npc in ipairs(data) do
        for key, section in pairs(npc.data) do
            if type(section) == "table" and section.openType then
                -- Handle directly if it has an openType
                processManagerData(section, npc.name)
            elseif type(section) == "table" then
                -- Handle nested tables like stashes, clothing, etc.
                for _, subSection in pairs(section) do
                    processManagerData(subSection, npc.name)
                end
            end
        end
    end
end



-- job_management_zones_npc_removeAllNPCZones
-- Removes all NPC zones from the zones table
function job_management_zones_npc_removeAllNPCZones()
    for k, v in pairs(zones) do
        v:remove()
        zones[k] = nil -- Properly removes the reference from the zones table
    end
    jobmanagement_zones_npcs_deleteAllNPCs()
end
