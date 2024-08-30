--[[
    Callback Registration for Vehicle Purchase

    This callback handles the purchase of a vehicle by a player. It triggers the function to complete the purchase and register the vehicle.

    @param source (number): The source identifier of the player.
    @param vehicleData (table): The data related to the vehicle being purchased.
    @param platePrefix (string): The prefix to be used for the vehicle's plate.
    @param society (boolean): Whether the vehicle is being purchased for a society (true) or personally (false).
    @param grade (number): The grade of the job purchasing the vehicle.
    
    @return string: Returns the generated license plate of the purchased vehicle.
]]
lib.callback.register('ludaro_manager:buyVehicle', function(source, vehicleData, platePrefix, society, grade)
   return job_management_vehicleshop_buyVehicle(source, vehicleData, platePrefix, society, grade)
end)

--[[
   Callback Registration for Checking Player's Money

   This callback checks if the player has enough money to make a purchase.

   @param source (number): The source identifier of the player.
   @param price (number): The price to check against the player's available money.
   
   @return boolean: Returns true if the player has enough money, false otherwise.
]]
lib.callback.register('ludaro_manager:hasEnoughMoney', function(source, price)
   return job_management_vehicleshop_hasEnoughMoney(source, price)
end)
