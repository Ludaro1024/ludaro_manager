Debuglevel = 0 -- 1 to 4
function Debug(level, message)
    if level == nil then level = 4 end
    if  Debuglevel >= level then
        local info = debug.getinfo(2, "Sl")
        print(string.format("[DEBUG][%s:%d] %s", info.short_src, info.currentline, message))
    end
end