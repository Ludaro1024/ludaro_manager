--[[
    Set Locale

    This command sets the server's locale using the value from Config.Locale. 
    If Config.Locale is not defined or is nil, it defaults to "en" (English).

    @return nil: This function does not return any values but sets the server locale.
]]

-- Ensure the locale is set, defaulting to "en" if Config.Locale is nil or empty
local locale = Config.Locale or "en"

-- Execute the command to set the locale
ExecuteCommand("setr ox:locale " .. locale)
