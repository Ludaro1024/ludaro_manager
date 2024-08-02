function Locale(msg)
    local lang = Config.Language
    local locale = Config.Locale[lang]
    if locale[msg] then
        return locale[msg]
    else
        return msg
    end
end