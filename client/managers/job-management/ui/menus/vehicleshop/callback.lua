function vehicleshop_buyVehicleandSetPlate(vehicleData, platePrefix, society, grade)
return lib.callback.await('ludaro_manager:buyVehicle', false, vehicleData, platePrefix, society, grade)
end
function vehicleshop_hasEnoughMoney(price)
return lib.callback.await('ludaro_manager:hasEnoughMoney', false, price)
end