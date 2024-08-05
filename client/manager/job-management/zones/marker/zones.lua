markerzones = {}

function job_management_zones_marker_Allowed(accessjob, accessgrade, job, grade)
    if grade == nil then grade = 0 end
    if accessgrade == nil then accessgrade = 0 end
    if type(accessgrade) == "string" then accessgrade = 0 end
    if accessjob == job and accessgrade <= grade then
        return true
    end
end

function job_management_zones_marker_createMarkerZones(dataa)
    local job, grade = jobmanagement_zones_npcs_getJobandGrade()

    for k,v in pairs(dataa) do
        local parentName = v.name -- Extract the name from the parent element
        
        for _, marker in pairs(v.data) do
            if marker.type == "marker" then
               
               -- print(ESX.DumpTable(marker))
                if marker.coords then
                    coords = vec3(marker.coords.x, marker.coords.y, marker.coords.z)
                    size = vec3(15, 15, 15)
                    rotation = 200.0
                end 
             

                defaultmarkerdata = {
                    markerId = 1,
                    markerScale = 1.0,
                    markerColor = {r = 255, g = 0, b = 0, a = 255},
                    bobUpAndDown = false,
                    faceCamera = false
                }
                -- check if data exists if not use default
                marker.marker.markerId = marker.marker.markerId or defaultmarkerdata.markerId
                marker.marker.markerScale = marker.marker.markerScale + 0.0 or defaultmarkerdata.markerScale
                marker.marker.markerColor = marker.marker.markerColor or defaultmarkerdata.markerColor
                marker.marker.bobUpAndDown = marker.marker.bobUpAndDown or defaultmarkerdata.bobUpAndDown
                marker.marker.faceCamera = marker.marker.faceCamera or defaultmarkerdata.faceCamera
                --print(ESX.DumpTable(marker))


               
                local zoneType = marker.type
                box = lib.zones.box({
                    coords = coords,
                    marker = marker,
                    size = size,
                    rotation = rotation,
                    debug = Debuglevel >= 4,
                    job = job,
                    grade = grade,
                    parentName = jobname,
                    inside = function(self) 
                     
                        DrawMarker(self.marker.markerId, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, self.marker.markerScale, self.marker.markerScale, self.marker.markerScale, self.marker.markerColor.r, self.marker.markerColor.g,self.marker.markerColor.b, 255, self.marker.bobUpAndDown, self.marker.faceCamera, 2, nil, nil)
                        local inrange = #(GetEntityCoords(PlayerPedId()) - self.coords) < Config.Range

                        if inrange and job_management_zones_marker_Allowed(self.jobname, self.grade, self.job, self.grade) then
                            EditableFunctions.ShowHelpNotification(Locale("open_menu"))
                            if IsControlJustReleased(0, 38) then
                                openMenu(self.marker, self.jobname) -- Pass the parent name here
                            end
                        end
                    end, 
                    onEnter = function() end, 
                    onExit = function()  end 
                })
        
                table.insert(markerzones, box)
            end
        end
    end
end

function job_management_zones_marker_removeAllMarkerZones()
    for k,v in pairs(markerzones) do
            v:remove()
    end
    zones = {}
end
