--[[
    Configuration File

    This file contains the configuration settings for the script. Each setting is documented to explain its purpose 
    and how it affects the script's behavior. Modify these settings according to your server's needs.
]]

Config = {}

-- Menu system to use for interactions
-- Options:
--   "esx_menu_extended" - Uses the extended ESX menu system.
--   "NativeUI" - Uses the NativeUI menu system.
Config.Menu = "NativeUI"

-- Interaction Range
-- This sets the range (in meters) within which players can interact with NPCs and markers.
Config.Range = 4.0

-- Tablet Animation
-- Enable or disable the tablet animation when the player uses the tablet.
-- true: Tablet animation is enabled.
-- false: Tablet animation is disabled.
Config.Tablet = true

-- Admin Groups
-- Define which player groups are allowed to use admin commands.
-- Example groups: "admin", "superadmin"
Config.AdminGroups = {"admin", "superadmin"}

-- NPC and Marker Spawn Range
-- This defines the range (in meters) around the player where NPCs and markers will appear.
Config.SpawnRange = 50

-- Key Mapping Configuration
-- This section defines the key mappings for various commands.
-- It is important to keep the key mappings in the same order to avoid breaking the script.
Config.KeyMapping = {
    -- Tablet Key Mapping
    -- Key: "F1"
    -- Command Name: "tablet"
    -- Display Label: "Open the Tablet"
    openTablet = {"F1", "tablet", "Open the Tablet"},
    
    -- Job Interactions Key Mapping
    -- Key: "F4"
    -- Command Name: "-openinteractions"
    -- Display Label: "Open Job Interactions"
    openInteractions = {"F4", "openinteractions", "Open Job Interactions"},
}

-- Extra Off-Duty Jobs
-- If enabled, this will create off-duty jobs with a name format of "OFFDUTY_<JOB_NAME>".
-- This helps prevent certain issues and automatically switches players to these off-duty jobs when they are off duty.
-- true: Extra off-duty jobs are created.
-- false: No extra off-duty jobs are created.
Config.ExtraOffDutyJobs = true

-- Delete Grades with No Job Upon Refreshing
-- If enabled, any job grades that are not assigned to a job will be deleted when jobs are refreshed in the framework.
-- true: Unassigned grades are deleted upon refreshing.
-- false: Unassigned grades are not deleted.
Config.DeleteGradesWithNoJobUponRefreshing = true

-- Locale Setting
-- Sets the language/locale for the script.
-- Example: "en" for English, "de" for German, etc.

-- THIS ONLY WORKS ONCE UPON STARTING THE SCRIPT IF YOU WANT TO CHANGE THIS LIVE YOU NEED TO RESTART OX_LIB!
Config.Locale = "en"
