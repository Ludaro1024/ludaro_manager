function garage_framework_getVehiclesNearby()
    if ESX then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local vehicles = ESX.Game.GetVehiclesInArea(coords, 10.0)
        local vehiclesnearby = {}
        for i=1, #vehicles, 1 do
            table.insert(vehiclesnearby, {vehicle = vehicles[i]})
        end
        return vehiclesnearby
    end
end

function framework_GetVehicleData(vehicle)
    if ESX then
        return ESX.Game.GetVehicleProperties(vehicle)
    end
end