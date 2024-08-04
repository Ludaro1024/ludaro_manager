function framework_initFramework()
    if (GetResourceState("es_extended") == "started") then
        if (exports["es_extended"] and exports["es_extended"].getSharedObject) then
            ESX = exports["es_extended"]:getSharedObject()
        else
            TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        end
    end
end

framework_initFramework()

function isAllowed(source)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            for k, v in pairs(Config.AdminGroups) do
                if xPlayer.getGroup() == v then
                    return true
                end
            end
        end
    end
    return false
end
