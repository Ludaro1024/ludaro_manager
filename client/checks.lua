CreateThread(function()
    local timer = 0
    local maxTime = 5000 -- 5 seconds
    while not commandsloaded and timer < maxTime do
        Wait(0)
        timer = timer + 1
    end

    if not commandsloaded then
        error("Error: Commands for RegisterKeyMapping not loaded within 5 seconds.")
    else
        for k, v in pairs(Config.KeyMapping) do
                RegisterKeyMapping(v[2], v[3], "keyboard", v[1])
        end
    end
end)
