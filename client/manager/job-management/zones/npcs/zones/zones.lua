zones = {}

function createNPCZones(data)
    print(ESX.DumpTable(data))
    local job, grade = getJobandGrade()
    for _, npc in ipairs(data) do
        -- Check job and grade before proceeding with the rest of the loop
        if npc.grade and npc.grade > grade then
         
            -- Skip to the next npc
            goto continue
        end
       

        if job ~= npc.name then
          
            -- Skip to the next npc
            goto continue
        end
      

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

                    local rotation = 200.0 -- Default rotation
                    local zoneType = key

                    local box = lib.zones.box({
                        coords = coords,
                        size = size,
                        rotation = rotation,
                        inside = function() end,
                        debug = Debuglevel >= 3,
                        inside = function(self)
                            if self.coords then
                                local inrange = #(GetEntityCoords(PlayerPedId()) - self.coords) < Config.Range
                                if inrange then
                                    EditableFunctions.ShowHelpNotification(Locale("open_menu"))
                                    if IsControlJustReleased(0, 38) then
                                        openMenu(managerData, npc.name)
                                    end
                                end
                            end
                        end,
                        onEnter = function()
                            createNPC(coords, managerData.npcModel, managerData.npcheading or 200.0, npc.name)
                        end,
                        onExit = function()
                            deleteNPCByName(npc.name)
                        end
                    })

                    print("Created zone at " .. coords.x .. ", " .. coords.y .. ", " .. coords.z)
                    
                    table.insert(zones, { name = npc.name, zone = box, type = zoneType })
                end
            end
        end
        ::continue::
    end
end

function removeNPCZoneByName(name)
    for i, v in ipairs(zones) do
        if v.name == name then
            v.zone:remove() -- Ensure the zone is properly removed
            table.remove(zones, i)
            return
        end
    end
end

function getNPCZones()
    return zones
end

function getNPCZoneByName(name)
    for i, v in ipairs(zones) do
        if v.name == name then
            return v.zone
        end
    end
end

function removeAllNPCZones()
    deleteAllNPCs()
    for _, v in pairs(zones) do
        v.zone:remove() -- Ensure the zone is properly removed
    end
    zones = {}
end
