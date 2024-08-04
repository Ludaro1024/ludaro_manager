
function job_management_zzload_Init()
    job_management_zones_marker_removeAllMarkerZones()
    job_management_zones_npc_removeAllNPCZones()
    data = jobmanagement_zones_npcs_getNPCData()
    job_management_zones_npcs_NPCZones(data)
    print("refreshing..")
    job_management_zones_marker_createMarkerZones(data)
    Debug (1, "NPC Zones")
end

if ESX then
    RegisterNetEvent("esx:playerLoaded", function()
        refresh_RefreshEverything()
    end)
end
job_management_zzload_Init()

RegisterNetEvent("ludaro_manager:refreshZones", function()
    refresh_RefreshEverything()
end)