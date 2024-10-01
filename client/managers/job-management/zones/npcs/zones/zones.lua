-- Table to store all active zones
local zones = {}

--[[
    job_management_zones_npcs_Allowed
    Checks if the job and grade provided are allowed access to a specific zone or NPC.

    @param accessjob (string): The required job for access.
    @param accessgrade (number): The required grade for access.
    @param job (string): The player's current job.
    @param grade (number): The player's current grade.
    @param type (string): The type of access required (e.g., "onoffduty").
    
    @return boolean: Returns true if access is allowed, false otherwise.
]]
function job_management_zones_npcs_Allowed(accessjob, accessgrade, job, grade, type)
    if type == "onoffduty" then
        job = string.gsub(job, "_offduty", "")
    end
   

    grade = grade or 0
    accessgrade = accessgrade or 0
    return accessjob == job and accessgrade <= grade
end

--[[
    job_management_zones_npcs_NPCZones
    Creates NPC interaction zones based on the provided data.

    @param data (table): The data used to create the zones.
]]
function job_management_zones_npcs_NPCZones(data)
    local job, grade = jobmanagement_zones_npcs_getJobandGrade()

    --[[
        processManagerData
        Helper function to process individual manager data and create interaction zones.

        @param managerData (table): The data related to the NPC or zone.
        @param npcName (string): The name of the NPC.
    ]]
    local function processManagerData(managerData, npcName)
        local npcspawnName = npcName .. "_" .. managerData.openType
        
        -- Handling clothes type
     
        if managerData.openType == "clothes" then
            local npcSettings = managerData.npcSettings
            if npcSettings then
                for key, value in pairs(npcSettings) do
                    managerData[key] = value
                end
                managerData.npcSettings = nil
            end
            managerData.openType = "clothes"
        end

       

        -- Handling stashes type
        if managerData.openType == "stashes" then
            for _, stash in ipairs(managerData) do
                if stash.type == "npc" and stash.coords then
                    local coords = vec3(stash.coords.x, stash.coords.y, stash.coords.z)
                    local size = vec3(stash.npcRange or 20, stash.npcRange or 20, stash.npcRange or 20)
                    local rotation = 200.0

                    local box = lib.zones.box({
                        coords = coords,
                        size = size,
                        rotation = rotation,
                        debug = Debuglevel >= 4,
                        inside = function(self)
                            if self.coords then
                                local inrange = #(GetEntityCoords(PlayerPedId()) - self.coords) < Config.Range
                                if inrange and job_management_zones_npcs_Allowed(npcName, stash.grade, job, grade, managerData.openType) then
                                    EditableFunctions.ShowHelpNotification(Locale("open_menu", managerData.openType))
                                    if IsControlJustReleased(0, 38) then
                                        openMenu(stash, npcName)
                                    end
                                end
                            end
                        end,
                        onEnter = function()
                            jobmanagement_zones_npcs_createNPC(coords, stash.npcModel, stash.npcHeading or stash.npcheading or 200.0, npcspawnName)
                        end,
                        onExit = function()
                            jobmanagement_zones_npcs_deleteNPCByName(npcspawnName)
                        end
                    })

                    table.insert(zones, box)
                end
            end
        end

        -- Handling direct NPCs
        if managerData and managerData.type == "npc" and managerData.coords then
           
            local coords = vec3(managerData.coords.x, managerData.coords.y, managerData.coords.z)
            local size = vec3(Config.SpawnRange,Config.SpawnRange, Config.SpawnRange)
            local rotation = 200.0
           
            local box = lib.zones.box({
                coords = coords,
                size = size,
                rotation = rotation,
                debug = Debuglevel >= 4,
                inside = function(self)
                    if self.coords then
                        local inrange = #(GetEntityCoords(PlayerPedId()) - self.coords) < Config.Range
                        if inrange and job_management_zones_npcs_Allowed(npcName, managerData.grade, job, grade, managerData.openType) then
                            EditableFunctions.ShowHelpNotification(Locale("open_menu", managerData.openType))
                            if IsControlJustReleased(0, 38) then
                                openMenu(managerData, npcName)
                            end
                        end
                    end
                end,
                onEnter = function()
                    jobmanagement_zones_npcs_createNPC(coords, managerData.npcModel, managerData.npcHeading or 200.0, npcspawnName)
                end,
                onExit = function()
                    jobmanagement_zones_npcs_deleteNPCByName(npcspawnName)
                end
            })

        

            table.insert(zones, box)
        end
    end

    -- Process each NPC and its related data
    for _, npc in ipairs(data) do
        for _, section in pairs(npc.data) do
            if type(section) == "table" and section.openType then
                processManagerData(section, npc.name)
            elseif type(section) == "table" then
                for _, subSection in pairs(section) do
                    processManagerData(subSection, npc.name)
                end
            end
        end
    end
end

--[[
    job_management_zones_npc_removeAllNPCZones
    Removes all NPC zones and cleans up associated data.
]]
function job_management_zones_npc_removeAllNPCZones()
    for _, v in pairs(zones) do
        v:remove()
    end
    zones = {} -- Clear the zones table
    jobmanagement_zones_npcs_deleteAllNPCs()
end


-- getGroundCoords
-- Performs a raycast downwards to find the ground Z coordinate.
-- If the distance to the ground is above 2 meters, it returns the original Z coordinate.
-- Otherwise, it returns the ground Z coordinate + 1.5 (for npc height)
-- @param coords (vector3): The input coordinates (X, Y, Z).
-- @return z (number): The appropriate Z coordinate, either the ground Z or the original Z.

