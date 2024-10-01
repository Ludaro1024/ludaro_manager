if (GetResourceState("es_extended") == "started") then
    Debug(3, "es_extended resource is started.")

    if (exports["es_extended"] and exports["es_extended"].getSharedObject) then
        ESX = exports["es_extended"]:getSharedObject()
        Debug(2, "ESX shared object retrieved via exports.")
    else
        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
            Debug(2, "ESX shared object retrieved via event.")
        end)
    end
else
    Debug(1, "es_extended resource is not started.")
end

InteractionsFunctions = {}
