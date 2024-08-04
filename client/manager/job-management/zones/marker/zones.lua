
zones = {}
function jobmanagement_zones_marker_createMarkerZones(data)
    for _, marker in ipairs(data) do
        local data = json.decode(marker.data)
        if data and data.coords then
            coords = vec3(data.coords.x, data.coords.y, data.coords.z)
            size = vec3(15, 15, 15)
            rotation = 200.0
        end

        local zoneType = npc.type
        local box = lib.zones.box({
            coords = coords,
            size = size,
            rotation = rotation,
            debug = true,
            inside = function() 
                DrawMarker(1 or marker.markerId, coords.x, coords.y, coords.z, 0, 0, 0, 0, 0, 0, 1.0 or marker.markerScale, 1.0 or marker.markerScale, 1.0 or marker.markerScale, 255 or marker.markerColor.r, 0 or marker.markerColor.g, 0 or marker.markerColor.b, 255, false or marker.bobUpAndDown, false or marker.faceCamera, 2, nil, nil, nil, true)
            end, 
            onEnter = function() end, 
            onExit = function()  end 
        })
        
        table.insert(zones, {name = npc.name, zone = box, type = zoneType})
    end
end

function jobmanagement_zones_marker_removeMarkerZoneByName(name)
    for i, v in ipairs(zones) do
        if v.name == name then
            table.remove(zones, i)
            return
        end
    end
end

function jobmanagement_zones_marker_getMarkerZones()
    return zones
end

function jobmanagement_zones_marker_getMarkerZoneByName(name)
    for i, v in ipairs(zones) do
        if v.name == name then
            return v.zone
        end
    end
end

function jobmanagement_zones_marker_removeAllMarkerZones()
    for k,v in pairs(zones) do
        v:remove()
    end
    zones = {}
end