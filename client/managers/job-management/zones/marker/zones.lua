-- Marker Zones Table Initialization
local markerzones = {}

--[[
    job_management_zones_marker_Allowed
    Checks if the job and grade provided are allowed access.

    @param accessjob (string): The required job for access.
    @param accessgrade (number/string): The required grade for access.
    @param job (string): The current job of the player.
    @param grade (number): The current grade of the player.
    @param typee (string): The type of access required (e.g., "onoffduty").
    
    @return boolean: Returns true if access is allowed, false otherwise.
]]
local function job_management_zones_marker_Allowed(accessjob, accessgrade, job, grade, typee)
    if typee == "onoffduty" then
        job = string.gsub(job, "_offduty", "")
    end

   

    grade = grade or 0
    accessgrade = accessgrade or 0

    if type(accessgrade) == "string" then 
        accessgrade = 0 
    end

    return accessjob == job and accessgrade <= grade
end

--[[
    processMarker
    Helper function to process and create a marker zone.

    @param marker (table): The marker data to process.
    @param jobname (string): The name of the job related to the marker.
]]
local function processMarker(marker, jobname)
if marker.openType == nil then
    return
end

    local job, grade = jobmanagement_zones_npcs_getJobandGrade() --reused from npc because i was too lazy
    if marker.type == "marker" then
        local coords = vec3(marker.coords.x, marker.coords.y, marker.coords.z)
        local size = vec3(Config.SpawnRange, Config.SpawnRange, Config.SpawnRange)
        local rotation = 200.0
        grade = marker?.grade or 0
        job = jobname
        -- Default marker data
        local defaultmarkerdata = {
            markerId = 1,
            markerScale = 1.0,
            markerColor = {r = 255, g = 0, b = 0, a = 255},
            bobUpAndDown = false,
            faceCamera = false
        }

        -- Apply default data if not provided
        marker.marker = marker.marker or {}
        marker.marker.markerId = (marker.marker.markerId and marker.marker.markerId ~= 0) and marker.marker.markerId or defaultmarkerdata.markerId
        if type(marker.marker.markerScale) ~= "number" then
            marker.marker.markerScale = defaultmarkerdata.markerScale
        else
            marker.marker.markerScale = tonumber(marker.marker.markerScale) or defaultmarkerdata.markerScale
            if math.type(marker.marker.markerScale) == "integer" then
            marker.marker.markerScale = marker.marker.markerScale + 0.0
            end
        end
        marker.marker.markerColor = marker.marker.markerColor or defaultmarkerdata.markerColor
        marker.marker.bobUpAndDown = marker.marker.bobUpAndDown or defaultmarkerdata.bobUpAndDown
        marker.marker.faceCamera = marker.marker.faceCamera or defaultmarkerdata.faceCamera
 
        -- Create the marker zone
        local box = lib.zones.box({
            coords = coords,
            marker = marker,
            size = size,
            rotation = rotation,
            debug = Debuglevel >= 4,
            job = job,
            grade = grade,
            marker = marker,
            parentName = marker.openType,
            inside = function(self)
                -- Draw the marker
                
                DrawMarker(
                    self.marker.marker.markerId, 
                    self.coords.x, self.coords.y, self.coords.z, 
                    0.0, 0.0, 0.0, 
                    0.0, 0.0, 0.0, 
                    self.marker.marker.markerScale, self.marker.marker.markerScale, self.marker.marker.markerScale, 
                    self.marker.marker.markerColor.r, self.marker.marker.markerColor.g, self.marker.marker.markerColor.b, 255, 
                    self.marker.marker.bobUpAndDown, self.marker.marker.faceCamera, 2, nil, nil
                )

                -- Check if the player is within range and allowed access
                local inrange = #(GetEntityCoords(PlayerPedId()) - self.coords) < Config.Range
                    
                if inrange and job_management_zones_marker_Allowed(self.job, self.grade, job, grade) then
                    EditableFunctions.ShowHelpNotification(Locale("open_menu", self.parentName))
                    if IsControlJustReleased(0, 38) then
                        openMenu(self.marker, self.parentName)
                    end
                end
            end,
            onEnter = function() end,
            onExit = function() end
        })

        table.insert(markerzones, box)
    end
end

--[[
    job_management_zones_marker_createMarkerZones
    Creates marker zones based on the provided data.

    @param dataa (table): The data containing marker zone information.
]]
function job_management_zones_marker_createMarkerZones(dataa)
    local job, grade = jobmanagement_zones_npcs_getJobandGrade()

    -- Iterate over the data to create marker zones

    for _, v in pairs(dataa) do
        for key, section in pairs(v.data) do
      
            if type(section) == "table" and section.type == "marker" then
                -- Process the marker directly if it's of type "marker"
              
                processMarker(section, v.name)
            elseif type(section) == "table" then
                -- Iterate over nested sections if they are tables
                for _, subSection in pairs(section) do
                    if type(subSection) == "table" then
                        processMarker(subSection, v.name)
                    end
                end
            end
        end
    end
end

--[[
    job_management_zones_marker_removeAllMarkerZones
    Removes all marker zones from the markerzones table.
]]
function job_management_zones_marker_removeAllMarkerZones()
    for _, v in pairs(markerzones) do
        v:remove()
    end
    markerzones = {}
end
