function refresh_RefreshEverything()
    refreshing = true
    if refreshing == true then end
    job_management_zones_npc_removeAllNPCZones()
    job_management_zones_marker_removeAllMarkerZones()
    job_management_zzload_Init()
    refreshing = false
end