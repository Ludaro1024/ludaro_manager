--[[
    Register Key Mappings

    This section registers key mappings for specific commands within the game. Key mappings allow players 
    to trigger certain actions using predefined keyboard shortcuts. The actions include opening a tablet 
    UI and accessing interaction menus.

    The key mappings are configured using data from the `Config.KeyMapping` table, which defines the command names,
    display labels, and default keys.

    @param commandName (string): The name of the command that will be triggered by the key mapping.
    @param displayLabel (string): The label displayed to the player in the key mapping settings menu.
    @param deviceType (string): The type of device that triggers the command (e.g., "keyboard").
    @param defaultKey (string): The default key assigned to the command.
]]

-- Register key mapping for opening the tablet
RegisterKeyMapping(
    Config.KeyMapping.openTablet[2],          -- Command name
    Config.KeyMapping.openTablet[3],          -- Display label
    "keyboard",                               -- Device type
    Config.KeyMapping.openTablet[1]           -- Default key
)

-- Register key mapping for opening interactions
RegisterKeyMapping(
    Config.KeyMapping.openInteractions[2],    -- Command name
    Config.KeyMapping.openInteractions[3],    -- Display label
    "keyboard",                               -- Device type
    Config.KeyMapping.openInteractions[1]     -- Default key
)
