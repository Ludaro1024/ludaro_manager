Debuglevel = 0
function Debug(level, message)
    if Config.Debug and Debuglevel >= level then
        local info = debug.getinfo(2, "Sl")
        print(string.format("[DEBUG][%s:%d] %s", info.short_src, info.currentline, message))
    end
end
