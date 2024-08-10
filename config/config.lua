Config = {}
Config.Menu = "esx_menu_default" -- psossible is: esx_menu_extended, NativeUI
Config.Range = 2.0 -- rannge for npcs annd markers where the player can interact with them
Config.Tablet = true -- enable or disable the tablet Animation if the player is using the tablet 
Config.AdminGroups = {"admin", "superadmin"} -- groups that are allowed to use the admin commands
-- LEAVE THE KEYMAPPINGS PLEASE IN THE SAME ORDER, OTHERWISE THE KEYMAPPINGS WILL NOT WORK OR BREAK THE SCRIPT
Config.KeyMapping = { -- keymapping for the commands
    openTablet = {"F1", "tablet", "Open the Tablet"},
    openInteractions = {"F4", "openinteractions", "Open Job Interactions"},
}

Config.ExtraOffDutyJobs = true -- WILL CREATE JOBS WITH OFFDUTY_NAME OF THE JOB TO PREVENT CERTAIN THINGS FROM HAPPENING