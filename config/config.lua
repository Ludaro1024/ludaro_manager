Config = {}
Config.Debug = true
Config.Menu = "esx_menu_default" -- psossible is: esx_context, NativeUI, ox-lib
Config.Commands = {
    openInteractionsMenu = "+openInteractions",
    openManagementMenu = "+openManagement",
}
Config.Range = 2.0 -- rannge for npcs annd markers where the player can interact with them
Config.Menu = "esx_menu_default" -- psossible is: NativeUI, esx_menu_default
Config.Tablet = true -- enable or disable the tablet Animation if the player is using the tablet 
Config.AdminGroups = {"admin", "superadmin"} -- groups that are allowed to use the admin commands

-- LEAVE THE KEYMAPPINGS PLEASE IN THE SAME ORDER, OTHERWISE THE KEYMAPPINGS WILL NOT WORK OR BREAK THE SCRIPT
Config.KeyMapping = { -- keymapping for the commands
    openTablet = {"F1", "+tablet", "Open the Tablet"},
    openInteractions = {"E", "+openInteractions", "Open Job Interactionsn"},
}