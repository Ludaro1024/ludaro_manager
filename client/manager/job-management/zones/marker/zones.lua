markerzones = {}
-- job_management_zones_marker_Allowed
-- Checks if the job and grade provided are allowed access
-- @param accessjob: The required job for access
-- @param accessgrade: The required grade for access
-- @param job: The current job of the player
-- @param grade: The current grade of the player
-- @param type: The type of access required
-- @return boolean: Returns true if access is allowed, false otherwise
function job_management_zones_marker_Allowed(accessjob, accessgrade, job, grade, type)
    if type == "onoffduty" then
        job = string.gsub(job, "_offduty", "")
    end
    grade = grade or 0
    accessgrade = accessgrade or 0
    if type(accessgrade) == "string" then accessgrade = 0 end
    return accessjob == job and accessgrade <= grade 
end

-- job_management_zones_marker_createMarkerZones
-- Creates marker zones based on the provided data
-- @param dataa: The data containing marker zone information
function job_management_zones_marker_createMarkerZones(dataa)
    local job, grade = jobmanagement_zones_npcs_getJobandGrade()

    for k, v in pairs(dataa) do
        for _, marker in pairs(v.data) do
            if marker.type == "marker" then

                local coords = vec3(marker.coords.x, marker.coords.y, marker.coords.z)
                local size = vec3(15, 15, 15)
                local rotation = 200.0

                local defaultmarkerdata = {
                    markerId = 1,
                    markerScale = 1.0,
                    markerColor = {r = 255, g = 0, b = 0, a = 255},
                    bobUpAndDown = false,
                    faceCamera = false
                }

                -- Apply default data if not provided
                marker.marker = marker.marker or {}
                marker.marker.markerId = marker.marker.markerId or defaultmarkerdata.markerId
                marker.marker.markerScale = marker.marker.markerScale or defaultmarkerdata.markerScale
                marker.marker.markerColor = marker.marker.markerColor or defaultmarkerdata.markerColor
                marker.marker.bobUpAndDown = marker.marker.bobUpAndDown or defaultmarkerdata.bobUpAndDown
                marker.marker.faceCamera = marker.marker.faceCamera or defaultmarkerdata.faceCamera

                local jobname = v.name
                local zoneType = marker.type

                local box = lib.zones.box({
                    coords = coords,
                    marker = marker,
                    size = size,
                    rotation = rotation,
                    debug = Debuglevel >= 4,
                    job = job,
                    grade = grade,
                    type = _,
                    parentName = jobname,
                    inside = function(self)
                        DrawMarker(
                            self.marker.marker.markerId, 
                            self.coords.x, self.coords.y, self.coords.z, 
                            0.0, 0.0, 0.0, 
                            0.0, 0.0, 0.0, 
                            self.marker.marker.markerScale + 0.0, self.marker.marker.markerScale + 0.0, self.marker.marker.markerScale + 0.0, 
                            self.marker.marker.markerColor.r, self.marker.marker.markerColor.g, self.marker.marker.markerColor.b, 255, 
                            self.marker.marker.bobUpAndDown, self.marker.marker.faceCamera, 2, nil, nil
                        )

                        local inrange = #(GetEntityCoords(PlayerPedId()) - self.coords) < Config.Range

                        if inrange and job_management_zones_marker_Allowed(self.parentName, self.grade, self.job, self.grade, self.type) then
                            EditableFunctions.ShowHelpNotification(Locale("open_menu"))
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
    end
end

-- job_management_zones_marker_removeAllMarkerZones
-- Removes all marker zones from the markerzones table
function job_management_zones_marker_removeAllMarkerZones()
    for _, v in pairs(markerzones) do
        v:remove()
    end
    markerzones = {}
end
