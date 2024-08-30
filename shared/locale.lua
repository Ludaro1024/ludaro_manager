lib.locale()
function Locale(msg, args)
    if args then
        if locale(args) then
            return locale(msg, locale(args))
        else
            return locale(msg, args)
        end
    else
    return locale(msg)
    end
end