-- job_management_zzload_Init
-- Initializes the job management zones by removing existing zones and loading new ones
function job_management_zzload_Init()
    -- Remove all existing marker and NPC zones
    job_management_zones_marker_removeAllMarkerZones()
    job_management_zones_npc_removeAllNPCZones()
    -- Get new NPC data
    local data = _ENV["jobmanagement_zones_npcs_getNPC&MarkerData"]()
    
    -- Create NPC zones based on the retrieved data
    job_management_zones_npcs_NPCZones(data)

    
    -- Create marker zones based on the retrieved data
    job_management_zones_marker_createMarkerZones(data)
    
    Debug(1, "NPC Zones")
end

-- Event handler for player loading
if ESX then
    RegisterNetEvent("esx:playerLoaded", function()
        refresh_RefreshEverything()
    end)
end

-- Initialize job management zones on script load
job_management_zzload_Init()

-- Event handler for refreshing zones
RegisterNetEvent("ludaro_manager:refreshZones", function()
    refresh_RefreshEverything()
end)
