--[[
    Locale Function

    This script defines a `Locale` function that retrieves localized messages based on the language setting 
    specified in the server configuration. The locale is typically set using the `setr ox:locale` command in 
    the server configuration file (`server.cfg`) or the server console.

    The `Locale` function wraps around the `locale` function provided by the `ox` library, allowing for the 
    retrieval of localized messages with or without arguments.

    @param msg (string): The key for the message to be localized. This is the identifier used to retrieve 
                         the correct localized string from the locale files.
    @param args (table|nil): Optional arguments to replace placeholders in the localized message string. 
                             These arguments allow for dynamic insertion of values into the localized message.

    @return string: Returns the localized message, optionally formatted with the provided arguments.
]]

-- Initialize the locale system (presumably from the `ox` library)
lib.locale()

--[[
    Locale

    This function retrieves and optionally formats a localized message based on the provided key (`msg`) and arguments (`args`).
    It uses the `locale` function from the `ox` library to fetch the localized string and handle any dynamic arguments.

    @param msg (string): The key for the message to be localized.
    @param args (table|nil): Optional table of arguments to be inserted into the localized message.

    @return string: The localized and optionally formatted message.
]]
function Locale(msg, args)
    if args then
        if locale(args) then
            -- If args itself needs localization, first localize the args, then localize the message with these localized args
            return locale(msg, locale(args))
        else
            -- If args does not need localization, just localize the message with the provided args
            return locale(msg, args)
        end
    else
        -- If no args are provided, just return the localized message for the key
        return locale(msg)
    end
end

--[[
    Usage:

    - The locale can be set in the server configuration using:
      `setr ox:locale en`

    - The `Locale` function can then be used throughout your scripts to fetch localized messages, e.g.:
      `Locale("welcome_message", {playerName})`
]]
