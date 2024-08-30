-- Zones Table Initialization
local zones = {}

--[[
    job_management_zones_npcs_Allowed
    Checks if the job and grade provided are allowed access.

    @param accessjob (string): The required job for access.
    @param accessgrade (number): The required grade for access.
    @param job (string): The current job of the player.
    @param grade (number): The current grade of the player.
    @param type (string): The type of access required (e.g., "onoffduty").
    
    @return boolean: Returns true if access is allowed, false otherwise.
]]
local function job_management_zones_npcs_Allowed(accessjob, accessgrade, job, grade, type)
    if type == "onoffduty" then
        job = string.gsub(job, "_offduty", "")
    end

    grade = grade or 0
    accessgrade = accessgrade or 0

    return accessjob == job and accessgrade <= grade
end

--[[
    processManagerData
    Helper function to process individual manager data and create zones.

    @param managerData (table): The manager data to process.
    @param npcName (string): The name of the NPC.
]]
local function processManagerData(managerData, npcName)
    local npcspawnName = npcName .. "_" .. managerData.openType

    -- Handle different openTypes such as "clothes" or "stashes"
    if managerData.openType == "clothes" then
        if managerData.npcSettings then
            for key, value in pairs(managerData.npcSettings) do
                managerData[key] = value
            end
            managerData.npcSettings = nil
        end
    end

    if managerData.openType == "stashes" then
        for _, stash in ipairs(managerData) do
            if stash.type == "npc" and next(stash.coords) then
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
                            if inrange and job_management_zones_npcs_Allowed(npcName, stash.grade, job, grade, nil) then
                                EditableFunctions.ShowHelpNotification(Locale("open_menu", managerData.openType))
                                if IsControlJustReleased(0, 38) then
                                    openMenu(stash, npcName)
                                end
                            end
                        end
                    end,
                    onEnter = function()
                        jobmanagement_zones_npcs_createNPC(coords, stash.npcModel, stash.npcHeading or 200.0, npcspawnName)
                    end,
                    onExit = function()
                        jobmanagement_zones_npcs_deleteNPCByName(npcspawnName)
                    end
                })

                table.insert(zones, box)
            end
        end
    end

    -- Create a zone if the managerData is of type "npc"
    if managerData.type == "npc" and next(managerData.coords) then
        local coords = vec3(managerData.coords.x, managerData.coords.y, managerData.coords.z)
        local size = vec3(managerData.npcRange or Config.SpawnRange, managerData.npcRange or Config.SpawnRange, managerData.npcRange or Config.SpawnRange)
        local rotation = 200.0

        local box = lib.zones.box({
            coords = coords,
            size = size,
            rotation = rotation,
            debug = Debuglevel >= 4,
            inside = function(self)
                if self.coords then
                    local inrange = #(GetEntityCoords(PlayerPedId()) - self.coords) < Config.Range
                    if inrange and job_management_zones_npcs_Allowed(npcName, managerData.grade, job, grade, nil) then
                        EditableFunctions.ShowHelpNotification(Locale("open_menu", managerData.openType))
                        if IsControlJustReleased(0, 38) then
                            openMenu(managerData, npcName)
                        end
                    end
                end
            end,
            onEnter = function()
                jobmanagement_zones_npcs_createNPC(coords, managerData.npcModel, managerData.npcHeading or 200.0, npcName)
            end,
            onExit = function()
                jobmanagement_zones_npcs_deleteNPCByName(npcName)
            end
        })

        table.insert(zones, box)
    end
end

--[[
    job_management_zones_npcs_NPCZones
    Creates NPC zones for the job management system.

    @param data (table): The data to create the zones from.
]]
function job_management_zones_npcs_NPCZones(data)
    local job, grade = jobmanagement_zones_npcs_getJobandGrade()

    -- Iterate over each NPC in the provided data
    for _, npc in ipairs(data) do
        for key, section in pairs(npc.data) do
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
    Removes all NPC zones from the zones table.
]]
function job_management_zones_npc_removeAllNPCZones()
    for k, v in pairs(zones) do
        v:remove()
        zones[k] = nil
    end
    jobmanagement_zones_npcs_deleteAllNPCs()
end
